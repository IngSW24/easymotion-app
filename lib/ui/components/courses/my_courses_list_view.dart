import 'package:easymotion_app/data/hooks/use_subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../../api-client-generated/api_schema.models.swagger.dart';
import '../../../data/common/static_resources.dart';
import 'course_filter.type.dart';

class MyCoursesListView extends HookWidget {
  const MyCoursesListView({super.key, required this.courseFilterType});

  final CourseFilterType courseFilterType;

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
    final courses = useCoursesSubscribed(context);

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
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              "${StaticResources.uri}/${courseList[index].category.value?.toLowerCase()}.jpg",
            ),
          ),
          subtitle: ((identical(courseList[index].availability.value,
                  'ACTIVE')) //Check if the course is Active or NOT
              ? Text('Attivo',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green))
              : Text('Terminato',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red))),
          trailing: IconButton(
            tooltip: "Dettagli corso",
            onPressed: () =>
                context.go('/my_courses/details/${courseList[index].id}'),
            icon: Icon(Icons.launch),
          ),
        );
      },
    );
  }
}
