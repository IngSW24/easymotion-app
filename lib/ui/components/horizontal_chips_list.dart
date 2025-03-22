import 'package:flutter/material.dart';

class HorizontalChipsList extends StatelessWidget {
  const HorizontalChipsList({super.key, required this.labels, this.maxWidth  =100, this.onDeleted});

  final List<String> labels;
  final double maxWidth;
  final void Function(String)? onDeleted;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: labels.length,
      itemBuilder: (BuildContext ctx, int index) => Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Chip(
            label: Text(
              labels[index],
              overflow: TextOverflow.ellipsis,
            ),
            onDeleted:
                onDeleted != null ? () => onDeleted?.call(labels[index]) : null,
          )),
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(width: 10),
    );
  }
}
