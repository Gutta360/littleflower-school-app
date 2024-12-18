import 'package:flutter/material.dart';
import 'package:littleflower/layouts/home.dart';
import 'package:littleflower/main.dart';

class LoggedInWidget extends StatelessWidget {
  final GlobalData globalData;

  const LoggedInWidget({Key? key, required this.globalData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              MaterialPageRoute(builder: (context) => const HomeLayout()),
              (Route<dynamic> route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey[800],
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size(120, 40),
            textStyle: const TextStyle(fontSize: 15),
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
