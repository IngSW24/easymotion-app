import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:easymotion_app/ui/components/subscriptions/subscribe_button.dart';
import 'package:easymotion_app/ui/components/utility/error_alert.dart';
import 'package:easymotion_app/ui/components/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../data/common/static_resources.dart';
import '../../../data/hooks/use_courses.dart';

class CourseDetails extends HookWidget {
  const CourseDetails({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final userInfo = useUserInfo(context);
    final courseDetails = useCourse(context, id);

    if (courseDetails.isLoading) {
      return LoadingIndicator();
    }

    if (courseDetails.isError) {
      return ErrorAlert();
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
            "${courseEntity?.name}\n",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
                "${StaticResources.uri}/${courseEntity?.category.id}.jpg"),
          ),
          Text("\nDescrizione:", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("\n${courseEntity?.description}", textAlign: TextAlign.justify),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                    text: "\nCategoria: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "${courseEntity?.category.name}"),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                    text: "\nCreato il: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          "${courseEntity?.createdAt.year}/${courseEntity?.createdAt.month}/${courseEntity?.createdAt.day}"),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                    text: "\nCosto (in Euro): ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "${courseEntity?.price}"),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                    text: "\nIstruttori: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "${courseEntity?.instructors.toList()}"),
                ]),
          ),

          /*
          Text("\nCategoria: ${courseEntity?.category.name}"),
          Text("\nCreato il: ${courseEntity?.createdAt.year}/${courseEntity?.createdAt.month}/${courseEntity?.createdAt.day}"),
          Text("\nCosto (in Euro): ${courseEntity?.price}"),
          Text("\nIstruttori: ${courseEntity?.instructors.toList()}"),
          */

          SizedBox(
            height: 16,
          ),
          if (userInfo() != null) SubscribeButton(courseID: id)
        ],
      ),
    ));
  }
}
