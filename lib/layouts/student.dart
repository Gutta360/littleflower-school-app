import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:littleflower/tabs/student/address.dart';
import 'package:littleflower/tabs/student/emergency.dart';
import 'package:littleflower/tabs/student/parent_guardian.dart';
import 'package:littleflower/tabs/student/physiological.dart';
import 'package:littleflower/tabs/student/student.dart';

class StudentLayout extends StatefulWidget {
  @override
  _StudentLayoutState createState() => _StudentLayoutState();
}

class _StudentLayoutState extends State<StudentLayout> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final ValueNotifier<String?> _motherTongueController =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _gradeController = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _genderController = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _religionController =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _nationalityController =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _casteController = ValueNotifier<String?>(null);
  final TextEditingController _previousSchoolController =
      TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _fatherPhoneController = TextEditingController();
  final TextEditingController _fatherEmailController = TextEditingController();
  final TextEditingController _fatherOccupationController =
      TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _motherPhoneController = TextEditingController();
  final TextEditingController _motherEmailController = TextEditingController();
  final TextEditingController _motherOccupationController =
      TextEditingController();
  final TextEditingController _sibling1Controller = TextEditingController();
  final TextEditingController _sibling1SchoolController =
      TextEditingController();
  final TextEditingController _sibling1ClassController =
      TextEditingController();
  final TextEditingController _sibling2Controller = TextEditingController();
  final TextEditingController _sibling2SchoolController =
      TextEditingController();
  final TextEditingController _sibling2ClassController =
      TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyRelationshipController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final ValueNotifier<String?> _placeInFamilyController =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _childrenAroundController =
      ValueNotifier<String?>(null);
  final TextEditingController _attachedToController = TextEditingController();
  final TextEditingController _likingsController = TextEditingController();
  final TextEditingController _dislikingsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildStepProgressIndicatorWithIcons(),
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  StudentForm(
                    nameController: _nameController,
                    dobController: _dobController,
                    motherTongueController: _motherTongueController,
                    gradeController: _gradeController,
                    genderController: _genderController,
                    religionController: _religionController,
                    nationalityController: _nationalityController,
                    casteController: _casteController,
                    previousSchoolController: _previousSchoolController,
                  ),
                  ParentGuardianForm(
                    fatherNameController: _fatherNameController,
                    fatherPhoneController: _fatherPhoneController,
                    fatherEmailController: _fatherEmailController,
                    fatherOccupationController: _fatherOccupationController,
                    motherNameController: _motherNameController,
                    motherPhoneController: _motherPhoneController,
                    motherEmailController: _motherEmailController,
                    motherOccupationController: _motherOccupationController,
                    sibling1Controller: _sibling1Controller,
                    sibling1SchoolController: _sibling1SchoolController,
                    sibling1ClassController: _sibling1ClassController,
                    sibling2Controller: _sibling2Controller,
                    sibling2SchoolController: _sibling2SchoolController,
                    sibling2ClassController: _sibling2ClassController,
                  ),
                  EmergencyForm(
                    emergencyNameController: _emergencyNameController,
                    emergencyRelationshipController:
                        _emergencyRelationshipController,
                    emergencyPhoneController: _emergencyPhoneController,
                  ),
                  AddressForm(
                    addressNameController: _addressNameController,
                    addressLine1Controller: _addressLine1Controller,
                    addressLine2Controller: _addressLine2Controller,
                    cityController: _cityController,
                    stateController: _stateController,
                    zipCodeController: _zipCodeController,
                  ),
                  PhysiologicalForm(
                    placeInFamilyController: _placeInFamilyController,
                    childrenAroundController: _childrenAroundController,
                    attachedToController: _attachedToController,
                    likingsController: _likingsController,
                    dislikingsController: _dislikingsController,
                  ),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepProgressIndicatorWithIcons() {
    List<IconData> stepIcons = [
      Icons.account_circle, // Step 1
      Icons.people, // Step 2
      Icons.phone, // Step 3
      Icons.home, // Step 4
      Icons.health_and_safety, // Step 5
    ];

    List<String> stepContents = [
      "Student Details",
      "Parents Details",
      "Emergency",
      "Address",
      "Physiological"
    ];

    return Row(
      children: List.generate(
        stepIcons.length,
        (index) {
          return Expanded(
            child: Stack(
              children: [
                // Background arrow shape
                ClipPath(
                  clipper: ArrowClipper(isLast: index == stepIcons.length - 1),
                  child: Container(
                    height: 45,
                    color: _currentStep == index
                        ? Colors.grey[800] // Active Step
                        : _currentStep > index
                            ? Colors.grey[500] // Completed Steps
                            : Colors.grey[300], // Inactive Step
                  ),
                ),
                // Step Content (Icon)
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          stepIcons[index],
                          size: 25,
                          color: _currentStep == index
                              ? Colors.white
                              : _currentStep > index
                                  ? Colors.white
                                  : Colors.grey[700],
                        ),
                        Text(
                          stepContents[index],
                          style: TextStyle(
                            fontSize: 12,
                            color: _currentStep == index
                                ? Colors.white
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(
                20.0, 0.0, 20.0, 20.0), // Left, Top, Right, Bottom
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(120, 40),
                textStyle: const TextStyle(
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              child: Text("Back"),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              20.0, 0.0, 20.0, 20.0), // Left, Top, Right, Bottom
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(120, 40),
              textStyle: const TextStyle(
                fontSize: 15,
              ),
            ),
            onPressed: () {
              if (_currentStep < 4) {
                setState(() {
                  _currentStep++;
                });
              } else {
                _saveForm();
              }
            },
            child: Text(_currentStep < 4 ? "Next" : "Save"),
          ),
        ),
      ],
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      _showError("Please fill all required fields");
      return;
    }

    try {
      // Check if the student name already exists in the "students" collection
      QuerySnapshot existingStudent = await FirebaseFirestore.instance
          .collection("students")
          .where("student_name", isEqualTo: _nameController.text)
          .get();

      if (existingStudent.docs.isNotEmpty) {
        // Show an error message if the student name is not unique
        _showError("Student name must be unique. This name already exists.");
        return;
      }

      // Fetch the current counter value from Firestore
      DocumentSnapshot counterDoc = await FirebaseFirestore.instance
          .collection("counters")
          .doc("student_counter")
          .get();

      int currentCounter = counterDoc["value"];
      String studentId = "STU${currentCounter.toString().padLeft(4, '0')}";

      // Save the form data to the "students" collection
      await FirebaseFirestore.instance
          .collection("students")
          .doc(studentId)
          .set({
        "id": studentId,
        "student_name": _nameController.text,
        "student_dob": _dobController.text,
        "student_mother_tongue": _motherTongueController.value,
        "student_gender": _genderController.value,
        "student_grade": _gradeController.value,
        "student_caste": _casteController.value,
        "student_religion": _religionController.value,
        "student_nationality": _nationalityController.value,
        "student_previous_school": _previousSchoolController.text,
        "father_name": _fatherNameController.text,
        "father_phone": _fatherPhoneController.text,
        "father_email": _fatherEmailController.text,
        "father_occupation": _fatherOccupationController.text,
        "mother_name": _motherNameController.text,
        "mother_phone": _motherPhoneController.text,
        "mother_email": _motherEmailController.text,
        "mother_occupation": _motherOccupationController.text,
        "sibling1_name": _sibling1Controller.text,
        "sibling1_school": _sibling1SchoolController.text,
        "sibling1_class": _sibling1ClassController.text,
        "sibling2_name": _sibling2Controller.text,
        "sibling2_school": _sibling2SchoolController.text,
        "sibling2_class": _sibling2ClassController.text,
        "emergency_name": _emergencyNameController.text,
        "emergency_relationship": _emergencyRelationshipController.text,
        "emergency_phone": _emergencyPhoneController.text,
        "address_name": _addressNameController.text,
        "address_line1": _addressLine1Controller.text,
        "address_line2": _addressLine2Controller.text,
        "address_city": _cityController.text,
        "address_state": _stateController.text,
        "address_zip": _zipCodeController.text,
        "physcological_placeofthechild": _placeInFamilyController.value,
        "physcological_children_around": _childrenAroundController.value,
        "physcological_attachedto": _attachedToController.text,
        "physcological_likings": _likingsController.text,
        "physcological_dislikings": _dislikingsController.text,
      });

      // Increment the counter in Firestore
      await FirebaseFirestore.instance
          .collection("counters")
          .doc("student_counter")
          .update({"value": currentCounter + 1});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    }
  }
}

class ArrowClipper extends CustomClipper<Path> {
  final bool isLast;

  ArrowClipper({this.isLast = false});

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width - (isLast ? 0 : 20), 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - (isLast ? 0 : 20), size.height);
    path.lineTo(0, size.height);
    path.lineTo(20, size.height / 2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
