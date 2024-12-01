import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController dobController;
  final ValueNotifier<String?> motherTongueController;
  final ValueNotifier<String?> gradeController;
  final ValueNotifier<String?> genderController;
  final ValueNotifier<String?> religionController;
  final ValueNotifier<String?> nationalityController;
  final ValueNotifier<String?> casteController;
  final TextEditingController previousSchoolController;

  const StudentForm({
    Key? key,
    required this.nameController,
    required this.dobController,
    required this.motherTongueController,
    required this.gradeController,
    required this.genderController,
    required this.religionController,
    required this.nationalityController,
    required this.casteController,
    required this.previousSchoolController,
  }) : super(key: key);

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final DateFormat dateFormat = DateFormat("dd-MMM-yyyy");

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
        // Updated Name Field
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

        _buildDatePickerField(context),
        // Mother Tongue Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: widget.motherTongueController,
          builder: (context, selectedMotherTongue, child) {
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Mother Tongue",
                prefixIcon: Icon(Icons.language),
              ),
              value: selectedMotherTongue,
              items: ["TELUGU", "HINDI", "ENGLISH"]
                  .map((tongue) =>
                      DropdownMenuItem(value: tongue, child: Text(tongue)))
                  .toList(),
              onChanged: (value) {
                widget.motherTongueController.value = value;
              },
              validator: (value) => value == null || value.isEmpty
                  ? "Mother Tongue is required"
                  : null,
            );
          },
        ),

        // Gender Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: widget.genderController,
          builder: (context, selectedGender, child) {
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Gender",
                prefixIcon: Icon(Icons.person),
              ),
              value: selectedGender,
              items: ["MALE", "FEMALE"]
                  .map((gender) =>
                      DropdownMenuItem(value: gender, child: Text(gender)))
                  .toList(),
              onChanged: (value) {
                widget.genderController.value = value;
              },
              validator: (value) =>
                  value == null || value.isEmpty ? "Gender is required" : null,
            );
          },
        ),

        // Grade Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: widget.gradeController,
          builder: (context, selectedGrade, child) {
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Grade",
                prefixIcon: Icon(Icons.school),
              ),
              value: selectedGrade,
              items: [
                "PP1",
                "PP2",
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
                "10"
              ]
                  .map((grade) =>
                      DropdownMenuItem(value: grade, child: Text(grade)))
                  .toList(),
              onChanged: (value) {
                widget.gradeController.value = value;
              },
              validator: (value) =>
                  value == null || value.isEmpty ? "Grade is required" : null,
            );
          },
        ),

        // Caste Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: widget.casteController,
          builder: (context, selectedCaste, child) {
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Caste",
                prefixIcon: Icon(Icons.group),
              ),
              value: selectedCaste,
              items: ["SC", "ST", "BC", "OC", "GEN"]
                  .map((caste) =>
                      DropdownMenuItem(value: caste, child: Text(caste)))
                  .toList(),
              onChanged: (value) {
                widget.casteController.value = value;
              },
              validator: (value) =>
                  value == null || value.isEmpty ? "Caste is required" : null,
            );
          },
        ),

        // Religion Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: widget.religionController,
          builder: (context, selectedReligion, child) {
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Religion",
                prefixIcon: Icon(Icons.account_balance),
              ),
              value: selectedReligion,
              items: ["Hindu", "Muslim", "Christian", "Sikh"]
                  .map((religion) =>
                      DropdownMenuItem(value: religion, child: Text(religion)))
                  .toList(),
              onChanged: (value) {
                widget.religionController.value = value;
              },
              validator: (value) => value == null || value.isEmpty
                  ? "Religion is required"
                  : null,
            );
          },
        ),

        // Nationality Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: widget.nationalityController,
          builder: (context, selectedNationality, child) {
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Nationality",
                prefixIcon: Icon(Icons.flag),
              ),
              value: selectedNationality,
              items: ["Indian", "Foreigner"]
                  .map((nationality) => DropdownMenuItem(
                      value: nationality, child: Text(nationality)))
                  .toList(),
              onChanged: (value) {
                widget.nationalityController.value = value;
              },
              validator: (value) => value == null || value.isEmpty
                  ? "Nationality is required"
                  : null,
            );
          },
        ),

        // Previous School Field
        _buildTextField(
          controller: widget.previousSchoolController,
          context: context,
          label: "Previous School",
          hint: "Enter Previous School Name",
          icon: Icons.apartment,
          onChanged: (value) {},
          validator: (value) => value == null || value.isEmpty
              ? "Previous School is required"
              : null,
        ),
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

  Widget _buildDatePickerField(BuildContext context) {
    final DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              setState(() {
                //_selectedDate = pickedDate;
                widget.dobController.text = dateFormat.format(pickedDate);
              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: widget.dobController,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Date of Birth is required'
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
