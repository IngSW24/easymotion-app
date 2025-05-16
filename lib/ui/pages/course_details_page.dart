import 'package:flutter/material.dart';
import '../components/courses/course_details.dart';

class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Course details',
              style: TextStyle(
                  color: Color(0xFF094D95), fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xFFCAE2FC),
        ),
        body: CourseDetails(id: id));
  }
}
