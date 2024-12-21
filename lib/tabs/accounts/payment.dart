import 'dart:typed_data';
import 'dart:html' as html; // Import for web-specific functionality
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:percent_indicator/linear_percent_indicator.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({
    Key? key,
  }) : super(key: key);

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController paymentAmountController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController totalFeeController = TextEditingController();
  final TextEditingController totalPaidController = TextEditingController();

  final DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
  List<String> studentNames = [];
  String? selectedStudentName;

  @override
  void initState() {
    super.initState();
    _fetchStudentNames();
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

  /// Fetch additional student details based on selected name
  Future<void> _fetchStudentDetails(String studentName) async {
    try {
      QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('student_name', isEqualTo: studentName)
          .get();

      if (studentSnapshot.docs.isNotEmpty) {
        var data = studentSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          gradeController.text = data['student_grade'] ?? '';
          fatherNameController.text = data['father_name'] ?? '';
          phoneNumberController.text = data['father_phone'] ?? '';
          totalFeeController.text = data['student_total_fee']?.toString() ?? '';
        });
      }

      // Fetch total paid amount for the student
      QuerySnapshot paymentSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('student_name', isEqualTo: studentName)
          .get();

      double totalPaid = paymentSnapshot.docs.fold(0.0, (sum, doc) {
        return sum + (double.tryParse(doc['payment_amount'].toString()) ?? 0.0);
      });

      setState(() {
        totalPaidController.text = totalPaid.toStringAsFixed(2);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching student details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double percent = _calculateProgress(); // Calculate progress once
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
        child: Form(
          key: _formKey, // Assign a global key to the form
          child: Column(
            children: [
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 10,
                ),
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(Icons.account_circle),
                    ),
                    value: selectedStudentName,
                    items: studentNames
                        .map((name) =>
                            DropdownMenuItem(value: name, child: Text(name)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStudentName = value;
                        nameController.text = value ?? '';
                      });
                      if (value != null) {
                        _fetchStudentDetails(value);
                      }
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? "Name is required"
                        : null,
                  ),
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width * 0.2,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 20.0,
                    leading: Text(
                      "Paid: ${totalPaidController.text.isNotEmpty ? totalPaidController.text : "0.0"}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      "Total: ${totalFeeController.text.isNotEmpty ? totalFeeController.text : "0.0"}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    percent: percent,
                    center: Text(
                      "${(percent * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: _getProgressColor(percent),
                    backgroundColor: Colors.grey[300],
                  ),
                  _buildTextField(
                    controller: gradeController,
                    label: "Grade",
                    icon: Icons.grade,
                    isReadOnly: true,
                  ),
                  _buildTextField(
                    controller: fatherNameController,
                    label: "Father Name",
                    icon: Icons.person,
                    isReadOnly: true,
                  ),
                  _buildTextField(
                    controller: phoneNumberController,
                    label: "Phone Number",
                    icon: Icons.phone,
                    isReadOnly: true,
                  ),
                  _buildTextField(
                    controller: totalFeeController,
                    label: "Total Fee",
                    icon: Icons.attach_money,
                    isReadOnly: true,
                  ),
                  _buildTextField(
                    controller: totalPaidController,
                    label: "Total Paid",
                    icon: Icons.money,
                    isReadOnly: true,
                  ),
                  _buildDecimalField(
                    controller: paymentAmountController,
                    context: context,
                    label: "Amount",
                    hint: "Enter decimal values only",
                    icon: Icons.currency_rupee_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey[800],
                    minimumSize: const Size(120, 40), // Ensures the button size
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }

  Color _getProgressColor(double percent) {
    if (percent <= 0.24) {
      return Colors.red;
    } else if (percent <= 0.49) {
      return Colors.orange;
    } else if (percent <= 0.74) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isReadOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  /// Calculate the progress percentage based on totalPaidController and totalFeeController
  double _calculateProgress() {
    double totalPaid =
        double.tryParse(totalPaidController.text) ?? 0.0; // Parse total paid
    double totalFee =
        double.tryParse(totalFeeController.text) ?? 1.0; // Parse total fee
    return (totalPaid / totalFee).clamp(0.0, 1.0); // Ensure it's within 0-1
  }

  Widget _buildDecimalField({
    required TextEditingController controller,
    required BuildContext context,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        final decimalValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
        if (value != decimalValue) {
          controller.value = TextEditingValue(
            text: decimalValue,
            selection: TextSelection.collapsed(offset: decimalValue.length),
          );
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
          return "Only decimal values are allowed";
        }
        return null;
      },
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      // Fetch the current counter value from Firestore
      DocumentSnapshot counterDoc = await FirebaseFirestore.instance
          .collection("counters")
          .doc("payment_counter")
          .get();

      int currentCounter = counterDoc["value"];
      String paymentId = "BILL${currentCounter.toString().padLeft(4, '0')}";

      // Get the current date as a Timestamp
      Timestamp currentTimestamp = Timestamp.now();
      String formattedDate = dateFormat.format(currentTimestamp.toDate());

      // Save the form data to the "payments" collection
      await FirebaseFirestore.instance
          .collection("payments")
          .doc(paymentId)
          .set({
        "id": paymentId,
        "student_name": nameController.text,
        "father_name": fatherNameController.text,
        "grade": gradeController.text,
        "phone_number": phoneNumberController.text,
        "payment_amount": paymentAmountController.text,
        "payment_date": currentTimestamp, // Save the timestamp
      });

      // Increment the counter in Firestore
      await FirebaseFirestore.instance
          .collection("counters")
          .doc("payment_counter")
          .update({"value": currentCounter + 1});

      // Show the details dialog with the submitted data
      _showDetailsDialog(
        date: formattedDate,
        name: nameController.text,
        grade: gradeController.text,
        fathername: fatherNameController.text,
        phonenumber: phoneNumberController.text,
        amount: paymentAmountController.text,
        billId: paymentId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    }
  }

  Future<void> _generatePdfWeb(
      String date,
      String name,
      String grade,
      String fathername,
      String phonenumber,
      String amount,
      String billId) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Bill ID: $billId',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Date: $date',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Name: $name',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Grade: $grade',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Father Name: $fathername',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Phone Number: $phonenumber',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Paid Amount: $amount',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    try {
      Uint8List pdfBytes = await pdf.save();
      final blob = html.Blob([pdfBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = '$billId.pdf'
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save PDF: $e")),
      );
    }
  }

  void _showDetailsDialog({
    required String date,
    required String name,
    required String grade,
    required String fathername,
    required String phonenumber,
    required String amount,
    required String billId,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: const Text('Payment Details'),
          content: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date:        $date',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Name:        $name',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Grade:       $grade',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Father Name:       $fathername',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Phone Number:       $phonenumber',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Paid Amount: $amount',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Bill ID:     $billId',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (kIsWeb) {
                  await _generatePdfWeb(date, name, grade, fathername,
                      phonenumber, amount, billId);
                }
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Print'),
            ),
          ],
        );
      },
    );
  }
}
