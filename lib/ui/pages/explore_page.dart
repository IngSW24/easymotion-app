import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:easymotion_app/ui/components/courses/course_filter.type.dart';
import 'package:easymotion_app/ui/components/courses/course_list_view.dart';
import 'package:easymotion_app/ui/components/courses/course_filters.dart';
import 'package:easymotion_app/ui/components/chip_list/horizontal_chips_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchText = "";
  List<String> _categories = [],
      _levels = [],
      _frequencies = [],
      _availabilities = [];

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
    setState(() {
      _searchText = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = useUserInfo(context);
    final logout = useLogoutFn(context);
    final user = userInfo();

    return Scaffold(
        appBar: AppBar(
          title: Text(
              user != null ? "Esplora corsi, ${user.firstName}" : 'Easymotion',
            style: TextStyle(color: Color(0xFF094D95), fontWeight: FontWeight.bold)),
          actions: [
            if (user == null)
              IconButton(
                  tooltip: "Login",
                  onPressed: () => context.go("/login"),
                  icon: Icon(Icons.login))
            else
              IconButton(
                  tooltip: "Logout",
                  onPressed: () => logout(),
                  icon: Icon(Icons.logout))
          ],
        ),
        body: Column(children: [
          Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cerca corsi (es. nuoto)",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                      tooltip: "Open filters",
                      onPressed: () => _openFilterBottomSheet(context),
                      icon: Icon(Icons.filter_alt_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                onChanged: onSearchChanged,
              )),
          if (_categories.isNotEmpty ||
              _levels.isNotEmpty ||
              _frequencies.isNotEmpty ||
              _availabilities.isNotEmpty)
            Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                    height: 40,
                    child: HorizontalChipsList(
                      maxWidth: 320,
                      labels: _categories
                              .map((key) => CourseFilter.categories[key] ?? "")
                              .toList() +
                          _levels
                              .map((key) => CourseFilter.levels[key] ?? "")
                              .toList() +
                          _frequencies
                              .map((key) => CourseFilter.frequencies[key] ?? "")
                              .toList() +
                          _availabilities
                              .map((key) =>
                                  CourseFilter.availabilities[key] ?? "")
                              .toList(),
                      /*onDeleted: (String tag) {
                        setState(() {
                          _categories.remove(tag);
                          _levels.remove(tag);
                          _frequencies.remove(tag);
                          _availabilities.remove(tag);
                        });
                      },*/
                    ))),
          Text(
              "Suggeriti per te",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
          ),
          Expanded(
              child:

                CourseListView(
                          pathPrefix: '/explore',
                          courseFilterType: CourseFilterType(
                              searchText: _searchText,
                              categories: _categories,
                              levels: _levels,
                              frequencies: _frequencies,
                              availabilities: _availabilities),
              ),
          )
        ]));
  }
}
