import 'package:flutter/material.dart';

class AddressForm extends StatelessWidget {
  final TextEditingController addressNameController;
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipCodeController;

  AddressForm({
    required this.addressNameController,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.cityController,
    required this.stateController,
    required this.zipCodeController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 10,
        ),
        children: [
          _buildTextField(
            controller: addressNameController,
            label: "Name",
            hint: "Capitals and Space only. Ex: SURNAME NAME",
            icon: Icons.account_circle,
            validator: _mandatoryValidator("Name is required"),
          ),
          _buildTextField(
            controller: addressLine1Controller,
            label: "Street Address Line 1",
            hint: "Ex: Door No, House Name, Street",
            icon: Icons.home,
            validator: _mandatoryValidator("Street Address Line 1 is required"),
          ),
          _buildTextField(
            controller: addressLine2Controller,
            label: "Street Address Line 2",
            hint: "Ex: Steet, Land mark",
            icon: Icons.home_outlined,
            validator: _mandatoryValidator("Street Address Line 2 is required"),
          ),
          _buildTextField(
            controller: cityController,
            label: "City",
            hint: "Ex: Vijayawada",
            icon: Icons.location_city,
            validator: _mandatoryValidator("City is required"),
          ),
          _buildTextField(
            controller: stateController,
            label: "State",
            hint: "Ex: Andhra Pradesh",
            icon: Icons.map,
            validator: _mandatoryValidator("State is required"),
          ),
          _buildTextField(
            controller: zipCodeController,
            label: "Zip Code",
            hint: "Enter your 6 digit pin code",
            icon: Icons.local_post_office,
            keyboardType: TextInputType.number,
            validator: _zipValidator,
          ),
        ],
      ),
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

  String? _zipValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Zip Code is required";
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "Only numeric values are allowed";
    } else if (value.length != 6) {
      return "Must be exactly 6 digits";
    }
    return null;
  }
}
