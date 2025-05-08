import 'package:easymotion_app/data/hooks/use_subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../../api-client-generated/api_schema.models.swagger.dart';
import '../../../data/common/static_resources.dart';
import '../utility/empty_alert.dart';
import '../utility/error_alert.dart';
import '../utility/loading.dart';
import 'course_filter.type.dart';

class MyCoursesListView extends HookWidget {
  const MyCoursesListView({super.key, required this.courseFilterType});

  final CourseFilterType courseFilterType;

  bool includeCourse(CourseDto course) {
    if (courseFilterType.searchText.isNotEmpty &&
        !course.name
            .toLowerCase()
            .contains(courseFilterType.searchText.toLowerCase())) {
      return false;
    }

    if (courseFilterType.categories.isNotEmpty &&
        !courseFilterType.categories.contains(course.category.id)) {
      return false;
    }
    if (courseFilterType.levels.isNotEmpty &&
        !courseFilterType.levels.contains(course.level.value)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final courses = useCoursesSubscribed(context);

    if (courses.isLoading) {
      return LoadingIndicator();
    }

    final fullCourseList = courses.data?.data;
    if (courses.isError || fullCourseList == null) {
      return ErrorAlert();
    }

    final courseList = fullCourseList.where(includeCourse).toList();

    if (courseList.isEmpty) {
      return EmptyAlert();
    }

    return ListView.builder(
      itemCount: courseList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext ctx, int index) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          title: Text(
            courseList[index].name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Color(0xFF094D95), fontWeight: FontWeight.bold),
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
            onPressed: () => context.push('/details/${courseList[index].id}'),
            icon: Icon(Icons.launch),
          ),
        );
      },
    );
  }
}
