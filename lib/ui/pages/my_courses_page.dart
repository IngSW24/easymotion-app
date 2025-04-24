import 'package:easymotion_app/ui/components/chip_list/horizontal_cancellable_filter_chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../api-client-generated/api_schema.models.swagger.dart';
import '../../data/hooks/use_auth.dart';
import '../../data/hooks/use_categories.dart';
import '../components/courses/course_filter.type.dart';
import '../components/courses/course_filters.dart';
import '../components/courses/my_courses_list_view.dart';
import '../components/utility/loading.dart';
import 'loading_page.dart';

class MyCoursesPage extends StatefulHookWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyCoursesPage> {
  ///CODICE PER I FILTRI
  String _searchText = "";
  List<String> _selectedCategories = [], _selectedLevels = [];

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
            selectedCategories: _selectedCategories,
            selectedLevels: _selectedLevels,
            onCategoriesChanged: (List<String> value) {
              setModalState(() {
                setState(() {
                  _selectedCategories = value;
                });
              });
            },
            onLevelsChanged: (List<String> value) {
              setModalState(() {
                setState(() {
                  _selectedLevels = value;
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

  CourseCategoryDto? findLabel(List<CourseCategoryDto> categories, String key) {
    for (final cat in categories) {
      if (cat.id == key) return cat;
    }
    return null;
  }

  ///FINE CODICE PER FILTRI

  @override
  Widget build(BuildContext context) {
    final user = useUserInfo(context).call();
    final userIsLoading = useIsLoading(context).call();
    final categories = useCategories(context).data;

    if (user == null) {
      if (!userIsLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');
        });
      }
      return LoadingPage();
    }

    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Welcome back"),
              Text(user.firstName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),

          /*title: Text(user != null
              ? "I tuoi corsi, ${user.firstName}"
              : 'I tuoi corsi'),*/

          backgroundColor: Color(0xFF094D95),
          titleTextStyle: TextStyle(color: Color(0xFFFDFDFD)),
          toolbarTextStyle: TextStyle(color: Color(0xFFFDFDFD)),
          actions: [
            IconButton(
              //icon: ImageIcon(AssetImage('images/blankProfileImage.png')), // TODO: person icon?
              icon: Icon(Icons.person),
              onPressed: () => context.push("/profile"),
            ),
          ],
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),*/
        body: categories == null
            ? LoadingIndicator()
            : Column(children: [
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
                if (_selectedCategories.isNotEmpty ||
                    _selectedLevels.isNotEmpty)
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: SizedBox(
                          height: 40,
                          child: HorizontalCancellableFilterChipList(
                            maxWidth: 320,
                            items: _selectedCategories
                                    .map((key) => FilterChipItem(
                                        key: key,
                                        label:
                                            findLabel(categories, key)?.name ??
                                                "-"))
                                    .toList() +
                                _selectedLevels
                                    .map((key) => FilterChipItem(
                                        key: key,
                                        label: CourseFilter.levels[key] ?? "-"))
                                    .toList(),
                            onDeleted: (String s) {
                              setState(() {
                                _selectedCategories.remove(s);
                                _selectedLevels.remove(s);
                              });
                            },
                          ))),
                Text("I tuoi corsi attivi",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Expanded(
                    child: MyCoursesListView(
                  courseFilterType: CourseFilterType(
                    searchText: _searchText,
                    categories: _selectedCategories,
                    levels: _selectedLevels,
                    //frequencies: _frequencies,
                    //availabilities: _availabilities
                  ),
                ))
              ]));
  }
}
