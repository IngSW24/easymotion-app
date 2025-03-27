import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../api-client-generated/schema.models.swagger.dart';
import '../../../data/hooks/use_courses.dart';

class MyCoursesListView extends HookWidget {

  void onCourseClick(CourseEntity courseEntity, BuildContext context) {
    context.go("details");
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

    var courseList = courses.data?.data?.toList();

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
          subtitle: ((identical('Non Attivo',
              'Attivo')) //Check if the course is Active or NOT
              ? Text('Attivo',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green))
              : Text('Terminato',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red))),
          trailing: ElevatedButton(
              onPressed: () => context.go("/details"),
              //_courseDialog(), //If I click on the button "Dettagli" it open a Dialog window that shows the course details
              child: const Text('Dettagli')),
        );
      },
    );
  }
}