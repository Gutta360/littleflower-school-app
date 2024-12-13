import 'package:flutter/material.dart';
import 'package:littleflower/tabs/inventory/stock_input.dart';
import 'package:littleflower/tabs/inventory/stock_management.dart';
import 'package:littleflower/tabs/inventory/stock_status.dart';

class InventoryLayout extends StatefulWidget {
  const InventoryLayout({super.key});

  @override
  InventoryLayoutState createState() => InventoryLayoutState();
}

class InventoryLayoutState extends State<InventoryLayout> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(25), // Adjust height here
            child: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              labelPadding:
                  EdgeInsets.symmetric(horizontal: 8.0), // Reduce padding
              tabs: [
                Tab(
                  icon: Icon(Icons.inventory_rounded,
                      size: 20), // Adjust icon size
                  text: 'Stock',
                ),
                Tab(
                  icon: Icon(Icons.inventory_rounded,
                      size: 20), // Adjust icon size
                  text: 'Stock Management',
                ),
                Tab(
                  icon: Icon(Icons.list_alt_rounded,
                      size: 20), // Adjust icon size
                  text: 'Stock Status',
                )
              ],
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: TabBarView(
          children: [
            Stock(),
            StockManagement(),
            StockStatus(),
          ],
        ),
      ),
    );
  }
}
