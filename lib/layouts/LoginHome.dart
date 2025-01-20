import 'package:flutter/material.dart';
import 'package:littleflower/tabs/login/home.dart';
import 'package:littleflower/main.dart';
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
          actions: [
            IconButton(
              icon: const Icon(Icons.power_settings_new),
              onPressed: () {
                // Set isUserLoggedIn to false
                globalData.setIsUserLoggedIn(false);

                // Navigate to HomePage widget
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginHome(),
                  ),
                );
              },
            ),
          ],
        ),
        body: const HomePage(),
      ),
    );
  }
}