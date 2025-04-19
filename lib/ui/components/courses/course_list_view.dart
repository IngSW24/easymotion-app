import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../data/common/static_resources.dart';
import 'course_filter.type.dart';

class CourseListView extends HookWidget {
  const CourseListView(
      {super.key, required this.pathPrefix, required this.courseFilterType});

  final CourseFilterType courseFilterType;
  final String pathPrefix;

  bool includeCourse(CourseDto course) {
    if (courseFilterType.searchText.isNotEmpty &&
        !course.name
            .toLowerCase()
            .contains(courseFilterType.searchText.toLowerCase())) {
      return false;
    }

    if (courseFilterType.categories.isNotEmpty &&
        !courseFilterType.categories.contains(course.category.name)) {
      return false;
    }
    if (courseFilterType.levels.isNotEmpty &&
        !courseFilterType.levels.contains(course.level.value)) {
      return false;
    }
    /*if (courseFilterType.frequencies.isNotEmpty &&
        !courseFilterType.frequencies.contains(course.frequency.value)) {
      return false;
    }
    if (courseFilterType.availabilities.isNotEmpty &&
        !courseFilterType.availabilities.contains(course.availability.value)) {
      return false;
    }*/

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

    return GridView.count(
      crossAxisCount: 1,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      crossAxisSpacing: 5,
      mainAxisSpacing: 0,
      children: List.generate(courseList.length, (index) {
        return Container(

            child: Column(
              children: [
                Image.network("${StaticResources.uri}/${courseList[index].category.id}.jpg"),
                Center(
                  child: Text("${courseList[index].name}", style: TextStyle(color: Color(0xFF094D95), fontWeight: FontWeight.bold),),
                ),
                Text("${courseList[index].shortDescription}"),
              ]
              
            ),

        );
      }),
    );

    /*return ListView.builder(
      itemCount: courseList.length,
      itemBuilder: (BuildContext ctx, int index) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          title: Text(
            courseList[index].name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Color(0xFF094D95), fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            courseList[index].shortDescription,
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              "${StaticResources.uri}/${courseList[index].category.id}.jpg",
            ),
          ),
          trailing: IconButton(
            tooltip: "Dettagli corso",
            onPressed: () =>
                context.go('/explore/details/${courseList[index].id}'),
            icon: Icon(Icons.launch),
          ),
        );
      },
    );*/
  }
}
