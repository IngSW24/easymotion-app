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
    context.go("details");
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

    return ListView.builder(
      itemCount: courseList.length,
      itemBuilder: (BuildContext ctx, int index) {
        return ListTile(
          title: Text(
            courseList[index].name,
            overflow: TextOverflow.ellipsis,
          ),
          leading: Image.network('https://picsum.photos/250?image=9'),
          subtitle: ((identical(courseList[index].availability.value,
                  'ACTIVE')) //Check if the course is Active or NOT
              ? Text('Attivo',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green))
              : Text('Terminato',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red))),
          trailing: ElevatedButton(
              onPressed: () => context.go('/details/${courseList[index].id}'),
              //_courseDialog(), //If I click on the button "Dettagli" it open a Dialog window that shows the course details
              child: const Text('Dettagli')),
        );
      },
    );
  }
}
