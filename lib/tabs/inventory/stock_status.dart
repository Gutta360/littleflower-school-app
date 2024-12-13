import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StockStatus extends StatelessWidget {
  final List<Map<String, dynamic>> inventoryItems = [
    {'name': 'Notebooks', 'currentStock': 30, 'totalStock': 150},
    {'name': 'Markers', 'currentStock': 50, 'totalStock': 300},
    {'name': 'Bags', 'currentStock': 50, 'totalStock': 280},
    {'name': 'Uniforms', 'currentStock': 300, 'totalStock': 1200},
    {'name': 'Shoes', 'currentStock': 220, 'totalStock': 1200},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: inventoryItems.length,
        itemBuilder: (context, index) {
          final item = inventoryItems[index];
          final percentage = item['currentStock'] / item['totalStock'];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                  LinearPercentIndicator(
                    lineHeight: 14.0,
                    percent: percentage.clamp(0.0, 1.0),
                    center: Text(
                      '${(percentage * 100).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                    progressColor: Colors.blue,
                    backgroundColor: Colors.grey[300],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${item['currentStock']} / ${item['totalStock']} in stock',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
