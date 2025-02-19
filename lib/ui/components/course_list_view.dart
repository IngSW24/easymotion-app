import 'package:easymotion_app/api-client-generated/lib/api.dart';
import 'package:easymotion_app/data/hooks/use_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CourseListView extends HookWidget {
  const CourseListView({super.key, required this.coursesApi});
  final CoursesApi coursesApi;

  @override
  Widget build(BuildContext context) {
    final courses = useCourses(coursesApi);
    if (courses.isLoading) {
      return Text("Loading...");
    }

    if (courses.isError) {
      return Text("Error...${courses.error}");
    }

    return Column(
      children: courses.data!.data.map((course) {
        return Text(course.name);
      }).toList(),
    );
  }
}
