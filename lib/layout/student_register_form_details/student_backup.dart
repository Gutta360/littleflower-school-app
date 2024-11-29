import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolRegistrationForm extends StatefulWidget {
  @override
  _SchoolRegistrationFormState createState() => _SchoolRegistrationFormState();
}

class _SchoolRegistrationFormState extends State<SchoolRegistrationForm> {
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
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _previousSchoolController.dispose();
    _motherTongueController.dispose();
    _fatherNameController.dispose();
    _fatherPhoneController.dispose();
    _fatherEmailController.dispose();
    _fatherOccupationController.dispose();
    _motherNameController.dispose();
    _motherPhoneController.dispose();
    _motherEmailController.dispose();
    _motherOccupationController.dispose();
    _sibling1Controller.dispose();
    _sibling1SchoolController.dispose();
    _sibling1ClassController.dispose();
    _sibling2Controller.dispose();
    _sibling2SchoolController.dispose();
    _sibling2ClassController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _attachedToController.dispose();
    _likingsController.dispose();
    _dislikingsController.dispose();
    super.dispose();
  }

  // Text Editing Controllers
  // final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  // Date Format
  final DateFormat dateFormat = DateFormat("dd-MMM-yyyy");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Progress Indicator
            _buildStepProgressIndicatorWithIcons(), // Updated widget with labels,
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _buildStudentForm(context),
                  _buildParentGuardianForm(context),
                  _buildEmergencyForm(context),
                  _buildAddressForm(context),
                  _buildPhysiologicalForm(context),
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
      Icons.account_circle, // Student Details
      Icons.people, // Parents Details
      Icons.phone, // Emergency
      Icons.home, // Address
      Icons.health_and_safety, // Certificates
    ];

    List<String> stepLabels = [
      "Student Details",
      "Parents Details",
      "Emergency",
      "Address",
      "Physiological",
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            stepIcons.length,
            (index) => Column(
              children: [
                CircleAvatar(
                  backgroundColor:
                      _currentStep == index ? Colors.blue : Colors.grey[300],
                  child: Icon(
                    stepIcons[index],
                    color: _currentStep == index ? Colors.white : Colors.grey,
                  ),
                ),
                const SizedBox(height: 8), // Space between icon and label
                Text(
                  stepLabels[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: _currentStep == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
            height: 8), // Space between the step indicators and the rest
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            stepIcons.length - 1,
            (index) => Expanded(
              child: Divider(
                color: index < _currentStep ? Colors.blue : Colors.grey,
                thickness: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentForm(BuildContext context) {
    String? selectedGrade;
    String? selectedGender;
    String? selectedMotherTongue;
    String? selectedReligion;
    String? selectedNationality;
    String? selectedCaste;

    return GridView(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Three columns
        crossAxisSpacing: 20.0, // Space between columns
        mainAxisSpacing: 16.0, // Space between rows
        childAspectRatio: 6, // Adjust height-to-width ratio for fields
      ),
      children: [
        // Updated Name Field
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Name",
            prefixIcon: Icon(Icons.account_circle),
          ),
          onChanged: (value) {
            // Automatically convert lowercase to uppercase and remove non-alphabet characters
            final uppercaseValue =
                value.toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '');
            if (value != uppercaseValue) {
              _nameController.value = TextEditingValue(
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

        // Date of Birth Field
        _buildDatePickerField(context),

        // Mother Tongue Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: _motherTongueController,
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
                _motherTongueController.value =
                    value; // Update the controller value
              },
              validator: (value) => value == null || value.isEmpty
                  ? "Mother Tongue is required"
                  : null,
            );
          },
        ),

        // Gender Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: _genderController,
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
                _genderController.value = value; // Update the controller value
              },
              validator: (value) =>
                  value == null || value.isEmpty ? "Gender is required" : null,
            );
          },
        ),

        // Grade Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: _gradeController,
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
                _gradeController.value = value; // Update the controller value
              },
              validator: (value) =>
                  value == null || value.isEmpty ? "Grade is required" : null,
            );
          },
        ),

        // Caste Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: _casteController,
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
                _casteController.value = value;
              },
              validator: (value) =>
                  value == null || value.isEmpty ? "Caste is required" : null,
            );
          },
        ),

        // Religion Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: _religionController,
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
                _religionController.value =
                    value; // Update the controller value
              },
              validator: (value) => value == null || value.isEmpty
                  ? "Religion is required"
                  : null,
            );
          },
        ),

        // Nationality Dropdown
        ValueListenableBuilder<String?>(
          valueListenable: _nationalityController,
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
                _nationalityController.value =
                    value; // Update the controller's value
              },
              validator: (value) => value == null || value.isEmpty
                  ? "Nationality is required"
                  : null,
            );
          },
        ),

        // Previous School Field
        _buildTextField(
          controller: _previousSchoolController,
          context: context,
          label: "Previous School",
          icon: Icons.apartment,
          onChanged: (value) {},
          validator: (value) => value == null || value.isEmpty
              ? "Previous School is required"
              : null,
        ),
      ],
    );
  }

  Widget _buildParentGuardianForm(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0),
      children: [
        // Father Details
        Text(
          "Father Details",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 8,
          ),
          children: [
            _buildTextField(
              controller: _fatherNameController,
              context: context,
              label: "Father Name",
              icon: Icons.account_circle,
              onChanged: (value) {},
              validator: (value) => value == null || value.isEmpty
                  ? "Father Name is required"
                  : null,
            ),
            _buildTextField(
              controller: _fatherPhoneController,
              context: context,
              label: "Father Phone",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Father Phone is required";
                } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                  return "Only numeric values are allowed";
                } else if (value.length != 10) {
                  return "Must be exactly 10 digits";
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _fatherEmailController,
              context: context,
              label: "Father Email",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Father Email is required";
                } else if (!RegExp(
                        r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
                    .hasMatch(value)) {
                  return "Invalid email format";
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _fatherOccupationController,
              context: context,
              label: "Father Occupation",
              icon: Icons.work,
              onChanged: (value) {},
              validator: (value) => value == null || value.isEmpty
                  ? "Occupation is required"
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 40),

        // Mother Details
        Text(
          "Mother Details",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 8,
          ),
          children: [
            _buildTextField(
              controller: _motherNameController,
              context: context,
              label: "Mother Name",
              icon: Icons.account_circle,
              onChanged: (value) {},
              validator: (value) => value == null || value.isEmpty
                  ? "Mother Name is required"
                  : null,
            ),
            _buildTextField(
              controller: _motherPhoneController,
              context: context,
              label: "Mother Phone",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Mother Phone is required";
                } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                  return "Only numeric values are allowed";
                } else if (value.length != 10) {
                  return "Must be exactly 10 digits";
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _motherEmailController,
              context: context,
              label: "Mother Email",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Mother Email is required";
                } else if (!RegExp(
                        r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
                    .hasMatch(value)) {
                  return "Invalid email format";
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _motherOccupationController,
              context: context,
              label: "Mother Occupation",
              icon: Icons.work,
              onChanged: (value) {},
              validator: (value) => value == null || value.isEmpty
                  ? "Occupation is required"
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 40),

        // Sibling Details (Remaining unchanged)
      ],
    );
  }

  Widget _buildEmergencyForm(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 400.0, vertical: 16.0),
      children: [
        _buildTextField(
          controller: _emergencyNameController,
          context: context,
          label: "Name",
          icon: Icons.account_circle,
          onChanged: (value) {},
          validator: (value) =>
              value == null || value.isEmpty ? "Name is required" : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emergencyRelationshipController,
          context: context,
          label: "Relationship",
          icon: Icons.family_restroom,
          onChanged: (value) {},
          validator: (value) => value == null || value.isEmpty
              ? "Relationship is required"
              : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emergencyPhoneController,
          context: context,
          label: "Phone",
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          onChanged: (value) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Phone is required";
            } else if (!RegExp(r'^\d+$').hasMatch(value)) {
              return "Only numeric values are allowed";
            } else if (value.length != 10) {
              return "Must be exactly 10 digits";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAddressForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 16.0, // Space between columns
          mainAxisSpacing: 16.0, // Space between rows
          childAspectRatio: 10, // Adjust the height-to-width ratio for fields
        ),
        children: [
          _buildTextField(
            controller: _addressNameController,
            context: context,
            label: "Name",
            icon: Icons.account_circle,
            onChanged: (value) {},
            validator: (value) =>
                value == null || value.isEmpty ? "Name is required" : null,
          ),
          _buildTextField(
            controller: _addressLine1Controller,
            context: context,
            label: "Street Address Line 1",
            icon: Icons.home,
            onChanged: (value) {},
            validator: (value) => value == null || value.isEmpty
                ? "Street Address Line 1 is required"
                : null,
          ),
          _buildTextField(
            controller: _addressLine2Controller,
            context: context,
            label: "Street Address Line 2",
            icon: Icons.home_outlined,
            onChanged: (value) {},
            validator: (value) => null,
          ),
          _buildTextField(
            controller: _cityController,
            context: context,
            label: "City",
            icon: Icons.location_city,
            onChanged: (value) {},
            validator: (value) =>
                value == null || value.isEmpty ? "City is required" : null,
          ),
          _buildTextField(
            controller: _stateController,
            context: context,
            label: "State",
            icon: Icons.map,
            onChanged: (value) {},
            validator: (value) =>
                value == null || value.isEmpty ? "State is required" : null,
          ),
          _buildTextField(
            controller: _zipCodeController,
            context: context,
            label: "Zip Code",
            icon: Icons.local_post_office,
            keyboardType: TextInputType.number,
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Zip Code is required";
              } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                return "Only numeric values are allowed";
              } else if (value.length != 6) {
                return "Must be exactly 6 digits";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhysiologicalForm(BuildContext context) {
    String? selectedPlaceInFamily;
    String? selectedChildrenAround;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 400.0, vertical: 16.0),
      children: [
        const SizedBox(height: 16),
        ValueListenableBuilder<String?>(
          valueListenable: _placeInFamilyController,
          builder: (context, selectedPlaceInFamily, child) {
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Place of the child in the family",
                prefixIcon: Icon(Icons.family_restroom),
              ),
              value: selectedPlaceInFamily,
              items: [
                "Eldest",
                "Middle",
                "Only Male or Female child",
                "Only child"
              ]
                  .map((place) => DropdownMenuItem(
                        value: place,
                        child: Text(place),
                      ))
                  .toList(),
              onChanged: (value) {
                _placeInFamilyController.value =
                    value; // Update the controller value
              },
              validator: (value) => value == null || value.isEmpty
                  ? "This field is required"
                  : null,
            );
          },
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<String?>(
          valueListenable: _childrenAroundController,
          builder: (context, selectedChildrenAround, child) {
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Are there children around to play?",
                prefixIcon: Icon(Icons.child_care),
              ),
              value: selectedChildrenAround,
              items: ["YES", "NO"]
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              onChanged: (value) {
                _childrenAroundController.value =
                    value; // Update the controller value
              },
              validator: (value) => value == null || value.isEmpty
                  ? "This field is required"
                  : null,
            );
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _attachedToController,
          context: context,
          label: "To whom the child is more attached",
          icon: Icons.favorite,
          onChanged: (value) {},
          validator: (value) =>
              value == null || value.isEmpty ? "This field is required" : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _likingsController,
          context: context,
          label: "Likings of the child",
          icon: Icons.thumb_up,
          onChanged: (value) {},
          validator: (value) =>
              value == null || value.isEmpty ? "This field is required" : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _dislikingsController,
          context: context,
          label: "Dislikings of the child",
          icon: Icons.thumb_down,
          onChanged: (value) {},
          validator: (value) =>
              value == null || value.isEmpty ? "This field is required" : null,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required BuildContext context,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
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
                _selectedDate = pickedDate;
                _dobController.text = dateFormat.format(pickedDate);
              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: _dobController,
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
      // Fetch the current counter value from Firestore
      DocumentSnapshot counterDoc = await FirebaseFirestore.instance
          .collection("counters")
          .doc("staff_counter")
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
