import 'package:flutter/material.dart';

class PhysiologicalForm extends StatelessWidget {
  final ValueNotifier<String?> placeInFamilyController;
  final ValueNotifier<String?> childrenAroundController;
  final TextEditingController attachedToController;
  final TextEditingController likingsController;
  final TextEditingController dislikingsController;

  PhysiologicalForm({
    required this.placeInFamilyController,
    required this.childrenAroundController,
    required this.attachedToController,
    required this.likingsController,
    required this.dislikingsController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 400.0, vertical: 16.0),
      children: [
        _buildDropdown(
          controller: placeInFamilyController,
          label: "Place of the child in the family",
          items: ["Eldest", "Middle", "Youngest", "Only child"],
          icondata: Icons.family_restroom,
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          controller: childrenAroundController,
          label: "Are there children around to play?",
          items: ["YES", "NO"],
          icondata: Icons.child_care,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: attachedToController,
          label: "To whom the child is more attached",
          icon: Icons.favorite,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: likingsController,
          label: "Likings of the child",
          icon: Icons.thumb_up,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: dislikingsController,
          label: "Dislikings of the child",
          icon: Icons.thumb_down,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required ValueNotifier<String?> controller,
    required String label,
    required List<String> items,
    required IconData icondata,
  }) {
    return ValueListenableBuilder<String?>(
      valueListenable: controller,
      builder: (context, selectedValue, _) {
        return DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icondata),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) {
            controller.value = value;
          },
          validator: (value) =>
              value == null || value.isEmpty ? "$label is required" : null,
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}
