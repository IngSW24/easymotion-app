

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

const List<String> _typeCourse = <String>['ACQUAGYM', 'CROSSFIT', 'PILATES', 'ZUMBA_FITNESS', 'POSTURAL_TRAINING', 'BODYWEIGHT_WORKOUT'];
const List<String> _activeCourse = <String>['Attivo', 'Non attivo'];

const List<String> _exampleCourses = <String>['Corso 1', 'Corso 2'];

class MyCoursesPage extends StatefulWidget {

  @override
  State<MyCoursesPage> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyCoursesPage> {

  String _dropDownTypeCourseValue = _typeCourse.first;
  String _dropDownActiveValue = _activeCourse.first;

  bool _showAdvancedSearch = true;

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

          SearchAnchor(
              builder: (BuildContext context, SearchController controller){
                return SearchBar(
                  controller: controller,

                  onTap: (){
                    controller.openView();
                  },

                  trailing: [
                    IconButton(
                        onPressed:() {},
                        icon: const Icon(Icons.search),

                    )
                  ],
                );
              },

              suggestionsBuilder: (BuildContext context, SearchController controller){
                return List<ListTile>.generate(5, (int index){
                  final String corso = 'corso $index';
                  return ListTile(
                    title: Text(corso),
                    onTap: () {
                      setState(() {
                        controller.closeView(corso);
                      });
                    },
                  );
                });
              }

          ),

          ElevatedButton(
              child: const Text('Ricerca avanzata'),
              onPressed: () {
                setState(() {
                  _showAdvancedSearch = !_showAdvancedSearch;
                });
              }

          ),


          Offstage(   //Ho usato "Offstage" invece di "Visibility", perchè la seconda lascia lo SPAZIO BIANCO (rende invisibile l'oggetto, ma continua ad occupare spazio), mentre la prima NO (Sparisce senza occupare spazio bianco)
            offstage: _showAdvancedSearch,
            child:
                  Column(

                    children: [

                      DropdownButton(
                        value: _dropDownTypeCourseValue,
                        icon: const Icon(Icons.arrow_downward),

                        onChanged: (String? value){
                          setState(() {
                            _dropDownTypeCourseValue = value!;
                          });
                        },
                        items:
                        _typeCourse.map<DropdownMenuItem<String>>((String value){
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),

                      ),

                      DropdownButton(
                        value: _dropDownActiveValue,
                        icon: const Icon(Icons.arrow_downward),

                        onChanged: (String? value){
                          setState(() {
                            _dropDownActiveValue = value!;
                          });
                        },
                        items:
                        _activeCourse.map<DropdownMenuItem<String>>((String value){
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),

                      ),

                    ],
                  ),


          ),

          Divider(),

          Column(
            children: (_exampleCourses.isEmpty==true) ? [ Text('Nessun corso iscritto') ] : _exampleCourses.map((i) => ListTile(
                                                                                                        title: Text(i.toString()),
                                                                                                        subtitle: Text('Attivo'),
                                                                                                        trailing: ElevatedButton(
                                                                                                            onPressed: () {},
                                                                                                            child: const Text('Dettagli')),
                                                                                                      )).toList()
          ),



          /*
          Card(
            child:ListTile(
              title: Text("Corso 3"),
              subtitle: Text("Attivo"),
              trailing: ElevatedButton(
                  onPressed: (){},
                  child: const Text('Dettagli')
              ),
            ),
          ),
          */


        ],

      ),

    );
  }

}