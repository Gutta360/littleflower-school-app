import 'package:flutter/material.dart';

class LoggedOutWidget extends StatelessWidget {
  const LoggedOutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Please log in to access this tab.',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
