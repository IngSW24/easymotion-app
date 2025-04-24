import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_courses.dart';
import 'package:easymotion_app/ui/components/utility/error_alert.dart';
import 'package:easymotion_app/ui/components/utility/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../data/common/static_resources.dart';
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

    if (courses.isLoading) {
      return LoadingIndicator();
    }

    final fullCourseList = courses.data?.data;
    if (courses.isError || fullCourseList == null) {
      return ErrorAlert();
    }

    final courseList = fullCourseList.where(includeCourse).toList();

    if (courseList.isEmpty) {
      return Text("Empty list");
    }

    return GridView.count(
      crossAxisCount: 1,
      mainAxisSpacing: 25,
      children: List.generate(courseList.length, (index) {
        return Card(
            child: InkWell(
          onTap: () => context.push('/details/${courseList[index].id}'),
          child: Padding(
            padding: EdgeInsets.all(10),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                    "${StaticResources.uri}/${courseList[index].category.id}.jpg"),
              ),
              Center(
                child: Text(
                  "\n${courseList[index].name}",
                  style: TextStyle(
                      color: Color(0xFF094D95), fontWeight: FontWeight.bold),
                ),
              ),
              Text(courseList[index].shortDescription),

              /*
                          ElevatedButton(

                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Color(0xFF094D95))
                            ),
                            onPressed: () =>
                                context.go('/explore/details/${courseList[index].id}'),

                            child: Row(
                              children: [
                                Icon(Icons.launch, color: Color(0xFFFDFDFD)),
                                Center(
                                  child: Text("  Dettagli corso", style: TextStyle(color: Color(0xFFFDFDFD), fontWeight: FontWeight.bold)),
                                )

                              ],
                            ),
                          )
                          */
            ]),
          ),
        ));
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
            onPressed: () => context.push('/details/${courseList[index].id}'),
            icon: Icon(Icons.launch),
          ),
        );
      },
    );*/
  }
}
