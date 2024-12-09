import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PaymentDetailsForm extends StatefulWidget {
  const PaymentDetailsForm({
    Key? key,
  }) : super(key: key);

  @override
  _PaymentDetailsFormState createState() => _PaymentDetailsFormState();
}

class _PaymentDetailsFormState extends State<PaymentDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
  List<String> studentNames = [];
  String? selectedStudentName;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    _setDefaultDates();
    _fetchStudentNames();
  }

  /// Set the default "From Date" and "To Date"
  void _setDefaultDates() {
    DateTime lastYearDate = DateTime.now().subtract(const Duration(days: 365));
    fromDate = lastYearDate;
    fromDateController.text = dateFormat.format(lastYearDate);

    DateTime currentDate = DateTime.now();
    toDate = currentDate;
    toDateController.text = dateFormat.format(currentDate);
  }

  /// Fetch all student names from Firestore
  Future<void> _fetchStudentNames() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('students').get();

      setState(() {
        studentNames =
            snapshot.docs.map((doc) => doc['student_name'] as String).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching student names: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Fetch payment records from Firestore based on the selected student name and date range
  Stream<List<Map<String, dynamic>>> _fetchPayments(String studentName) {
    Query query = FirebaseFirestore.instance
        .collection('payments')
        .where('student_name', isEqualTo: studentName);

    if (fromDate != null) {
      query = query.where('payment_date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate!));
    }

    if (toDate != null) {
      query = query.where('payment_date',
          isLessThanOrEqualTo: Timestamp.fromDate(toDate!));
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0),
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 8,
            children: [
              _buildNameDropDownField(context),
              _buildDatePickerField(
                context,
                'From Date',
                fromDateController,
                (pickedDate) {
                  setState(() {
                    fromDate = pickedDate;
                    if (toDate != null && pickedDate.isAfter(toDate!)) {
                      toDate = null;
                      toDateController.clear();
                    }
                  });
                },
              ),
              _buildDatePickerField(
                context,
                'To Date',
                toDateController,
                (pickedDate) {
                  setState(() {
                    toDate = pickedDate;
                  });
                },
                validateToDate: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (selectedStudentName != null) ...[
            const Text(
              'Payment Records',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _renderDataTable(context),
          ],
        ],
      ),
    );
  }

  Widget _buildNameDropDownField(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Name",
        hintText: "Capitals and Space only. Ex: NAME SURNAME",
        prefixIcon: Icon(Icons.account_circle),
      ),
      value: selectedStudentName,
      items: studentNames
          .map((name) => DropdownMenuItem(value: name, child: Text(name)))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedStudentName = value;
        });
      },
      validator: (value) =>
          value == null || value.isEmpty ? "Name is required" : null,
    );
  }

  Widget _buildDatePickerField(BuildContext context, String label,
      TextEditingController controller, Function(DateTime) onDateSelected,
      {bool validateToDate = false}) {
    return GestureDetector(
      onTap: () async {
        DateTime initialDate = validateToDate && fromDate != null
            ? fromDate!.add(const Duration(days: 1))
            : DateTime.now();

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: validateToDate && fromDate != null
              ? fromDate!.add(const Duration(days: 1))
              : DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = dateFormat.format(pickedDate);
            onDateSelected(pickedDate);
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            if (validateToDate && fromDate != null) {
              final selectedDate =
                  dateFormat.parse(controller.text, true).toLocal();
              if (selectedDate.isBefore(fromDate!)) {
                return 'To Date must be after From Date';
              }
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _renderDataTable(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _fetchPayments(selectedStudentName!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final paymentRecords = snapshot.data ?? [];

        if (paymentRecords.isEmpty) {
          return const Text('No payment records found.');
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Bill Id')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Payment Date')),
            ],
            rows: paymentRecords.map((record) {
              return DataRow(
                cells: [
                  DataCell(Text(record['id'] ?? '')),
                  DataCell(Text(record['amount'] ?? '')),
                  DataCell(Text(record['payment_date'] != null
                      ? dateFormat.format(
                          (record['payment_date'] as Timestamp).toDate())
                      : '')),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
