import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../data/hooks/use_courses.dart';

class CourseDetails extends HookWidget {
  const CourseDetails({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final courseDetails = useCourse(context, id);

    if (courseDetails.isLoading) {
      return Text("Loading...");
    }

    if (courseDetails.isError) {
      return Text("Error: ${courseDetails.error}");
    }

    var courseEntity = courseDetails.data;

    return SingleChildScrollView(
        //This widget permit to scroll the screen if we have too much information to show
        child: Column(
      children: [
        Text(
          "${courseEntity?.name}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        Text("\n${courseEntity?.description}", textAlign: TextAlign.justify),
        Text(
          "\nStato: ${courseEntity?.availability.value}",
        ),
        Text("\nCategoria: ${courseEntity?.category.value}"),
        Text(
            "\nCreato il: ${courseEntity?.createdAt.year}/${courseEntity?.createdAt.month}/${courseEntity?.createdAt.day}"),
        Text("\nCosto (in Euro): ${courseEntity?.cost}"),
        Text("\nIstruttori: ${courseEntity?.instructors.toList()}"),

        /*

        TODO: Button to use to submit to the course

        ElevatedButton(
            onPressed: (){}, 
            child: Text("Iscriviti al corso")
        )

         */
      ],
    ));
  }
}
