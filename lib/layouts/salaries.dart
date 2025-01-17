import 'package:flutter/material.dart';
import 'package:littleflower/tabs/accounts/payment.dart';
import 'package:littleflower/tabs/accounts/payment_details.dart';
import 'package:littleflower/utils/under_progress.dart';

class SalariesLayout extends StatefulWidget {
  const SalariesLayout({super.key});

  @override
  SalariesLayoutState createState() => SalariesLayoutState();
}

class SalariesLayoutState extends State<SalariesLayout> {
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
                  icon: Icon(Icons.currency_rupee_rounded,
                      size: 20), // Adjust icon size
                  text: 'Salary',
                ),
                Tab(
                  icon: Icon(Icons.list_alt, size: 20), // Adjust icon size
                  text: 'Salary Details',
                )
              ],
            ),
          ),
          backgroundColor: Colors.grey[800],
        ),
        body: const TabBarView(
          children: [
            UnderProgressWidget(),
            UnderProgressWidget(),
          ],
        ),
      ),
    );
  }
}
