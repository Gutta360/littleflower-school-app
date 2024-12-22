import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final TextEditingController addressNameController;
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipCodeController;

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
    required this.addressNameController,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.cityController,
    required this.stateController,
    required this.zipCodeController,
  }) : super(key: key);

  @override
  _StaffFormState createState() => _StaffFormState();
}

class _StaffFormState extends State<StaffForm> {
  List<String> staffNames = [];
  String? selectedStaffName;

  @override
  void initState() {
    super.initState();
    _fetchStudentNames();
  }

  Future<void> _fetchStudentNames() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('staff').get();

      setState(() {
        staffNames =
            snapshot.docs.map((doc) => doc['staff_name'] as String).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching staff names: $e'),
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
        DropdownSearch<String>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: "Search Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          items: staffNames,
          selectedItem: selectedStaffName,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Name",
              prefixIcon: Icon(Icons.account_circle),
            ),
          ),
          onChanged: (value) {
            setState(() {
              selectedStaffName = value;
              widget.nameController.text = value ?? '';
            });
            if (value != null) {
              _populateFields(value);
            }
          },
          validator: (value) =>
              value == null || value.isEmpty ? "Name is required" : null,
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
          icon: Icons.currency_rupee_outlined,
        ),
        _buildDecimalField(
          controller: widget.currentSalaryController,
          context: context,
          label: "Current Salary",
          hint: "Enter decimal values only",
          icon: Icons.currency_rupee_outlined,
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

  Widget _buildNameDropdown() {
    return FutureBuilder<List<String>>(
      future: _fetchStaffNames(), // Fetch staff names from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No staff names available");
        }

        return DropdownButtonFormField<String>(
          value: widget.nameController.text.isNotEmpty
              ? widget.nameController.text
              : null, // Set initial value if available
          decoration: const InputDecoration(
            labelText: "Name",
            hintText: "Select a staff name",
            prefixIcon: Icon(Icons.account_circle),
          ),
          items: staffNames
              .map((name) => DropdownMenuItem(value: name, child: Text(name)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                widget.nameController.text = value;
              });
            }
          },
          validator: (value) =>
              value == null || value.isEmpty ? "Name is required" : null,
        );
      },
    );
  }

  Future<List<String>> _fetchStaffNames() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("staff")
          .get(); // Fetch all documents in the "staff" collection
      return querySnapshot.docs
          .map((doc) => doc["staff_name"] as String) // Extract staff_name
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch staff names: $e");
    }
  }

  Future<void> _populateFields(String studentName) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('staff')
          .where('staff_name', isEqualTo: studentName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          widget.fatherHusbandNameController.text =
              data['staff_fatherorhusband_name'] ?? '';
          widget.aadharNoController.text = data['staff_aadhar_no'] ?? '';
          widget.educationalQualificationController.text =
              data['staff_educational_qualification'] ?? '';
          widget.otherSkillsController.text = data['staff_other_skills'] ?? '';
          widget.maritalStatusController.value = data['staff_marital_status'];
          widget.childrenController.text = data['staff_children'] ?? '';
          widget.experienceController.text = data['staff_experience'] ?? '';
          widget.previousSalaryController.text =
              data['staff_previous_salary'] ?? '';
          widget.expectedSalaryController.text =
              data['staff_expected_salary'] ?? '';
          widget.currentSalaryController.text =
              data['staff_current_salary'] ?? '';
          widget.originalCertificatesController.text =
              data['staff_original_certificates'] ?? '';
          widget.agreementPeriodController.text =
              data['staff_agreement_period'] ?? '';
          widget.addressNameController.text = data['address_name'] ?? '';
          widget.addressLine1Controller.text = data['address_line1'] ?? '';
          widget.addressLine2Controller.text = data['address_line2'] ?? '';
          widget.cityController.text = data['address_city'] ?? '';
          widget.stateController.text = data['address_state'] ?? '';
          widget.zipCodeController.text = data['address_zip'] ?? '';
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
}
