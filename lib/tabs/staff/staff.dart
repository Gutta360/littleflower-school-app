import 'package:flutter/material.dart';

class StaffForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController fatherHusbandNameController;
  final TextEditingController aadharNoController;
  final TextEditingController educationalQualificationController;
  final TextEditingController otherSkillsController;
  final ValueNotifier<String?> maritalStatusController;
  final TextEditingController childrenController;
  final TextEditingController experienceController;
  final TextEditingController previousSalaryController;
  final TextEditingController expectedSalaryController;
  final TextEditingController currentSalaryController;
  final TextEditingController originalCertificatesController;
  final TextEditingController agreementPeriodController;

  const StaffForm({
    Key? key,
    required this.nameController,
    required this.fatherHusbandNameController,
    required this.aadharNoController,
    required this.educationalQualificationController,
    required this.otherSkillsController,
    required this.maritalStatusController,
    required this.childrenController,
    required this.experienceController,
    required this.previousSalaryController,
    required this.expectedSalaryController,
    required this.currentSalaryController,
    required this.originalCertificatesController,
    required this.agreementPeriodController,
  }) : super(key: key);

  @override
  _StaffFormState createState() => _StaffFormState();
}

class _StaffFormState extends State<StaffForm> {
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
        TextFormField(
          controller: widget.nameController,
          decoration: const InputDecoration(
            labelText: "Name",
            hintText: "Capitals and Space only. Ex: NAME SURNAME",
            prefixIcon: Icon(Icons.account_circle),
          ),
          onChanged: (value) {
            final uppercaseValue =
                value.toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '');
            if (value != uppercaseValue) {
              widget.nameController.value = TextEditingValue(
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
        _buildExTextField(
          controller: widget.fatherHusbandNameController,
          context: context,
          label: "Father's/Husband's Name",
          hint: "Capitals and Space only. Ex: NAME SURNAME",
          icon: Icons.person,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            final alphabeticValue =
                value.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');
            if (value != alphabeticValue) {
              widget.fatherHusbandNameController.value = TextEditingValue(
                text: alphabeticValue,
                selection:
                    TextSelection.collapsed(offset: alphabeticValue.length),
              );
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Father's/Husband's Name is required";
            }
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
              return "Only alphabets and spaces are allowed";
            }
            return null;
          },
        ),
        _buildExTextField(
          controller: widget.aadharNoController,
          context: context,
          label: "Aadhar No",
          hint: "Enter your 12 digit aadhar no",
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
            if (value != numericValue) {
              widget.aadharNoController.value = TextEditingValue(
                text: numericValue,
                selection: TextSelection.collapsed(offset: numericValue.length),
              );
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Aadhar No is required";
            }
            if (!RegExp(r'^\d{12}$').hasMatch(value)) {
              return "Aadhar No must be 12 digits";
            }
            return null;
          },
        ),
        _buildTextField(
          controller: widget.educationalQualificationController,
          context: context,
          hint: "ex: BTech in IT",
          label: "Educational Qualification",
          icon: Icons.school,
        ),
        _buildTextField(
          controller: widget.otherSkillsController,
          context: context,
          hint: "ex: certified trainer",
          label: "Other Skills",
          icon: Icons.settings,
        ),
        ValueListenableBuilder<String?>(
          valueListenable: widget.maritalStatusController,
          builder: (context, selectedStatus, child) {
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Marital Status",
                prefixIcon: Icon(Icons.family_restroom),
              ),
              value: selectedStatus,
              items: ["Single", "Married", "Divorced", "Widowed"]
                  .map((status) =>
                      DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) {
                widget.maritalStatusController.value = value;
              },
              validator: (value) => value == null || value.isEmpty
                  ? "Marital Status is required"
                  : null,
            );
          },
        ),
        _buildTextField(
          controller: widget.childrenController,
          context: context,
          label: "Children (If any)",
          hint: "ex: one boy (or) one boy and one girl",
          icon: Icons.child_care,
          keyboardType: TextInputType.number,
        ),
        _buildDecimalField(
          controller: widget.experienceController,
          context: context,
          label: "Experience (in years)",
          hint: "ex: 5.2",
          icon: Icons.work,
        ),
        _buildDecimalField(
          controller: widget.previousSalaryController,
          context: context,
          label: "Previous Salary",
          hint: "Enter decimal values only",
          icon: Icons.currency_rupee_outlined,
        ),
        _buildDecimalField(
          controller: widget.expectedSalaryController,
          context: context,
          label: "Expected Salary",
          hint: "Enter decimal values only",
          icon: Icons.money_off,
        ),
        _buildDecimalField(
          controller: widget.currentSalaryController,
          context: context,
          label: "Current Salary",
          hint: "Enter decimal values only",
          icon: Icons.money,
        ),
        _buildDecimalField(
          controller: widget.agreementPeriodController,
          context: context,
          label: "Agreement Period (In years)",
          hint: "ex: 3.5",
          icon: Icons.calendar_today,
        ),
        _buildTextField(
          controller: widget.originalCertificatesController,
          context: context,
          label: "Original Certificates Submitted",
          hint: "ex: SSC, Inter, BTech",
          icon: Icons.file_present,
        )
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required BuildContext context,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }

  Widget _buildExTextField({
    required TextEditingController controller,
    required BuildContext context,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
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
      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
}
