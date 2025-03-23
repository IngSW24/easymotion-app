import 'package:easymotion_app/api-client-generated/schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_courses.dart';
import 'package:easymotion_app/ui/components/CourseCard/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class CourseListView extends HookWidget {
  const CourseListView({super.key});

  void onCourseClick(CourseEntity courseEntity, BuildContext context) {
    context.go("/details");
  }

  @override
  Widget build(BuildContext context) {
    final courses = useCourses(context);

    if (courses.isLoading) {
      return Text("Loading...");
    }

    if (courses.isError) {
      return Text("Error: ${courses.error}");
    }

    var courseList = courses.data?.data;

    if (courseList == null || courseList.isEmpty) {
      return Text("Empty list");
    }

    return GridView.builder(
      itemCount: courseList.length,
      itemBuilder: (BuildContext ctx, int index) {
        return Padding(
            padding: EdgeInsets.all(6),
            child: CourseCard(
              course: courseList[index],
              onClick: () => onCourseClick(courseList[index], ctx),
            ));
      },
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 600,
          mainAxisExtent: 280,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8),
    );
  }
}
