import 'package:easymotion_app/ui/components/subscriptions/subscription_details.dart';
import 'package:easymotion_app/ui/components/utility/error_alert.dart';
import 'package:easymotion_app/ui/components/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../../data/common/datetime/datetime2local.dart';
import '../../../data/common/static_resources.dart';
import '../../../data/hooks/use_courses.dart';

class CourseDetails extends HookWidget {
  const CourseDetails({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final courseDetails = useCourse(context, id);

    if (courseDetails.isLoading) {
      return LoadingIndicator();
    }

    if (courseDetails.isError) {
      return ErrorAlert();
    }

    final courseEntity = courseDetails.data;
    if (courseEntity == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/explore');
      });
      return LoadingIndicator();
    }

    return SingleChildScrollView(
        //This widget permit to scroll the screen if we have too much information to show
        child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            courseEntity.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          Image.network(
              fit: BoxFit.contain,
              height: 240,
              "${StaticResources.uri}/${courseEntity.category.id}.jpg"),
          _buildCourseInfo("Descrizione breve", courseEntity.shortDescription),
          _buildCourseInfo("Descrizione", courseEntity.description),
          _buildCourseInfo("Categoria", courseEntity.category.name),
          _buildCourseInfo("Creato il", datetime2local(courseEntity.createdAt)),
          _buildCourseInfo("Costo", "€ ${courseEntity.price.toString()}"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Istruttori",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                ...courseEntity.instructors
                    .map((item) => Text(courseEntity.instructors[0]))
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          SubscriptionDetails(courseDetails: courseEntity)
        ],
      ),
    ));
  }

  Widget _buildCourseInfo(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(icon, color: Colors.grey.shade600),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
