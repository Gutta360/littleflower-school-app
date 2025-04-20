import 'package:flutter/material.dart';
import 'package:littleflower/layouts/inventory.dart';
import 'package:littleflower/layouts/payments.dart';
import 'package:littleflower/layouts/salaries.dart';
import 'package:littleflower/layouts/staff.dart';
import 'package:littleflower/layouts/staff_details.dart';
import 'package:littleflower/layouts/student.dart';
import 'package:littleflower/layouts/student_details.dart';
import 'package:littleflower/tabs/stats/gradelevel.dart';
import 'package:littleflower/utils/json_upload.dart';
import 'package:littleflower/utils/under_progress.dart';

class HomeTilesPage extends StatefulWidget {
  const HomeTilesPage({super.key});

  @override
  _HomeTilesPageState createState() => _HomeTilesPageState();
}

class _HomeTilesPageState extends State<HomeTilesPage> {
  final List<TileData> tiles = [
    TileData(Icons.school, "Student"),
    TileData(Icons.description, "Student Details"),
    TileData(Icons.group, "Staff"),
    TileData(Icons.info, "Staff Details"),
    TileData(Icons.bar_chart, "Stats"),
    TileData(Icons.currency_rupee_rounded, "Accounts"),
    TileData(Icons.inventory, "Inventory"),
    TileData(Icons.settings, "Utilities"),
  ];

  bool isStatsExpanded = false;
  bool isAccountsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[60],
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 50,
            crossAxisSpacing: 40,
            childAspectRatio: 2,
          ),
          itemCount: tiles.length,
          itemBuilder: (context, index) {
            if (index == 4) {
              return StatsTile(
                isExpanded: isStatsExpanded,
                onTap: () {
                  setState(() {
                    isStatsExpanded = !isStatsExpanded;
                  });
                },
              );
            } else if (index == 5) {
              return AccountsTile(
                isExpanded: isAccountsExpanded,
                onTap: () {
                  setState(() {
                    isAccountsExpanded = !isAccountsExpanded;
                  });
                },
              );
            } else {
              final tile = tiles[index];
              return _buildTile(tile, context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTile(TileData tile, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          _navigateToPage(context, tile.label);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tile.icon,
              size: 40,
              color: Colors.grey[800],
            ),
            const SizedBox(height: 8),
            Text(
              tile.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, String label) {
    switch (label) {
      case "Student":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentFormWidget()),
        );
        break;
      case "Student Details":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentDetailsLayout()),
        );
        break;
      case "Staff":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StaffLayout()),
        );
        break;
      case "Staff Details":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StaffDetailsLayout()),
        );
        break;
      case "Inventory":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InventoryLayout()),
        );
        break;
      case "Utilities":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JsonUploadWidget()),
        );
        break;
    }
  }
}

class StatsTile extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const StatsTile({super.key, 
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isExpanded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Stats",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        _buildSubTile(context, "Grade", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StudentListView()),
                          );
                        }),
                        _buildSubTile(context, "School", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UnderProgressWidget()),
                          );
                        }),
                      ],
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: 40,
                        color: Colors.grey[800],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Stats",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSubTile(BuildContext context, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}

class AccountsTile extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  AccountsTile({
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isExpanded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Accounts",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        _buildSubTile(context, "Payments", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentsLayout()),
                          );
                        }),
                        _buildSubTile(context, "Salaries", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SalariesLayout()),
                          );
                        }),
                      ],
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.currency_rupee_rounded,
                        size: 40,
                        color: Colors.grey[800],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Accounts",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSubTile(BuildContext context, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}

class TileData {
  final IconData icon;
  final String label;

  TileData(this.icon, this.label);
}
