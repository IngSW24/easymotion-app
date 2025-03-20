import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseFilter extends StatelessWidget {
  const CourseFilter(
      {super.key,
      required this.availableFilters,
      required this.activeFilters,
      required this.onFilterChange});

  final List<String> availableFilters;
  final List<String> activeFilters;
  final void Function(String, bool) onFilterChange;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(16),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('Select Filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableFilters.map((filter) {
              return FilterChip(
                label: Text(filter),
                avatar: CircleAvatar(),
                selected: activeFilters.contains(filter),
                onSelected: (selected) => onFilterChange(filter, selected),
              );
            }).toList(),
          ),
          Spacer(),
          Expanded(
            flex: 0,
            child: FilledButton.icon(
              onPressed: () => context.pop(),
              label: Text('Apply Filters'),
              icon: Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }
}
