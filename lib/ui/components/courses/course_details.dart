import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:easymotion_app/ui/components/subscriptions/subscribe_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../data/hooks/use_courses.dart';

class CourseDetails extends HookWidget {
  const CourseDetails({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final userInfo = useUserInfo(context);
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
        child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "${courseEntity?.name}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          Text("\n${courseEntity?.description}", textAlign: TextAlign.justify),
          Text("\nCategoria: ${courseEntity?.category.name}"),
          Text(
              "\nCreato il: ${courseEntity?.createdAt.year}/${courseEntity?.createdAt.month}/${courseEntity?.createdAt.day}"),
          Text("\nCosto (in Euro): ${courseEntity?.price}"),
          Text("\nIstruttori: ${courseEntity?.instructors.toList()}"),
          SizedBox(
            height: 16,
          ),
          if (userInfo() != null) SubscribeButton(courseID: id)
        ],
      ),
    ));
  }
}
