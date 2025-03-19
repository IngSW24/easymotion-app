import 'package:easymotion_app/ui/components/course_list_view.dart';
import 'package:easymotion_app/ui/components/filters/course_filter_chips.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> activeFilters = const [];
  final List<String> availableFilters = const ['Popular', 'Recent', 'Trending', 'Favorites'];

  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: availableFilters.map((filter) {
                  return FilterChip(
                    label: Text(filter),
                    selected: activeFilters.contains(filter),
                    onSelected: (selected) {
                      setState(() {
                        selected ? activeFilters.add(filter) : activeFilters.remove(filter);
                      });
                    },
                  );
                }).toList(),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Easymotion'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {_openFilterBottomSheet(context);},
          child: Icon(Icons.add),
        ),
        body: Column(children: [
          Padding(
              padding: EdgeInsets.all(8),
              child:
                  SizedBox(height: 40, child: CourseFilterChips(tags: activeFilters, selectedTags: [0],))),
          Expanded(child: CourseListView())
        ]));
  }
}
