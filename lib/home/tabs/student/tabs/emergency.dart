import 'package:flutter/material.dart';

class EmergencyForm extends StatelessWidget {
  final TextEditingController emergencyNameController;
  final TextEditingController emergencyRelationshipController;
  final TextEditingController emergencyPhoneController;

  EmergencyForm({
    required this.emergencyNameController,
    required this.emergencyRelationshipController,
    required this.emergencyPhoneController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 400.0, vertical: 16.0),
      children: [
        TextFormField(
          controller: emergencyNameController,
          decoration: const InputDecoration(
            labelText: "Name",
            hintText: "Capitals and Space only. Ex: NAME SURNAME",
            prefixIcon: Icon(Icons.account_circle),
          ),
          onChanged: (value) {
            final uppercaseValue =
                value.toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '');
            if (value != uppercaseValue) {
              emergencyNameController.value = TextEditingValue(
                text: uppercaseValue,
                selection:
                    TextSelection.collapsed(offset: uppercaseValue.length),
              );
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Name is required";
            }
            if (!RegExp(r'^[A-Z\s]+$').hasMatch(value)) {
              return "Only capital letters and spaces are allowed";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: emergencyRelationshipController,
          label: "Relationship",
          hint: "uncle or aunt",
          icon: Icons.family_restroom,
          validator: _mandatoryValidator("Relationship is required"),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: emergencyPhoneController,
          decoration: const InputDecoration(
            labelText: "Phone",
            hintText: "Enter your 10 digit phone number",
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final digitValue =
                value.replaceAll(RegExp(r'[^0-9]'), ''); // Allow only digits
            if (digitValue.length > 10) {
              emergencyPhoneController.value = TextEditingValue(
                text: digitValue.substring(0, 10), // Restrict to 10 digits
                selection: TextSelection.collapsed(offset: 10),
              );
            } else {
              emergencyPhoneController.value = TextEditingValue(
                text: digitValue,
                selection: TextSelection.collapsed(offset: digitValue.length),
              );
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Phone number is required";
            }
            if (value.length != 10) {
              return "Must be exactly 10 digits";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  String? Function(String?) _mandatoryValidator(String errorMessage) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return errorMessage;
      }
      return null;
    };
  }
}
