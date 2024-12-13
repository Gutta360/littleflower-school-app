import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ItemManagement extends StatefulWidget {
  const ItemManagement({super.key});

  @override
  _ItemManagementState createState() => _ItemManagementState();
}

class _ItemManagementState extends State<ItemManagement> {
  List<Map<String, dynamic>> inventoryItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  String? selectedItemName;
  String? selectedAvailability;
  List<String> itemNames = [];

  @override
  void initState() {
    super.initState();
    _fetchInventory();
  }

  Future<void> _fetchInventory() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('inventory').get();
    setState(() {
      inventoryItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'],
          'available': data['available'],
          'limit': data['limit'],
        };
      }).toList();
      itemNames = ["ALL"] +
          inventoryItems.map((item) => item['name'] as String).toList();
      filteredItems = inventoryItems;
    });
  }

  void _applyFilters() {
    setState(() {
      filteredItems = inventoryItems.where((item) {
        final percent = item['limit'] > 0
            ? (item['available'] / item['limit']).clamp(0.0, 1.0)
            : 0.0;

        bool matchesName = selectedItemName == null ||
            selectedItemName == "ALL" ||
            item['name'] == selectedItemName;
        bool matchesAvailability = false;

        if (selectedAvailability == null || selectedAvailability == "ALL") {
          matchesAvailability = true;
        } else if (selectedAvailability == "very low" && percent <= 0.24) {
          matchesAvailability = true;
        } else if (selectedAvailability == "low" &&
            percent > 0.24 &&
            percent <= 0.49) {
          matchesAvailability = true;
        } else if (selectedAvailability == "enough" &&
            percent > 0.49 &&
            percent <= 0.74) {
          matchesAvailability = true;
        } else if (selectedAvailability == "abundant" && percent > 0.74) {
          matchesAvailability = true;
        }

        return matchesName && matchesAvailability;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedItemName,
                    decoration: const InputDecoration(
                      labelText: "Item Name",
                      border: OutlineInputBorder(),
                    ),
                    items: itemNames.map((name) {
                      return DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedItemName = value;
                        _applyFilters();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedAvailability,
                    decoration: const InputDecoration(
                      labelText: "Availability",
                      border: OutlineInputBorder(),
                    ),
                    items: ["ALL", "very low", "low", "enough", "abundant"]
                        .map((label) {
                      return DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAvailability = value;
                        _applyFilters();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final percent = item['limit'] > 0
                    ? (item['available'] / item['limit']).clamp(0.0, 1.0)
                    : 0.0;

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LinearPercentIndicator(
                              width: 170.0,
                              animation: true,
                              animationDuration: 1000,
                              lineHeight: 20.0,
                              leading: Text(
                                'Available: ${item['available']} / ${item['limit']}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[600]),
                              ),
                              percent: percent,
                              center: Text(
                                  "${(percent * 100).toStringAsFixed(1)}%"),
                              linearStrokeCap: LinearStrokeCap.butt,
                              progressColor: _getProgressColor(percent),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () => _updateStock(index, -1),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => _updateStock(index, 1),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: () => _refreshItem(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateStock(int index, int change) {
    setState(() {
      inventoryItems[index]['available'] =
          (inventoryItems[index]['available'] + change)
              .clamp(0, inventoryItems[index]['limit']);
    });
  }

  Future<void> _refreshItem(int index) async {
    final item = inventoryItems[index];
    try {
      await FirebaseFirestore.instance
          .collection('inventory')
          .doc(item['id'])
          .update({
        'available': item['available'],
        'limit': item['limit'],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item '${item['name']}' updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update item: $e")),
      );
    }
  }

  Color _getProgressColor(double percent) {
    if (percent <= 0.24) {
      return Colors.red;
    } else if (percent <= 0.49) {
      return Colors.orange;
    } else if (percent <= 0.74) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }
}
