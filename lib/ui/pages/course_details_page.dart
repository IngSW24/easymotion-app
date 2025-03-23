import 'package:flutter/material.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Easymotion'),
        ),
        body: Text("Course details"));
  }
}
