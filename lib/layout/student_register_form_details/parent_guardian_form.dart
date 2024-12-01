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
            TextFormField(
              controller: fatherNameController,
              decoration: const InputDecoration(
                labelText: "Father Name",
                hintText: "Capitals and Space only. Ex: NAME SURNAME",
                prefixIcon: Icon(Icons.account_circle),
              ),
              onChanged: (value) {
                final uppercaseValue =
                    value.toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '');
                if (value != uppercaseValue) {
                  fatherNameController.value = TextEditingValue(
                    text: uppercaseValue,
                    selection:
                        TextSelection.collapsed(offset: uppercaseValue.length),
                  );
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Father Name is required";
                }
                if (!RegExp(r'^[A-Z\s]+$').hasMatch(value)) {
                  return "Only capital letters and spaces are allowed";
                }
                return null;
              },
            ),
            TextFormField(
              controller: fatherPhoneController,
              decoration: const InputDecoration(
                labelText: "Father Phone",
                hintText: "Enter your 10 digit phone number",
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final digitValue = value.replaceAll(
                    RegExp(r'[^0-9]'), ''); // Allow only digits
                if (digitValue.length > 10) {
                  fatherPhoneController.value = TextEditingValue(
                    text: digitValue.substring(0, 10), // Restrict to 10 digits
                    selection: TextSelection.collapsed(offset: 10),
                  );
                } else {
                  fatherPhoneController.value = TextEditingValue(
                    text: digitValue,
                    selection:
                        TextSelection.collapsed(offset: digitValue.length),
                  );
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Father Phone is required";
                }
                if (value.length != 10) {
                  return "Must be exactly 10 digits";
                }
                return null;
              },
            ),
            _buildTextField(
              controller: fatherEmailController,
              label: "Father Email",
              hint: "Ex: yourname@gmail.com",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
            _buildTextField(
              controller: fatherOccupationController,
              label: "Father Occupation",
              hint: "Ex: business or doctor",
              icon: Icons.work,
              validator: _mandatoryValidator("Father Occupation is required"),
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
            TextFormField(
              controller: motherNameController,
              decoration: const InputDecoration(
                labelText: "Mother Name",
                hintText: "Capitals and Space only. Ex: NAME SURNAME",
                prefixIcon: Icon(Icons.account_circle),
              ),
              onChanged: (value) {
                final uppercaseValue =
                    value.toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '');
                if (value != uppercaseValue) {
                  motherNameController.value = TextEditingValue(
                    text: uppercaseValue,
                    selection:
                        TextSelection.collapsed(offset: uppercaseValue.length),
                  );
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Mother Name is required";
                }
                if (!RegExp(r'^[A-Z\s]+$').hasMatch(value)) {
                  return "Only capital letters and spaces are allowed";
                }
                return null;
              },
            ),
            TextFormField(
              controller: motherPhoneController,
              decoration: const InputDecoration(
                labelText: "Mother Phone",
                hintText: "Enter your 10 digit phone number",
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final digitValue = value.replaceAll(
                    RegExp(r'[^0-9]'), ''); // Allow only digits
                if (digitValue.length > 10) {
                  motherPhoneController.value = TextEditingValue(
                    text: digitValue.substring(0, 10), // Restrict to 10 digits
                    selection: TextSelection.collapsed(offset: 10),
                  );
                } else {
                  motherPhoneController.value = TextEditingValue(
                    text: digitValue,
                    selection:
                        TextSelection.collapsed(offset: digitValue.length),
                  );
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Mother Phone is required";
                }
                if (value.length != 10) {
                  return "Must be exactly 10 digits";
                }
                return null;
              },
            ),
            _buildTextField(
              controller: motherEmailController,
              label: "Mother Email",
              hint: "Ex: yourname@gmail.com",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
            _buildTextField(
              controller: motherOccupationController,
              label: "Mother Occupation",
              hint: "Ex: home maker or doctor",
              icon: Icons.work,
              validator: _mandatoryValidator("Mother Occupation is required"),
            ),
          ],
        ),
        const SizedBox(height: 40),
        const Text(
          "Sibling Details",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: sibling1Controller,
                decoration: const InputDecoration(
                  labelText: "Sibling 1",
                  hintText: "Capitals and Space only. Ex: VARUN TEJ",
                  prefixIcon: Icon(Icons.account_circle),
                ),
                onChanged: (value) {
                  final uppercaseValue =
                      value.toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '');
                  if (value != uppercaseValue) {
                    sibling1Controller.value = TextEditingValue(
                      text: uppercaseValue,
                      selection: TextSelection.collapsed(
                          offset: uppercaseValue.length),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Sibling 1 is required";
                  }
                  if (!RegExp(r'^[A-Z\s]+$').hasMatch(value)) {
                    return "Only capital letters and spaces are allowed";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: sibling1SchoolController,
                label: "School Name",
                hint: "Enter School Name",
                icon: Icons.school,
                validator: _mandatoryValidator("School Name is required"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: sibling1ClassController,
                label: "Class At",
                hint: "Ex: 1",
                icon: Icons.grade,
                validator: _mandatoryValidator("Class At is required"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: sibling2Controller,
                decoration: const InputDecoration(
                  labelText: "Sibling 2",
                  hintText: "Capitals and Space only. Ex: VARUN TEJ",
                  prefixIcon: Icon(Icons.account_circle),
                ),
                onChanged: (value) {
                  final uppercaseValue =
                      value.toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '');
                  if (value != uppercaseValue) {
                    sibling2Controller.value = TextEditingValue(
                      text: uppercaseValue,
                      selection: TextSelection.collapsed(
                          offset: uppercaseValue.length),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Sibling 2 is required";
                  }
                  if (!RegExp(r'^[A-Z\s]+$').hasMatch(value)) {
                    return "Only capital letters and spaces are allowed";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: sibling2SchoolController,
                label: "School Name",
                hint: "Ex: Enter School Name",
                icon: Icons.school,
                validator: _mandatoryValidator("School Name is required"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: sibling2ClassController,
                label: "Class At",
                hint: "Ex: 1",
                icon: Icons.grade,
                validator: _mandatoryValidator("Class At is required"),
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

  String? Function(String?) _mandatoryValidator(String errorMessage) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return errorMessage;
      }
      return null;
    };
  }
}
