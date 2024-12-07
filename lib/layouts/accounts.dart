import 'package:flutter/material.dart';

class AccountsLayout extends StatefulWidget {
  const AccountsLayout({super.key});

  @override
  AccountsLayoutState createState() => AccountsLayoutState();
}

class AccountsLayoutState extends State<AccountsLayout> {
  @override
  Widget build(BuildContext context) {
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
                text: 'Payment',
              ),
              Tab(
                icon: Icon(Icons.school),
                text: 'Payment Details',
              ),
              Tab(
                icon: Icon(Icons.account_circle),
                text: 'Salary',
              ),
              Tab(
                icon: Icon(Icons.group),
                text: 'Salary Details',
              )
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: TabBarView(
          children: [
            _buildUnderProgressTab(),
            _buildUnderProgressTab(),
            _buildUnderProgressTab(),
            _buildUnderProgressTab(),
          ],
        ),
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
