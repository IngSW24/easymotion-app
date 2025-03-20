import 'package:easymotion_app/ui/components/courses/course_list_view.dart';
import 'package:easymotion_app/ui/components/filters/course_filters.dart';
import 'package:easymotion_app/ui/components/horizontal_chips_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<String> activeFilters = [];

  final List<String> availableFilters = const [
    'Popular',
    'Recent',
    'Trending',
    'Favorites'
  ];

  void onChange(String filter, bool selected) {
    setState(() {
      selected ? activeFilters.add(filter) : activeFilters.remove(filter);
    });
  }

  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return CourseFilter(
              availableFilters: availableFilters,
              activeFilters: activeFilters,
              onFilterChange: (String filter, bool selected) {
                setModalState(() {
                  onChange(filter, selected);
                });
              });
        });
      },
    );
  }

  void onSearchChanged(String query) {
    // TODO: search
    print(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Easymotion'),
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),*/
        body: Column(children: [
          Padding(
              padding: EdgeInsets.all(8),
              child: SearchAnchor(
                viewOnChanged: onSearchChanged,
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                      controller: controller,
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (String query) {
                        controller.openView();
                      },
                      leading: Icon(Icons.search),
                      trailing: [
                        Tooltip(
                            message: "Open filters menu",
                            child: IconButton(
                                onPressed: () {
                                  _openFilterBottomSheet(context);
                                },
                                icon: Icon(Icons.filter_alt_outlined))),
                      ]);
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index'; // TODO: temporary
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                        });
                      },
                    );
                  });
                },
              )),
          if (activeFilters.isNotEmpty)
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
