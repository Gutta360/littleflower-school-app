import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PaymentForm extends StatefulWidget {
  final TextEditingController nameController;
  const PaymentForm({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
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
    return GridView(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 6,
      ),
      children: [
        // Updated Name Field as Dropdown
        DropdownButtonFormField<String>(
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
              widget.nameController.text = value ?? '';
            });
            if (value != null) {
              //_populateFields(value);
            }
          },
          validator: (value) =>
              value == null || value.isEmpty ? "Name is required" : null,
        )
      ],
    );
  }
}
