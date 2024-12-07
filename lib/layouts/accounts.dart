import 'package:flutter/material.dart';
import 'package:littleflower/tabs/accounts/payment.dart';
import 'package:littleflower/utils/under_progress.dart';

class AccountsLayout extends StatefulWidget {
  const AccountsLayout({super.key});

  @override
  AccountsLayoutState createState() => AccountsLayoutState();
}

class AccountsLayoutState extends State<AccountsLayout> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                  icon: Icon(Icons.currency_rupee_rounded,
                      size: 20), // Adjust icon size
                  text: 'Payment',
                ),
                Tab(
                  icon: Icon(Icons.list_alt, size: 20), // Adjust icon size
                  text: 'Payment Details',
                ),
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
          backgroundColor: Colors.blue,
        ),
        body: TabBarView(
          children: [
            PaymentForm(),
            const UnderProgressWidget(),
            const UnderProgressWidget(),
            const UnderProgressWidget(),
          ],
        ),
      ),
    );
  }
}
