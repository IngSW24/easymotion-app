

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

const List<String> typeCourse = <String>['ACQUAGYM', 'CROSSFIT', 'PILATES', 'ZUMBA_FITNESS', 'POSTURAL_TRAINING', 'BODYWEIGHT_WORKOUT'];
const List<String> activeCourse = <String>['Attivo', 'Non attivo'];

const List<String> exampleCourses = <String>['Corso 1', 'Corso 2', 'Corso 3', 'Corso 4', 'Corso 5', 'Corso 6', 'Corso 7', 'Corso 8', 'Corso 9', 'Corso 10', 'Corso 11'];

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

  final controllerAdvancedSearch = TextEditingController(); //controller for searchbar in "Ricerca avanzata"


  Future<void> _selectStartDate() async{
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
    );

    setState(() {

      if(dateFilterEnd != null){

        if(dateFilterEnd!.isAfter(pickedDate!)){
          dateFilterStart = pickedDate;
        }

      }else{
        dateFilterStart = pickedDate;
      }

    });
  }

  Future<void> _selectEndDate() async{
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    setState(() {

      if(dateFilterStart != null){

        if(dateFilterStart!.isBefore(pickedDate!)){
          dateFilterEnd = pickedDate;
        }

      }else{
        dateFilterEnd = pickedDate;
      }

    });
  }

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
                  showAdvancedSearch = !showAdvancedSearch;
                });
              }

          ),


          Offstage(   //Ho usato "Offstage" invece di "Visibility", perchè la seconda lascia lo SPAZIO BIANCO (rende invisibile l'oggetto, ma continua ad occupare spazio), mentre la prima NO (Sparisce senza occupare spazio bianco)
            offstage: showAdvancedSearch,
            child:
                  Column(

                    children: [

                      Row(
                        children: [
                          Text("Nome corso: "),


                        ]
                      ),

                      Row(
                        children: [

                          Text("Tipo di corso: "),

                          Card(
                            child: DropdownButton(
                              value: dropDownTypeCourseValue,
                              icon: const Icon(Icons.arrow_downward),

                              onChanged: (String? value){
                                  setState(() {
                                    dropDownTypeCourseValue = value!;
                                  });
                                },
                              items:
                                typeCourse.map<DropdownMenuItem<String>>((String value){
                                  return DropdownMenuItem<String>(value: value, child: Text(value));
                                }).toList(),

                            ),
                          ),


                        ],
                      ),

                      Row(
                        children: [

                          Text("Stato del corso: "),

                          Card(

                            child: DropdownButton(
                                    value: dropDownActiveValue,
                                    icon: const Icon(Icons.arrow_downward),

                                    onChanged: (String? value){
                                      setState(() {
                                        dropDownActiveValue = value!;
                                      });
                                    },
                                    items:
                                    activeCourse.map<DropdownMenuItem<String>>((String value){
                                      return DropdownMenuItem<String>(value: value, child: Text(value));
                                    }).toList(),

                                  ),
                          ),


                        ],
                      ),

                      Row(
                        children: [
                          Text("Da: "),
                          OutlinedButton( onPressed: _selectStartDate,
                                          child: (dateFilterStart == null) ? Text("Seleziona la data") :
                                           Text("${dateFilterStart!.day}/${dateFilterStart!.month}/${dateFilterStart!.year}")
                          )
                        ],
                      ),

                      Row(
                        children: [
                          Text("al: "),
                          OutlinedButton( onPressed: _selectEndDate,
                              child: (dateFilterEnd == null ) ? Text("Seleziona la data") : 
                               Text("${dateFilterEnd!.day}/${dateFilterEnd!.month}/${dateFilterEnd!.year}" )
                          )
                        ],
                      ),


                      ElevatedButton(
                          child: const Text('Applica filtro'),
                          onPressed: () {
                          }

                      ),



                    ],
                  ),


          ),

          Divider(),

          Column(
            children: (exampleCourses.isEmpty==true) ? [ Text('Nessun corso iscritto') ] : exampleCourses.map((i) => ListTile(
                                                                                                        title: Text(i.toString()),
                                                                                                        subtitle: Text('Attivo',
                                                                                                                      style: TextStyle(
                                                                                                                          fontWeight: FontWeight.bold,
                                                                                                                          color: Colors.green
                                                                                                                      ),
                                                                                                        ),
                                                                                                        leading: Image.network('https://picsum.photos/250?image=9'),
                                                                                                        trailing: ElevatedButton(
                                                                                                            onPressed: () {
                                                                                                              //Mettere un Dialog con cui mostrare i dettagli del corso
                                                                                                            },
                                                                                                            child: const Text('Dettagli')),
                                                                                                      )).toList()
          ),



        ],

      ),

    );
  }

}