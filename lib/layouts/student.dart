import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentFormWidget extends StatefulWidget {
  const StudentFormWidget({super.key});

  @override
  State<StudentFormWidget> createState() => _StudentFormWidgetState();
}

class _StudentFormWidgetState extends State<StudentFormWidget> {
  final TextEditingController _adminnoController = TextEditingController();
  final TextEditingController _studentnameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _studentaadharController = TextEditingController();
  final TextEditingController _fathernameController = TextEditingController();
  final TextEditingController _fatheraadharController = TextEditingController();
  final TextEditingController _fatherOccupationController = TextEditingController();
  final TextEditingController _fatherphnoController = TextEditingController();
  final TextEditingController _mothernameController = TextEditingController();
  final TextEditingController _motheraadharController = TextEditingController();
  final TextEditingController _motherOccupationController = TextEditingController();
  final TextEditingController _motherphnoController = TextEditingController();
  final TextEditingController _casteController = TextEditingController();
  final TextEditingController _subcasteController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: _inputDecoration(label),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Future<void> _saveStudent() async {
    if (_formKey.currentState?.validate() ?? false) {
      await FirebaseFirestore.instance.collection("students").doc(_adminnoController.text).set({
        "adminno": _adminnoController.text,
        "studentname": _studentnameController.text,
        "class": _classController.text,
        "section": _sectionController.text,
        "studentaadhar": _studentaadharController.text,
        "fathername": _fathernameController.text,
        "fatheraadhar": _fatheraadharController.text,
        "fatherOccupation": _fatherOccupationController.text,
        "fatherphno": _fatherphnoController.text,
        "mothername": _mothernameController.text,
        "motheraadhar": _motheraadharController.text,
        "motherOccupation": _motherOccupationController.text,
        "motherphno": _motherphnoController.text,
        "caste": _casteController.text,
        "subcaste": _subcasteController.text,
        "fee": _feeController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Student saved")));
    }
  }

  Widget _buildFieldGroup(String title, List<List<dynamic>> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 8.0, bottom: 8),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Column(
          children: List.generate((fields.length / 2).ceil(), (index) {
            int first = index * 2;
            int second = first + 1;
            return Row(
              children: [
                Expanded(child: _buildTextField(fields[first][0] as TextEditingController, fields[first][1] as String)),
                if (second < fields.length)
                  Expanded(child: _buildTextField(fields[second][0] as TextEditingController, fields[second][1] as String)),
              ],
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentFields = [
      [_adminnoController, "Admin No"],
      [_studentnameController, "Student Name"],
      [_classController, "Class"],
      [_sectionController, "Section"],
      [_studentaadharController, "Student Aadhar"],
      [_casteController, "Caste"],
      [_subcasteController, "Subcaste"],
      [_feeController, "Fee"],
    ];

    final fatherFields = [
      [_fathernameController, "Father Name"],
      [_fatheraadharController, "Father Aadhar"],
      [_fatherOccupationController, "Father Occupation"],
      [_fatherphnoController, "Father Phone"],
    ];

    final motherFields = [
      [_mothernameController, "Mother Name"],
      [_motheraadharController, "Mother Aadhar"],
      [_motherOccupationController, "Mother Occupation"],
      [_motherphnoController, "Mother Phone"],
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Student Form")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 96.0), // 1 inch = 96 pixels
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              _buildFieldGroup("Student Details", studentFields),
              _buildFieldGroup("Father Details", fatherFields),
              _buildFieldGroup("Mother Details", motherFields),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: _saveStudent, child: Text("SAVE")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
