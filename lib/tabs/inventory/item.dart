import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item extends StatelessWidget {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController availableController = TextEditingController();
  TextEditingController limitController = TextEditingController();

  Future<void> _addItem(BuildContext context) async {
    final name = itemNameController.text.trim();
    final priceText = itemPriceController.text.trim();
    final availableText = availableController.text.trim();
    final limitText = limitController.text.trim();

    if (name.isEmpty ||
        priceText.isEmpty ||
        availableText.isEmpty ||
        limitText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    final price = double.tryParse(priceText);
    final available = int.tryParse(availableText);
    final limit = int.tryParse(limitText);

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid price.")),
      );
      return;
    }

    if (available == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid available value.")),
      );
      return;
    }

    if (limit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid limit value.")),
      );
      return;
    }

    try {
      // Get the current item counter value
      final counterDoc =
          FirebaseFirestore.instance.collection('counters').doc('item_counter');
      final counterSnapshot = await counterDoc.get();

      if (!counterSnapshot.exists ||
          !counterSnapshot.data()!.containsKey('value')) {
        throw Exception("Item counter is not properly set up.");
      }

      final currentCounter = counterSnapshot.data()!['value'];
      final newCounter = currentCounter + 1;

      // Generate the new item ID
      final itemId = "ITEM" + newCounter.toString().padLeft(4, '0');

      // Save the item to the inventory collection
      await FirebaseFirestore.instance.collection('inventory').doc(itemId).set({
        'id': itemId,
        'name': name,
        'price': price,
        'available': available,
        'limit': limit,
      });

      // Update the item counter value
      await counterDoc.update({'value': newCounter});

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item added successfully!")),
      );

      // Clear input fields
      itemNameController.clear();
      itemPriceController.clear();
      availableController.clear();
      limitController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add item: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 400.0, vertical: 16.0),
      children: [
        TextFormField(
          controller: itemNameController,
          decoration: const InputDecoration(
            labelText: "Item Name",
            hintText: "Capitals and Space only. Ex: BOOKS",
            prefixIcon: Icon(Icons.account_circle),
          ),
          onChanged: (value) {
            final uppercaseValue =
                value.toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '');
            if (value != uppercaseValue) {
              itemNameController.value = TextEditingValue(
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
        const SizedBox(height: 8),
        _buildDecimalField(
          controller: itemPriceController,
          context: context,
          label: "Price",
          hint: "ex: 25.50",
          icon: Icons.currency_rupee,
        ),
        const SizedBox(height: 8),
        _buildIntegerField(
          controller: availableController,
          context: context,
          label: "Available",
          hint: "ex: 10",
          icon: Icons.inventory,
        ),
        const SizedBox(height: 8),
        _buildIntegerField(
          controller: limitController,
          context: context,
          label: "Limit",
          hint: "ex: 5",
          icon: Icons.warning,
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () => _addItem(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              minimumSize: const Size(120, 40), // Ensures the button size
              textStyle: const TextStyle(fontSize: 15),
            ),
            child: const Text('Add'),
          ),
        )
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
        if (!RegExp(r'^\d+(\.\d+)?\$').hasMatch(value)) {
          return "Only decimal values are allowed";
        }
        return null;
      },
    );
  }

  Widget _buildIntegerField({
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
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final intValue = value.replaceAll(RegExp(r'[^0-9]'), '');
        if (value != intValue) {
          controller.value = TextEditingValue(
            text: intValue,
            selection: TextSelection.collapsed(offset: intValue.length),
          );
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        if (!RegExp(r'^\d+\$').hasMatch(value)) {
          return "Only integer values are allowed";
        }
        return null;
      },
    );
  }
}
