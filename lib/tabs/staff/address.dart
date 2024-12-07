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
          TextFormField(
            controller: addressNameController,
            decoration: const InputDecoration(
              labelText: "Name",
              hintText: "Capitals and Space only. Ex: NAME SURNAME",
              prefixIcon: Icon(Icons.account_circle),
            ),
            onChanged: (value) {
              final uppercaseValue =
                  value.toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '');
              if (value != uppercaseValue) {
                addressNameController.value = TextEditingValue(
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
          TextFormField(
            controller: zipCodeController,
            decoration: const InputDecoration(
              labelText: "Zip Code",
              hintText: "Enter your 6 digit pin code",
              prefixIcon: Icon(Icons.local_post_office),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final digitValue =
                  value.replaceAll(RegExp(r'[^0-9]'), ''); // Allow only digits
              if (digitValue.length > 6) {
                zipCodeController.value = TextEditingValue(
                  text: digitValue.substring(0, 6), // Restrict to 6 digits
                  selection: TextSelection.collapsed(offset: 6),
                );
              } else {
                zipCodeController.value = TextEditingValue(
                  text: digitValue,
                  selection: TextSelection.collapsed(offset: digitValue.length),
                );
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Zip Code is required";
              }
              if (value.length != 6) {
                return "Must be exactly 6 digits";
              }
              return null;
            },
          )
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
}
