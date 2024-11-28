import 'package:flutter/material.dart';

class ParentGuardianForm extends StatelessWidget {
  final TextEditingController fatherNameController;
  final TextEditingController fatherPhoneController;
  final TextEditingController fatherEmailController;
  final TextEditingController fatherOccupationController;
  final TextEditingController motherNameController;
  final TextEditingController motherPhoneController;
  final TextEditingController motherEmailController;
  final TextEditingController motherOccupationController;
  final TextEditingController sibling1Controller;
  final TextEditingController sibling1SchoolController;
  final TextEditingController sibling1ClassController;
  final TextEditingController sibling2Controller;
  final TextEditingController sibling2SchoolController;
  final TextEditingController sibling2ClassController;

  ParentGuardianForm({
    required this.fatherNameController,
    required this.fatherPhoneController,
    required this.fatherEmailController,
    required this.fatherOccupationController,
    required this.motherNameController,
    required this.motherPhoneController,
    required this.motherEmailController,
    required this.motherOccupationController,
    required this.sibling1Controller,
    required this.sibling1SchoolController,
    required this.sibling1ClassController,
    required this.sibling2Controller,
    required this.sibling2SchoolController,
    required this.sibling2ClassController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0),
      children: [
        Text(
          "Father Details",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 8,
          ),
          children: [
            _buildTextField(
              controller: fatherNameController,
              label: "Father Name",
              icon: Icons.account_circle,
            ),
            _buildTextField(
              controller: fatherPhoneController,
              label: "Father Phone",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: _phoneValidator,
            ),
            _buildTextField(
              controller: fatherEmailController,
              label: "Father Email",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
            _buildTextField(
              controller: fatherOccupationController,
              label: "Father Occupation",
              icon: Icons.work,
            ),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          "Mother Details",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 8,
          ),
          children: [
            _buildTextField(
              controller: motherNameController,
              label: "Mother Name",
              icon: Icons.account_circle,
            ),
            _buildTextField(
              controller: motherPhoneController,
              label: "Mother Phone",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: _phoneValidator,
            ),
            _buildTextField(
              controller: motherEmailController,
              label: "Mother Email",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
            _buildTextField(
              controller: motherOccupationController,
              label: "Mother Occupation",
              icon: Icons.work,
            ),
          ],
        ),

        const SizedBox(height: 40),
        // Sibling Details
        Text(
          "Sibling Details",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        // Sibling 1 Row
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: sibling1Controller,
                label: "Sibling 1",
                icon: Icons.child_care,
                validator: (value) => value == null || value.isEmpty
                    ? "Sibling 1 is required"
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: sibling1SchoolController,
                label: "School Name",
                icon: Icons.school,
                validator: (value) => value == null || value.isEmpty
                    ? "School Name is required"
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: sibling1ClassController,
                label: "Class At",
                icon: Icons.grade,
                validator: (value) => value == null || value.isEmpty
                    ? "Class At is required"
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Sibling 2 Row
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: sibling2Controller,
                label: "Sibling 2",
                icon: Icons.child_care,
                validator: (value) => value == null || value.isEmpty
                    ? "Sibling 2 is required"
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: sibling2SchoolController,
                label: "School Name",
                icon: Icons.school,
                validator: (value) => value == null || value.isEmpty
                    ? "School Name is required"
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: sibling2ClassController,
                label: "Class At",
                icon: Icons.grade,
                validator: (value) => value == null || value.isEmpty
                    ? "Class At is required"
                    : null,
              ),
            ),
          ],
        )
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

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (!RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
        .hasMatch(value)) {
      return "Invalid email format";
    }
    return null;
  }
}
