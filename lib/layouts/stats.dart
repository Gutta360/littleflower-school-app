import 'package:flutter/material.dart';
import 'package:littleflower/layouts/home_tiles.dart';
import 'package:littleflower/tabs/stats/gradelevel.dart';
import 'package:littleflower/tabs/stats/notifications.dart';
import 'package:littleflower/utils/under_progress.dart';

class StatsLayout extends StatefulWidget {
  const StatsLayout({super.key});

  @override
  StatsLayoutState createState() => StatsLayoutState();
}

class StatsLayoutState extends State<StatsLayout> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.amber[60],
        appBar: AppBar(
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(20), // Adjust height here
            child: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.grey,
              unselectedLabelColor: Colors.white,
              labelPadding:
                  EdgeInsets.symmetric(horizontal: 8.0), // Reduce padding
              tabs: [
                Tab(
                  icon: Icon(Icons.school, size: 20), // Adjust icon size
                  text: 'Grade',
                ),
                Tab(
                  icon: Icon(Icons.apartment, size: 20), // Adjust icon size
                  text: 'School',
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey[800],
        ),
        body: TabBarView(
          children: [
            GradeLevel(),
            HomePage(),
          ],
        ),
      ),
    );
  }
}
