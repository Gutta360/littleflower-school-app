import 'package:flutter/material.dart';
import 'package:littleflower/home/tabs/login/login.dart';
import 'package:littleflower/home/tabs/staff/layout/staff.dart';
import 'package:littleflower/home/tabs/staff_details/layout/staff_details.dart';
import 'package:littleflower/home/tabs/student/layout/student.dart';
import 'package:littleflower/home/tabs/student_details/layout/student_details.dart';
import 'package:littleflower/main.dart';
import 'package:provider/provider.dart';

class LayoutWidget extends StatefulWidget {
  const LayoutWidget({super.key});

  @override
  _LayoutWidgetState createState() => _LayoutWidgetState();
}

class _LayoutWidgetState extends State<LayoutWidget> {
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
                icon: Icon(Icons.account_box),
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
                ? _buildAlreadyLoggedInTab(context, globalData)
                : LoginPage(), // Pass callback
            globalData.isUserLoggedIn
                ? SchoolRegistrationForm()
                : _buildDisabledTab(),
            globalData.isUserLoggedIn
                ? SchoolRegistrationFormDetails()
                : _buildDisabledTab(),
            globalData.isUserLoggedIn
                ? StaffRegistrationForm()
                : _buildDisabledTab(),
            globalData.isUserLoggedIn
                ? StaffRegistrationFormDetails()
                : _buildDisabledTab(),
            globalData.isUserLoggedIn
                ? _buildUnderProgressTab()
                : _buildDisabledTab(),
            globalData.isUserLoggedIn
                ? _buildUnderProgressTab()
                : _buildDisabledTab(),
            globalData.isUserLoggedIn
                ? _buildUnderProgressTab()
                : _buildDisabledTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledTab() {
    return const Center(
      child: Text(
        'Please log in to access this tab.',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildUnderProgressTab() {
    return const Center(
      child: Text(
        'Development under progress',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}

Widget _buildAlreadyLoggedInTab(BuildContext context, GlobalData globalData) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'You logged in Successfully!!!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 38),
      ElevatedButton(
        onPressed: () {
          globalData.setIsUserLoggedIn(false);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LayoutWidget()),
            (Route<dynamic> route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          minimumSize: const Size(120, 40),
          textStyle: const TextStyle(fontSize: 15),
        ),
        child: const Text('Logout'),
      ),
    ],
  );
}
