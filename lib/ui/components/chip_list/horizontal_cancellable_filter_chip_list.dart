import 'package:flutter/material.dart';

class FilterChipItem {
  FilterChipItem({required this.key, required this.label});

  final String key;
  final String label;
}

class HorizontalCancellableFilterChipList extends StatelessWidget {
  const HorizontalCancellableFilterChipList(
      {super.key,
      required this.items,
      this.maxWidth = 100,
      required this.onDeleted});

  final List<FilterChipItem> items;
  final double maxWidth;
  final void Function(String) onDeleted;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (BuildContext ctx, int index) => Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Chip(
            label: Text(
              items[index].label,
              overflow: TextOverflow.ellipsis,
            ),
            onDeleted: () => onDeleted(items[index].key),
          )),
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(width: 10),
    );
  }
}
