import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SendTextMessage extends StatefulWidget {
  @override
  _SendTextMessageState createState() => _SendTextMessageState();
}

class _SendTextMessageState extends State<SendTextMessage> {
  String? selectedStudentName;
  String? selectedPhoneNumber;

  Future<void> sendSMS(String phoneNumber, String message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      query: 'body=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw "Could not launch $smsUri";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Text Message")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('students').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final students = snapshot.data!.docs;

                return DropdownButton<String>(
                  isExpanded: true,
                  value: selectedStudentName,
                  hint: Text("Select a student"),
                  items: students.map((student) {
                    final studentName = student['student_name'] as String;
                    final fatherPhone = student['father_phone'] as String;

                    return DropdownMenuItem<String>(
                      value: studentName,
                      child: Text(studentName),
                      onTap: () {
                        setState(() {
                          selectedPhoneNumber = fatherPhone;
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStudentName = value;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedPhoneNumber != null
                  ? () => sendSMS(selectedPhoneNumber!, "Hi")
                  : null,
              child: Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}
