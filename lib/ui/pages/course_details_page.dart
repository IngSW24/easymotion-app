import 'package:flutter/material.dart';
import '../components/courses/course_details.dart';

class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Course details'),
        ),
        body: CourseDetails());
  }
}
