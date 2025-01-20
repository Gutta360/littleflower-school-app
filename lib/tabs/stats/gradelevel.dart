import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String name;
  final double paidAmount;
  final double totalAmount;

  Student(
      {required this.name,
      required this.paidAmount,
      required this.totalAmount});

  // Factory method to create a Student object from Firestore data
  factory Student.fromFirestore(Map<String, dynamic> data, double totalPaid) {
    return Student(
      name: data['student_name'] ?? 'Unknown',
      paidAmount: totalPaid,
      totalAmount:
          double.tryParse(data['student_total_fee']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class StudentListView extends StatelessWidget {
  Future<List<Student>> fetchStudents() async {
    final studentSnapshot =
        await FirebaseFirestore.instance.collection('students').get();
    List<Student> studentList = [];

    for (var studentDoc in studentSnapshot.docs) {
      final paymentSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('student_name', isEqualTo: studentDoc.get('student_name'))
          .get();

      double totalPaid = paymentSnapshot.docs.fold(0.0, (sum, doc) {
        return sum +
            (double.tryParse(doc['payment_amount']?.toString() ?? '0') ?? 0.0);
      });

      studentList.add(Student.fromFirestore(studentDoc.data(), totalPaid));
    }

    // Sort the students based on the percentage of paidAmount / totalAmount
    studentList.sort((a, b) {
      double percentageA = (a.paidAmount / a.totalAmount) * 100;
      double percentageB = (b.paidAmount / b.totalAmount) * 100;
      return percentageA.compareTo(percentageB);
    });

    return studentList;
  }

  Color getBarColor(double percentage) {
    if (percentage <= 25) {
      return Colors.red;
    } else if (percentage <= 50) {
      return Colors.orange;
    } else if (percentage <= 75) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Student>>(
      future: fetchStudents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error fetching students: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No students found'));
        }

        final students = snapshot.data!;

        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            final percentage = (student.paidAmount / student.totalAmount) * 100;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double barWidth = percentage / 100 * constraints.maxWidth;

                      return Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: barWidth,
                              decoration: BoxDecoration(
                                color: getBarColor(percentage),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(8),
                                  right: percentage == 100
                                      ? Radius.circular(8)
                                      : Radius.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "₹${student.paidAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      Text(
                        student.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "₹${student.totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
