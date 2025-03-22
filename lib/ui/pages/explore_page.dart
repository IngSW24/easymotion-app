import 'package:easymotion_app/ui/components/courses/course_list_view.dart';
import 'package:easymotion_app/ui/components/filters/course_filters.dart';
import 'package:easymotion_app/ui/components/horizontal_chips_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> _categories = [], _levels = [], _frequencies = [], _availabilities = [];

  List<String> get _filterList {
    List<String> list = [];
      list.addAll(_categories);

      list.addAll(_levels);

      list.addAll(_frequencies);

      list.addAll(_availabilities);

    return list;
  }

  String _convertDatetimeToString(DateTime dateTime) {
    return DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(dateTime);
  }

  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return CourseFilter(
            selectedCategories: _categories,
            selectedLevels: _levels,
            selectedFrequencies: _frequencies,
            selectedAvailabilities: _availabilities,
            onCategoriesChanged: (List<String> value) {
              setModalState(() {
                setState(() {
                  _categories = value;
                });
              });
            },
            onLevelsChanged: (List<String> value) {
              setModalState(() {
                setState(() {
                  _levels = value;
                });
              });
            },
            onFrequenciesChanged: (List<String> value) {
              setModalState(() {
                setState(() {
                  _frequencies = value;
                });
              });
            },
            onAvailabilitiesChanged: (List<String> value) {
              setModalState(() {
                setState(() {
                  _availabilities = value;
                });
              });
            },
          );
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
          if (_filterList.isNotEmpty)
            Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                    height: 40,
                    child: HorizontalChipsList(
                      maxWidth: 320,
                      labels: _filterList,
                      /*onDeleted: (String tag) {
                        setState(() {

                        });
                      },*/
                    ))),
          Expanded(child: CourseListView())
        ]));
  }
}
