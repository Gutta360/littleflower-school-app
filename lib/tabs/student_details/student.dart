import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController totalFeeController;

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
  final TextEditingController emergencyNameController;
  final TextEditingController emergencyRelationshipController;
  final TextEditingController emergencyPhoneController;
  final TextEditingController addressNameController;
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipCodeController;
  final ValueNotifier<String?> placeInFamilyController;
  final ValueNotifier<String?> childrenAroundController;
  final TextEditingController attachedToController;
  final TextEditingController likingsController;
  final TextEditingController dislikingsController;

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
    required this.totalFeeController,
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
    required this.emergencyNameController,
    required this.emergencyRelationshipController,
    required this.emergencyPhoneController,
    required this.addressNameController,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.cityController,
    required this.stateController,
    required this.zipCodeController,
    required this.placeInFamilyController,
    required this.childrenAroundController,
    required this.attachedToController,
    required this.likingsController,
    required this.dislikingsController,
  }) : super(key: key);

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
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

  /// Fetch and populate the fields when a student is selected
  Future<void> _populateFields(String studentName) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('student_name', isEqualTo: studentName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          widget.dobController.text = data['student_dob'] ?? '';
          widget.motherTongueController.value = data['student_mother_tongue'];
          widget.gradeController.value = data['student_grade'];
          widget.genderController.value = data['student_gender'];
          widget.religionController.value = data['student_religion'];
          widget.nationalityController.value = data['student_nationality'];
          widget.casteController.value = data['student_caste'];
          widget.previousSchoolController.text =
              data['student_previous_school'] ?? '';
          widget.totalFeeController.text = data['student_total_fee'] ?? '';
          widget.fatherNameController.text = data['father_name'] ?? '';
          widget.fatherPhoneController.text = data['father_phone'] ?? '';
          widget.fatherEmailController.text = data['father_email'] ?? '';
          widget.fatherOccupationController.text =
              data['father_occupation'] ?? '';
          widget.motherNameController.text = data['mother_name'] ?? '';
          widget.motherPhoneController.text = data['mother_phone'] ?? '';
          widget.motherEmailController.text = data['mother_email'] ?? '';
          widget.motherOccupationController.text =
              data['mother_occupation'] ?? '';
          widget.sibling1Controller.text = data['sibling1_name'] ?? '';
          widget.sibling1SchoolController.text = data['sibling1_school'] ?? '';
          widget.sibling1ClassController.text = data['sibling1_class'] ?? '';
          widget.sibling2Controller.text = data['sibling2_name'] ?? '';
          widget.sibling2SchoolController.text = data['sibling2_school'] ?? '';
          widget.sibling2ClassController.text = data['sibling2_class'] ?? '';
          widget.emergencyNameController.text = data['emergency_name'] ?? '';
          widget.emergencyRelationshipController.text =
              data['emergency_relationship'] ?? '';
          widget.emergencyPhoneController.text = data['emergency_phone'] ?? '';
          widget.addressNameController.text = data['address_name'] ?? '';
          widget.addressLine1Controller.text = data['address_line1'] ?? '';
          widget.addressLine2Controller.text = data['address_line2'] ?? '';
          widget.cityController.text = data['address_city'] ?? '';
          widget.stateController.text = data['address_state'] ?? '';
          widget.zipCodeController.text = data['address_zip'] ?? '';
          widget.placeInFamilyController.value =
              data['physcological_placeofthechild'];
          widget.childrenAroundController.value =
              data['physcological_children_around'];
          widget.attachedToController.text =
              data['physcological_attachedto'] ?? '';
          widget.likingsController.text = data['physcological_likings'] ?? '';
          widget.dislikingsController.text =
              data['physcological_dislikings'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error populating fields: $e'),
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
              _populateFields(value);
            }
          },
          validator: (value) =>
              value == null || value.isEmpty ? "Name is required" : null,
        ),

        // Date of Birth Field
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

        _buildDecimalField(
          controller: widget.totalFeeController,
          context: context,
          label: "Total Fee",
          hint: "Enter decimal values only",
          icon: Icons.currency_rupee_outlined,
        ),
      ],
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
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
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
    );
  }
}
