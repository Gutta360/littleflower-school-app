import 'package:flutter/material.dart';
import 'package:littleflower/layouts/accounts.dart';
import 'package:littleflower/layouts/inventory.dart';
import 'package:littleflower/layouts/stats.dart';
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

class LoginHome extends StatefulWidget {
  const LoginHome({super.key});

  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
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
            backgroundColor: Colors.orange[500],
          ),
          body: const HomePage()),
    );
  }
}
