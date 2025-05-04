import 'package:easymotion_app/api-client-generated/api_schema.swagger.dart';
import 'package:easymotion_app/data/common/static_resources.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final CourseDto course;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () => context.push('/details/${course.id}'),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
                "${StaticResources.uri}/${course.category.id}.jpg"),
          ),
          Center(
            child: Text(
              "\n${course.name}",
              style: TextStyle(
                  color: Color(0xFF094D95), fontWeight: FontWeight.bold),
            ),
          ),
          Text(course.shortDescription),
        ]),
      ),
    ));
  }
}
