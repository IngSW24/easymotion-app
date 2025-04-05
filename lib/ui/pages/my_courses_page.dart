import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/hooks/use_auth.dart';
import '../components/chip_list/horizontal_chips_list.dart';
import '../components/courses/course_filter.type.dart';
import '../components/courses/course_filters.dart';
import '../components/courses/my_courses_list_view.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyCoursesPage> {
  ///CODICE PER I FILTRI
  String _searchText = "";
  List<String> _categories = [],
      _levels = [],
      _frequencies = [],
      _availabilities = [];

  //String dropDownTypeCourseValue = typeCourse.first;
  //String dropDownActiveValue = activeCourse.first;

  //bool showAdvancedSearch = true;

  DateTime? dateFilterStart;
  DateTime? dateFilterEnd;

  final controllerAdvancedSearch =
      TextEditingController(); //controller for searchbar in "Ricerca avanzata"

  /*Future<void> _selectStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: dateFilterEnd ?? DateTime(2100),
    );

    setState(() {
      dateFilterStart = pickedDate;
    });
  }

  Future<void> _selectEndDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: dateFilterStart ?? DateTime(2000),
      lastDate: DateTime(2100),
    );

    setState(() {
      dateFilterEnd = pickedDate;
    });
  }*/

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

  ///FINE CODICE PER FILTRI

  @override
  Widget build(BuildContext context) {
    final userInfo = useUserInfo(context);
    final logout = useLogoutFn(context);
    final user = userInfo();

    return Scaffold(
        appBar: AppBar(
          title: Text(user != null
              ? "I tuoi corsi, ${user.firstName}"
              : 'I tuoi corsi'),
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
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),*/
        body: Column(children: [
          Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cerca corsi (es. nuoto)",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
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
          if (user != null)
            Expanded(
                child: MyCoursesListView(
              courseFilterType: CourseFilterType(
                  searchText: _searchText,
                  categories: _categories,
                  levels: _levels,
                  frequencies: _frequencies,
                  availabilities: _availabilities),
            ))
          else
            Text("Accedi per vedere i tuoi corsi")
        ]));
  }
}
