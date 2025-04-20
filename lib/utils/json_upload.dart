import 'dart:convert';
import 'dart:html' as html; // For file picker
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JsonUploadWidget extends StatefulWidget {
  @override
  _JsonUploadWidgetState createState() => _JsonUploadWidgetState();
}

class _JsonUploadWidgetState extends State<JsonUploadWidget> {
  String? _statusMessage;

  void _pickJsonFile() {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.json';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files?.isEmpty ?? true) return;

      final file = files!.first;
      final reader = html.FileReader();

      reader.onLoadEnd.listen((e) async {
        try {
          final jsonString = reader.result as String;
          final jsonData = jsonDecode(jsonString);

          if (jsonData is List) {
            for (var entry in jsonData) {
              if (entry['adminno'] != null) {
                await FirebaseFirestore.instance
                    .collection('students')
                    .doc(entry['adminno'].toString())
                    .set(entry);
              }
            }
            setState(() {
              _statusMessage = "JSON data uploaded successfully!";
            });
          } else {
            setState(() {
              _statusMessage = "Invalid JSON format: Expected a list.";
            });
          }
        } catch (e) {
          setState(() {
            _statusMessage = "Error reading JSON: $e";
          });
        }
      });

      reader.readAsText(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: _pickJsonFile,
            icon: Icon(Icons.upload_file),
            label: Text("Upload JSON File"),
          ),
          if (_statusMessage != null) ...[
            SizedBox(height: 20),
            Text(_statusMessage!, style: TextStyle(color: Colors.green)),
          ],
        ],
      ),
    );
  }
}