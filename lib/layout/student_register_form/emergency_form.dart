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
        _buildTextField(
          controller: emergencyNameController,
          label: "Name",
          icon: Icons.account_circle,
          validator: _mandatoryValidator("Name is required"),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: emergencyRelationshipController,
          label: "Relationship",
          icon: Icons.family_restroom,
          validator: _mandatoryValidator("Relationship is required"),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: emergencyPhoneController,
          label: "Phone",
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: _phoneValidator,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
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

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone is required";
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "Only numeric values are allowed";
    } else if (value.length != 10) {
      return "Must be exactly 10 digits";
    }
    return null;
  }
}
