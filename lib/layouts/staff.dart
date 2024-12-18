import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:littleflower/tabs/staff/staff.dart';
import 'package:littleflower/tabs/staff/address.dart';

class StaffLayout extends StatefulWidget {
  @override
  _StaffLayoutState createState() => _StaffLayoutState();
}

class _StaffLayoutState extends State<StaffLayout> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherHusbandNameController =
      TextEditingController();
  final TextEditingController _aadharNoController = TextEditingController();
  final TextEditingController _educationalQualificationController =
      TextEditingController();
  final TextEditingController _otherSkillsController = TextEditingController();
  final ValueNotifier<String?> _maritalStatusController =
      ValueNotifier<String?>(null);
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _previousSalaryController =
      TextEditingController();
  final TextEditingController _expectedSalaryController =
      TextEditingController();
  final TextEditingController _currentSalaryController =
      TextEditingController();
  final TextEditingController _originalCertificatesController =
      TextEditingController();
  final TextEditingController _agreementPeriodController =
      TextEditingController();

  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[60],
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
                  StaffForm(
                      nameController: _nameController,
                      fatherHusbandNameController: _fatherHusbandNameController,
                      aadharNoController: _aadharNoController,
                      educationalQualificationController:
                          _educationalQualificationController,
                      otherSkillsController: _otherSkillsController,
                      maritalStatusController: _maritalStatusController,
                      childrenController: _childrenController,
                      experienceController: _experienceController,
                      previousSalaryController: _previousSalaryController,
                      expectedSalaryController: _expectedSalaryController,
                      currentSalaryController: _currentSalaryController,
                      originalCertificatesController:
                          _originalCertificatesController,
                      agreementPeriodController: _agreementPeriodController),
                  AddressForm(
                    addressNameController: _addressNameController,
                    addressLine1Controller: _addressLine1Controller,
                    addressLine2Controller: _addressLine2Controller,
                    cityController: _cityController,
                    stateController: _stateController,
                    zipCodeController: _zipCodeController,
                  )
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
      Icons.account_circle,
      Icons.home,
    ];

    List<String> stepContents = ["Staff Details", "Address"];

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
                backgroundColor: Colors.grey[800],
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
              backgroundColor: Colors.grey[800],
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(120, 40),
              textStyle: const TextStyle(
                fontSize: 15,
              ),
            ),
            onPressed: () {
              if (_currentStep < 1) {
                setState(() {
                  _currentStep++;
                });
              } else {
                _saveForm();
              }
            },
            child: Text(_currentStep < 1 ? "Next" : "Save"),
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
      // Check if the staff name already exists in the "staff" collection
      QuerySnapshot existingStaff = await FirebaseFirestore.instance
          .collection("staff")
          .where("staff_name", isEqualTo: _nameController.text)
          .get();

      if (existingStaff.docs.isNotEmpty) {
        // Show an error message if the staff name is not unique
        _showError("Staff name must be unique. This name already exists.");
        return;
      }

      // Fetch the current counter value from Firestore
      DocumentSnapshot counterDoc = await FirebaseFirestore.instance
          .collection("counters")
          .doc("staff_counter")
          .get();

      int currentCounter = counterDoc["value"];
      String staffId = "STAFF${currentCounter.toString().padLeft(4, '0')}";

      // Save the form data to the "staff" collection
      await FirebaseFirestore.instance.collection("staff").doc(staffId).set({
        "id": staffId,
        "staff_name": _nameController.text,
        "staff_fatherorhusband_name": _fatherHusbandNameController.text,
        "staff_aadhar_no": _aadharNoController.text,
        "staff_educational_qualification":
            _educationalQualificationController.text,
        "staff_other_skills": _otherSkillsController.text,
        "staff_marital_status": _maritalStatusController.value,
        "staff_children": _childrenController.text,
        "staff_experience": _experienceController.text,
        "staff_previous_salary": _previousSalaryController.text,
        "staff_expected_salary": _expectedSalaryController.text,
        "staff_current_salary": _currentSalaryController.text,
        "staff_original_certificates": _originalCertificatesController.text,
        "staff_agreement_period": _agreementPeriodController.text,
        "address_name": _addressNameController.text,
        "address_line1": _addressLine1Controller.text,
        "address_line2": _addressLine2Controller.text,
        "address_city": _cityController.text,
        "address_state": _stateController.text,
        "address_zip": _zipCodeController.text
      });

      // Increment the counter in Firestore
      await FirebaseFirestore.instance
          .collection("counters")
          .doc("staff_counter")
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
