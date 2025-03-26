import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import '../components/chip_list/horizontal_chips_list.dart';
import '../components/courses/course_filters.dart';

const List<String> typeCourse = <String>[
  'ACQUAGYM',
  'CROSSFIT',
  'PILATES',
  'ZUMBA_FITNESS',
  'POSTURAL_TRAINING',
  'BODYWEIGHT_WORKOUT'
];
const List<String> activeCourse = <String>['Attivo', 'Non attivo'];

const List<String> exampleCourses = <String>[
  'Corso 1',
  'Corso 2',
  'Corso 3',
  'Corso 4',
  'Corso 5',
  'Corso 6',
  'Corso 7',
  'Corso 8',
  'Corso 9',
  'Corso 10',
  'Corso 11'
];

class MyCoursesPage extends StatefulWidget {
  @override
  State<MyCoursesPage> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyCoursesPage> {
  String dropDownTypeCourseValue = typeCourse.first;
  String dropDownActiveValue = activeCourse.first;

  bool showAdvancedSearch = true;

  DateTime? dateFilterStart;
  DateTime? dateFilterEnd;

  final controllerAdvancedSearch =
      TextEditingController(); //controller for searchbar in "Ricerca avanzata"

  Future<void> _selectStartDate() async {
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
  }



  ///CODICE PER I FILTRI
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
  ///FINE CODICE PER FILTRI














  @override
  Widget build(BuildContext context) {
    double width50 = MediaQuery.of(context).size.width * 0.50;

    return Scaffold(
      appBar: AppBar(
        title: Text("Corsi a cui ti sei iscritto"),
        backgroundColor: Colors.blue,
      ),

      //ListView = otteniamo una LISTA SCROLLABILE (cioè che basta trascinarla verso l'alto e il basso (con il dito) per scorrere gli elementi)
      body: ListView(
        //I vari componenti della LISTA "ListView" si chiamano "ListTile"
        children: [
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
                      onDeleted: (String tag) {
                        setState(() {
                          _categories.remove(tag);
                          _levels.remove(tag);
                          _frequencies.remove(tag);
                          _availabilities.remove(tag);
                        });
                      },
                    ))),

          Row(
            children: [
              Text("Da: "),
              OutlinedButton(
                  onPressed: _selectStartDate,
                  child: (dateFilterStart == null)
                      ? Text("Seleziona la data")
                      : Text(
                      "${dateFilterStart!.day}/${dateFilterStart!.month}/${dateFilterStart!.year}"))
            ],
          ),
          Row(
            children: [
              Text("al: "),
              OutlinedButton(
                  onPressed: _selectEndDate,
                  child: (dateFilterEnd == null)
                      ? Text("Seleziona la data")
                      : Text(
                      "${dateFilterEnd!.day}/${dateFilterEnd!.month}/${dateFilterEnd!.year}"))
            ],
          ),



          Divider(),
          Column(
              children: (exampleCourses.isEmpty == true)
                  ? ([Text('Nessun corso iscritto')])
                  : exampleCourses
                      .map((i) => ListTile(
                            title: Text(i.toString()),
                            leading: Image.network(
                                'https://picsum.photos/250?image=9'),
                            subtitle: ((identical('Non Attivo',
                                    'Attivo')) //Check if the course is Active or NOT
                                ? Text('Attivo',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green))
                                : Text('Terminato',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red))),
                            trailing: ElevatedButton(
                                onPressed: () => context.go(
                                    "details"), //If I click on the button "Dettagli" it open a Dialog window that shows the course details
                                child: const Text('Dettagli')),
                          ))
                      .toList()),
        ],
      ),
    );
  }

  //Function that create a Dialog that show the details of a course.

  Future<void> _courseDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Corso'),
            content: Column(
              children: [
                Row(
                  children: [
                    Text('Dettagli corso', textAlign: TextAlign.justify)
                  ],
                ),
                Row(
                  children: [
                    Text('\nData:', textAlign: TextAlign.justify),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Chiudi')),
            ],
          );
        });
  }
}
