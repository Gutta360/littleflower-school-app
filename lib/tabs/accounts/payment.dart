import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
                hintText: "Capitals and Space only. Ex: NAME SURNAME",
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
                  backgroundColor: Colors.blue,
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _showError("Please fill all required fields");
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    }
  }
}
