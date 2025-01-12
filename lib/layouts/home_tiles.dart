import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TileData> tiles = [
    TileData(Icons.login, "Login"),
    TileData(Icons.school, "Student"),
    TileData(Icons.description, "Student Details"),
    TileData(Icons.group, "Staff"),
    TileData(Icons.info, "Staff Details"),
    TileData(Icons.bar_chart, "Stats"),
    TileData(Icons.currency_rupee_rounded, "Accounts"),
    TileData(Icons.inventory, "Inventory"),
    TileData(Icons.settings, "Utilities"),
  ];

  bool isStatsSplit = false;

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
          itemCount: isStatsSplit ? tiles.length + 1 : tiles.length,
          itemBuilder: (context, index) {
            if (isStatsSplit && (index == 5 || index == 6)) {
              return _buildSubTile(index == 5 ? "Grade" : "School");
            } else if (isStatsSplit && index > 6) {
              final tile = tiles[index - 1];
              return _buildTile(tile);
            } else if (!isStatsSplit && index == 5) {
              final tile = tiles[index];
              return _buildTile(tile);
            } else {
              final tile = tiles[index];
              return _buildTile(tile);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTile(TileData tile) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (tile.label == "Stats") {
            setState(() {
              isStatsSplit = !isStatsSplit;
            });
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tile.icon,
              size: 40,
              color: Colors.grey[800],
            ),
            SizedBox(height: 8),
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

  Widget _buildSubTile(String label) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Handle sub-tile click
        },
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
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
