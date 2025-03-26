import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../data/hooks/use_courses.dart';

class CourseDetails extends HookWidget {
  const CourseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final courseDetails = useCourse(context, "ID");

    if (courseDetails.isLoading) {
      return Text("Loading...");
    }

    if (courseDetails.isError) {
      return Text("Error: ${courseDetails.error}");
    }

    var courseEntity = courseDetails.data;
    return Text("Course details: ${courseEntity?.name}");
  }
}
