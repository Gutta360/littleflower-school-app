import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolRegistrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Registration',
      home: SchoolRegistrationForm(),
    );
  }
}

class SchoolRegistrationForm extends StatefulWidget {
  @override
  _SchoolRegistrationFormState createState() => _SchoolRegistrationFormState();
}

class _SchoolRegistrationFormState extends State<SchoolRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Example form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      // Fetch the current counter value from Firestore
      DocumentSnapshot counterDoc = await FirebaseFirestore.instance
          .collection("counters")
          .doc("staff_counter")
          .get();

      int currentCounter = counterDoc["value"];
      String studentId = "STU${currentCounter.toString().padLeft(4, '0')}";

      // Save the form data to the "students" collection
      await FirebaseFirestore.instance
          .collection("students")
          .doc(studentId)
          .set({
        "id": studentId,
        "name": _nameController.text,
        "father_name": _fatherNameController.text,
        "mother_name": _motherNameController.text,
        // Add other fields as necessary
      });

      // Increment the counter in Firestore
      await FirebaseFirestore.instance
          .collection("counters")
          .doc("staff_counter")
          .update({"value": currentCounter + 1});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _buildStudentForm(),
                  _buildParentGuardianForm(),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Student Name",
              prefixIcon: Icon(Icons.account_circle),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? "Name is required" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildParentGuardianForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _fatherNameController,
            decoration: InputDecoration(
              labelText: "Father's Name",
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) => value == null || value.isEmpty
                ? "Father's name is required"
                : null,
          ),
          TextFormField(
            controller: _motherNameController,
            decoration: InputDecoration(
              labelText: "Mother's Name",
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) => value == null || value.isEmpty
                ? "Mother's name is required"
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep > 0)
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep--;
              });
            },
            child: Text("Back"),
          ),
        ElevatedButton(
          onPressed: () {
            if (_currentStep < 1) {
              setState(() {
                _currentStep++;
              });
            } else {
              _saveForm();
            }
          },
          child: Text(_currentStep < 1 ? "Next" : "Save"),
        ),
      ],
    );
  }
}
