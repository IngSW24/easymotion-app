import 'package:easymotion_app/ui/components/courses/course_list_view.dart';
import 'package:easymotion_app/ui/components/filters/course_filters.dart';
import 'package:easymotion_app/ui/components/horizontal_chips_list.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  DateTime? _startDate, _endDate;

  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return CourseFilter( startDate: _startDate ?? DateTime.timestamp(), endDate: _endDate ?? DateTime.timestamp(),
              onStartDateChange: (DateTime date) {
                setModalState(() {
                  setState(() {
                    _startDate = date;
                  });
                });
              },onEndDateChange: (DateTime date) {
              setModalState(() {
                setState(() {
                  _endDate = date;
                });
              });
            },);
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
          if (_startDate != null)
            Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                    height: 40,
                    child: HorizontalChipsList(
                      maxWidth: 320,
                      labels: ["Start date: $_startDate"], // FIXME: show date only
                      onDeleted: (String tag) {
                        setState(() {
                          _startDate = null;
                        });
                      },
                    ))),
          if (_endDate != null)
            Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                    height: 40,
                    child: HorizontalChipsList(
                      maxWidth: 200,
                      labels: ["End date: $_endDate"],
                      onDeleted: (String tag) {
                        setState(() {
                          _endDate = null;
                        });
                      },
                    ))),
          Expanded(child: CourseListView())
        ]));
  }
}
