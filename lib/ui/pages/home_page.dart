import 'package:easymotion_app/ui/components/course_list_view.dart';
import 'package:easymotion_app/ui/components/horizontal_chips_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> activeFilters = [];

  final List<String> availableFilters = const [
    'Popular',
    'Recent',
    'Trending',
    'Favorites'
  ];

  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.all(16),
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Filters',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableFilters.map((filter) {
                    return FilterChip(
                      label: Text(filter),
                      selected: activeFilters.contains(filter),
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? activeFilters.add(filter)
                              : activeFilters.remove(filter);
                        });
                        setModalState(() {});
                      },
                    );
                  }).toList(),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text('Apply Filters'),
                ),
              ],
            ),
          );
        });
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
          onPressed: () {
            _openFilterBottomSheet(context);
          },
          child: Icon(Icons.add),
        ),
        body: Column(children: [
          Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                  height: 40,
                  child: HorizontalChipsList(
                    labels: activeFilters,
                    onDeleted: (String tag) {
                      setState(() {
                        activeFilters.remove(tag);
                      });
                    },
                  ))),
          Expanded(child: CourseListView())
        ]));
  }
}
