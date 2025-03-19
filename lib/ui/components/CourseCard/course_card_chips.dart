import 'package:flutter/material.dart';

class CourseCardChips extends StatelessWidget {
  const CourseCardChips({
    super.key,
    required this.courseTags,
  });

  final List<String> courseTags;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: courseTags.length,
      itemBuilder: (BuildContext ctx, int index) => Container(
        constraints: BoxConstraints(maxWidth: 100),
        child: Chip(
            label: Text(
              courseTags[index],
              overflow: TextOverflow.ellipsis,
            ),
            side: BorderSide.none,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Color(0xffcae2fc)),
      ),
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(width: 10),
    );
  }
}
