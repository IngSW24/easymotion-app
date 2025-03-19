import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseFilterChips extends StatelessWidget {
  const CourseFilterChips({
    super.key,
    required this.tags,
    this.selectedTags = const []
  });

  final List<String> tags;
  final List<int> selectedTags;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext ctx, int index) => Container(
              constraints: BoxConstraints(maxWidth: 100),
              child: Chip(
                  label: Text(
                    tags[index],
                    overflow: TextOverflow.ellipsis,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: selectedTags.contains(index) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary),
            ),
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 10),
        itemCount: tags.length);
  }
}
