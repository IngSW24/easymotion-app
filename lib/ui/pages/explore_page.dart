import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/data/hooks/use_auth.dart';
import 'package:easymotion_app/data/hooks/use_categories.dart';
import 'package:easymotion_app/ui/components/courses/course_filter.type.dart';
import 'package:easymotion_app/ui/components/courses/course_list_view.dart';
import 'package:easymotion_app/ui/components/courses/course_filters.dart';
import 'package:easymotion_app/ui/components/utility/loading.dart';
import 'package:easymotion_app/ui/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../components/chip_list/horizontal_cancellable_filter_chip_list.dart';

class ExplorePage extends StatefulHookWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchText = "";
  List<String> _selectedCategories = [], _selectedLevels = [];

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
          title: Text("Esplora corsi",
              style: TextStyle(
                  color: Color(0xFF094D95), fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              //icon: ImageIcon(AssetImage('images/blankProfileImage.png')), // TODO: person icon?
              icon: Icon(Icons.person),
              onPressed: () => context.push("/profile"),
            ),
          ],
        ),
        body: categories == null
            ? LoadingIndicator()
            : SingleChildScrollView(
                child: Column(children: [
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
                                          label: findLabel(categories, key)
                                                  ?.name ??
                                              "-"))
                                      .toList() +
                                  _selectedLevels
                                      .map((key) => FilterChipItem(
                                          key: key,
                                          label:
                                              CourseFilter.levels[key] ?? "-"))
                                      .toList(),
                              onDeleted: (String s) {
                                setState(() {
                                  _selectedCategories.remove(s);
                                  _selectedLevels.remove(s);
                                });
                              },
                            ))),
                  Text("Suggeriti per te",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CourseListView(
                      courseFilterType: CourseFilterType(
                        searchText: _searchText,
                        categories: _selectedCategories,
                        levels: _selectedLevels,
                        //frequencies: _frequencies,
                        //availabilities: _availabilities
                      ),
                    ),
                  )
                ]),
              ));
  }
}
