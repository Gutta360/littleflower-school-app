import 'package:flutter/material.dart';
import 'package:littleflower/layouts/accounts.dart';
import 'package:littleflower/layouts/inventory.dart';
import 'package:littleflower/layouts/student.dart';
import 'package:littleflower/tabs/inventory/stock_status.dart';
import 'package:littleflower/tabs/login/home_page.dart';
import 'package:littleflower/tabs/login/loggedIn.dart';
import 'package:littleflower/layouts/staff.dart';
import 'package:littleflower/layouts/staff_details.dart';
import 'package:littleflower/layouts/student_details.dart';
import 'package:littleflower/main.dart';
import 'package:littleflower/tabs/login/loggedout.dart';
import 'package:littleflower/utils/under_progress.dart';
import 'package:provider/provider.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    final globalData = Provider.of<GlobalData>(context);
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.login),
                text: 'Login',
              ),
              Tab(
                icon: Icon(Icons.school),
                text: 'Student',
              ),
              Tab(
                icon: Icon(Icons.account_circle),
                text: 'Student Details',
              ),
              Tab(
                icon: Icon(Icons.group),
                text: 'Staff',
              ),
              Tab(
                icon: Icon(Icons.badge),
                text: 'Staff Details',
              ),
              Tab(
                icon: Icon(Icons.currency_rupee_rounded),
                text: 'Accounts',
              ),
              Tab(
                icon: Icon(Icons.inventory),
                text: 'Inventory',
              ),
              Tab(
                icon: Icon(Icons.build_circle),
                text: 'Utilities',
              ),
            ],
          ),
          title: const Text(
            'A Little Flower The Leader',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: TabBarView(
          children: [
            //LoginPage(onLoginSuccess: handleLoginSuccess),
            globalData.isUserLoggedIn
                ? LoggedInWidget(globalData: globalData)
                : const HomePage(),
            globalData.isUserLoggedIn
                ? StudentLayout()
                : const LoggedOutWidget(),
            globalData.isUserLoggedIn
                ? StudentDetailsLayout()
                : const LoggedOutWidget(),
            globalData.isUserLoggedIn ? StaffLayout() : const LoggedOutWidget(),
            globalData.isUserLoggedIn
                ? StaffDetailsLayout()
                : const LoggedOutWidget(),
            globalData.isUserLoggedIn
                ? const AccountsLayout()
                : const LoggedOutWidget(),
            globalData.isUserLoggedIn
                ? const InventoryLayout()
                : const LoggedOutWidget(),
            globalData.isUserLoggedIn
                ? const UnderProgressWidget()
                : const LoggedOutWidget(),
          ],
        ),
      ),
    );
  }
}
