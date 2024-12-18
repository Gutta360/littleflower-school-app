import 'package:flutter/material.dart';
import 'package:littleflower/layouts/accounts.dart';
import 'package:littleflower/layouts/inventory.dart';
import 'package:littleflower/layouts/student.dart';
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
        body: Row(
          children: [
            // Left side vertical tabs
            Container(
              width: 150, // Adjust width as needed
              color: Colors.grey[200],
              child: ListView(
                children: const [
                  TabTile(
                    icon: Icons.login,
                    label: 'Login',
                    tabIndex: 0,
                  ),
                  TabTile(
                    icon: Icons.school,
                    label: 'Student',
                    tabIndex: 1,
                  ),
                  TabTile(
                    icon: Icons.account_circle,
                    label: 'Student Details',
                    tabIndex: 2,
                  ),
                  TabTile(
                    icon: Icons.group,
                    label: 'Staff',
                    tabIndex: 3,
                  ),
                  TabTile(
                    icon: Icons.badge,
                    label: 'Staff Details',
                    tabIndex: 4,
                  ),
                  TabTile(
                    icon: Icons.currency_rupee_rounded,
                    label: 'Accounts',
                    tabIndex: 5,
                  ),
                  TabTile(
                    icon: Icons.inventory,
                    label: 'Inventory',
                    tabIndex: 6,
                  ),
                  TabTile(
                    icon: Icons.build_circle,
                    label: 'Utilities',
                    tabIndex: 7,
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
            // Right side TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  globalData.isUserLoggedIn
                      ? LoggedInWidget(globalData: globalData)
                      : const HomePage(),
                  globalData.isUserLoggedIn
                      ? StudentLayout()
                      : const LoggedOutWidget(),
                  globalData.isUserLoggedIn
                      ? StudentDetailsLayout()
                      : const LoggedOutWidget(),
                  globalData.isUserLoggedIn
                      ? StaffLayout()
                      : const LoggedOutWidget(),
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
          ],
        ),
      ),
    );
  }
}

class TabTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int tabIndex;

  const TabTile({
    required this.icon,
    required this.label,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DefaultTabController.of(context)?.animateTo(tabIndex);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
