import 'package:easymotion_app/api-client-generated/schema.swagger.dart';
import 'package:easymotion_app/data/providers/static_provider.dart';
import 'package:flutter/material.dart';

import '../horizontal_chips_list.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course, required this.onClick});

  final CourseEntity course;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onClick,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  "${StaticProvider.uri}/${course.category.value?.toLowerCase()}.jpg",
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                course.name,
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                course.shortDescription,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 30,
                child: HorizontalChipsList(labels: course.tags),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
