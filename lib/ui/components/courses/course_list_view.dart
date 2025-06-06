import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_courses.dart';
import 'package:easymotion_app/ui/components/courses/course_card.dart';
import 'package:easymotion_app/ui/components/utility/empty_alert.dart';
import 'package:easymotion_app/ui/components/utility/error_alert.dart';
import 'package:easymotion_app/ui/components/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'course_filter.type.dart';

class CourseListView extends HookWidget {
  const CourseListView({super.key, required this.courseFilterType});

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
    final courses = useCourses(context);
    final screenWidth = MediaQuery.of(context).size.width;

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

    // Usa ListView per schermi mobili, GridView per schermi più larghi
    if (screenWidth < 600) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: courseList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: CourseCard(course: courseList[index]),
          );
        },
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 340,
        childAspectRatio: 0.88,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: courseList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CourseCard(course: courseList[index]);
      },
    );
  }
}
