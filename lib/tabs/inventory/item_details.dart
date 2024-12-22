import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDetails extends StatefulWidget {
  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  String? selectedItemName;
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController availableController = TextEditingController();
  TextEditingController limitController = TextEditingController();
  List<String> itemNames = [];
  Map<String, dynamic> itemData = {};

  @override
  void initState() {
    super.initState();
    _fetchItemNames();
  }

  Future<void> _fetchItemNames() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('inventory').get();
    setState(() {
      itemNames =
          snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    });
  }

  Future<void> _fetchItemDetails(String itemName) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('inventory')
        .where('name', isEqualTo: itemName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      setState(() {
        itemData = data;
        itemPriceController.text = data['price'].toString();
        availableController.text = data['available'].toString();
        limitController.text = data['limit'].toString();
      });
    }
  }

  Future<void> _updateItem(BuildContext context) async {
    if (selectedItemName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an item to update.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('inventory')
          .where('name', isEqualTo: selectedItemName)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.first.reference.update({
            'price': double.tryParse(itemPriceController.text) ?? 0.0,
            'available': int.tryParse(availableController.text) ?? 0,
            'limit': int.tryParse(limitController.text) ?? 0,
          });
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update item: $e")),
      );
    }
  }

  Future<void> _deleteItem(BuildContext context) async {
    if (selectedItemName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an item to delete.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('inventory')
          .where('name', isEqualTo: selectedItemName)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.first.reference.delete();
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item deleted successfully!")),
      );

      setState(() {
        selectedItemName = null;
        itemPriceController.clear();
        availableController.clear();
        limitController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete item: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 400.0, vertical: 16.0),
      children: [
        DropdownSearch<String>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: "Search Item Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          items: itemNames,
          selectedItem: selectedItemName,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Item Name",
              prefixIcon: Icon(Icons.inventory),
            ),
          ),
          onChanged: (value) {
            setState(() {
              selectedItemName = value;
              if (value != null) {
                _fetchItemDetails(value);
              }
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Item name is required";
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _updateItem(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey[800],
                minimumSize: const Size(120, 40),
                textStyle: const TextStyle(fontSize: 15),
              ),
              child: const Text('Update'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => _deleteItem(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                minimumSize: const Size(120, 40),
                textStyle: const TextStyle(fontSize: 15),
              ),
              child: const Text('Delete'),
            ),
          ],
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
