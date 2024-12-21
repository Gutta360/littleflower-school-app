import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GradeLevel extends StatefulWidget {
  @override
  _GradeLevelState createState() => _GradeLevelState();
}

class _GradeLevelState extends State<GradeLevel> {
  final List<String> grades = ["PP1", "PP2", "1", "2", "3", "4", "5"];
  String? selectedGrade;
  List<Map<String, dynamic>> students = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Dropdown for Grades
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Grade",
              border: OutlineInputBorder(),
            ),
            value: selectedGrade,
            items: grades
                .map((grade) =>
                    DropdownMenuItem(value: grade, child: Text(grade)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedGrade = value;
              });
              if (value != null) {
                _fetchStudentsByGrade(value);
              }
            },
          ),
          const SizedBox(height: 16),
          // Table for Students
          Expanded(
            child: students.isEmpty
                ? const Center(
                    child: Text(
                      "No students found for the selected grade.",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final double totalFee = double.tryParse(
                              student["student_total_fee"] ?? "0") ??
                          0.0;
                      final double paidFee = student["paid"] ?? 0.0;
                      final double percent =
                          totalFee > 0 ? (paidFee / totalFee) : 0.0;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Name Column
                              Expanded(
                                flex: 3,
                                child: Text(
                                  student["student_name"],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              // Paid Fee Column
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Paid: ${paidFee.toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              // Percent Bar Column
                              Expanded(
                                flex: 4,
                                child: LinearPercentIndicator(
                                  animation: true,
                                  animationDuration: 1000,
                                  lineHeight: 20.0,
                                  percent: percent.clamp(0.0, 1.0),
                                  center: Text(
                                    "${(percent * 100).toStringAsFixed(1)}%",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: _getProgressColor(percent),
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                              // Total Fee Column
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Total: ${totalFee.toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Fetch students by grade from Firestore
  Future<void> _fetchStudentsByGrade(String grade) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('student_grade', isEqualTo: grade)
          .get();

      final List<Map<String, dynamic>> fetchedStudents = await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data() as Map<String, dynamic>;
          final String studentName = data["student_name"] ?? "Unknown";
          final String totalFeeString = data["student_total_fee"] ?? "0.0";

          // Calculate total paid fee
          final double paidFee = await _calculatePaidFee(studentName);

          return {
            "student_name": studentName,
            "student_total_fee": totalFeeString,
            "paid": paidFee,
          };
        }).toList(),
      );

      setState(() {
        students = fetchedStudents;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching students: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Calculate total paid fee for a student
  Future<double> _calculatePaidFee(String studentName) async {
    try {
      QuerySnapshot paymentSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('student_name', isEqualTo: studentName)
          .get();

      return paymentSnapshot.docs.fold<double>(0.0, (double sum, doc) {
        double paymentAmount =
            double.tryParse(doc['payment_amount'].toString()) ?? 0.0;
        return sum + paymentAmount;
      });
    } catch (e) {
      return 0.0;
    }
  }

  /// Get progress color based on percentage
  Color _getProgressColor(double percent) {
    if (percent <= 0.24) {
      return Colors.red;
    } else if (percent <= 0.49) {
      return Colors.orange;
    } else if (percent <= 0.74) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }
}