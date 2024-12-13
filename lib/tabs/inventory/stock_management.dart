import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StockManagement extends StatefulWidget {
  @override
  _StockManagementState createState() => _StockManagementState();
}

class _StockManagementState extends State<StockManagement> {
  List<Map<String, dynamic>> inventoryItems = [];

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
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Management'),
      ),
      body: ListView.builder(
        itemCount: inventoryItems.length,
        itemBuilder: (context, index) {
          final item = inventoryItems[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
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
                        SizedBox(height: 8),
                        Text(
                          'Available: ${item['available']} / ${item['limit']}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
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
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
