import 'package:easymotion_app/api-client-generated/schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_courses.dart';
import 'package:easymotion_app/ui/components/courses/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'course_filter.type.dart';

class CourseListView extends HookWidget {
  const CourseListView({super.key, required this.courseFilterType});

  final CourseFilterType courseFilterType;

  void onCourseClick(CourseEntity courseEntity, BuildContext context) {
    context.go("/details");
  }

  bool includeCourse(CourseEntity course) {
    if (courseFilterType.searchText.isNotEmpty &&
        !course.name
            .toLowerCase()
            .contains(courseFilterType.searchText.toLowerCase())) {
      return false;
    }

    if (courseFilterType.categories.isNotEmpty &&
        !courseFilterType.categories.contains(course.category.value)) {
      return false;
    }
    if (courseFilterType.levels.isNotEmpty &&
        !courseFilterType.levels.contains(course.level.value)) {
      return false;
    }
    if (courseFilterType.frequencies.isNotEmpty &&
        !courseFilterType.frequencies.contains(course.frequency.value)) {
      return false;
    }
    if (courseFilterType.availabilities.isNotEmpty &&
        !courseFilterType.availabilities.contains(course.availability.value)) {
      return false;
    }

    return true;
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

    var courseList = courses.data?.data?.where(includeCourse).toList();

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
