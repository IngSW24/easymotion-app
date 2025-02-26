import 'package:easymotion_app/ui/components/course_list_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key /*, required this.coursesApi*/});

  //final CoursesApi coursesApi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App title'),
      ),
      body: CourseListView(/*coursesApi: coursesApi*/),
    );
  }
}
