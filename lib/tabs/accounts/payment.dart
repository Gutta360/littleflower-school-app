import 'dart:typed_data';
import 'dart:html' as html; // Import for web-specific functionality
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart'; // For kIsWeb

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

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          padding:
              const EdgeInsets.symmetric(horizontal: 400.0, vertical: 25.0),
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
              },
              validator: (value) =>
                  value == null || value.isEmpty ? "Name is required" : null,
            ),
            const SizedBox(height: 16),
            _buildDecimalField(
              controller: paymentAmountController,
              context: context,
              label: "Amount",
              hint: "Enter decimal values only",
              icon: Icons.currency_rupee_outlined,
            ),
            const SizedBox(height: 38),
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
        ));
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

  void _showDetailsDialog({
    required String date,
    required String name,
    required String grade,
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
                  await _generatePdfWeb(date, name, grade, amount, billId);
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

      // Simulate a grade for demonstration (replace with actual grade if available)
      String grade = "1";

      // Save the form data to the "payments" collection
      await FirebaseFirestore.instance
          .collection("payments")
          .doc(paymentId)
          .set({
        "id": paymentId,
        "student_name": nameController.text,
        "amount": paymentAmountController.text,
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
        grade: grade,
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

  Future<void> _generatePdfWeb(String date, String name, String grade,
      String amount, String billId) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Date:        $date', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 8),
              pw.Text('Name:        $name', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 8),
              pw.Text('Grade:       $grade', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 8),
              pw.Text('Paid Amount: $amount',
                  style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 8),
              pw.Text('Bill ID:     $billId',
                  style: pw.TextStyle(fontSize: 16)),
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
}
