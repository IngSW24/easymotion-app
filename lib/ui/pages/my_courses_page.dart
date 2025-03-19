

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatefulWidget {

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagina del profilo"),
        backgroundColor: Colors.blue,
      ),

      //ListView = otteniamo una LISTA SCROLLABILE (cioè che basta trascinarla verso l'alto e il basso (con il dito) per scorrere gli elementi)
      body: ListView(

        //I vari componenti della LISTA "ListView" si chiamano "ListTile"
        children: [

          Card(
            child: ListTile(
                title: Image.asset("images/blankProfileImage.png")
            ),

          ),

          Card(   //Card permette di rendere più bello graficamente l'elemento della lista (crea un riquadro con bordi smussati)
            child:ListTile(
                title: Text("Nome"),
                subtitle: Text("Marco"),
                trailing:  Icon(Icons.mode_edit)
            ),
          ),

          Card(   //Card permette di rendere più bello graficamente l'elemento della lista (crea un riquadro con bordi smussati)
            child:ListTile(
              title: Text("Cognome"),
              subtitle: Text("Polo"),
              trailing: Icon(Icons.mode_edit),    //trailing = Aggiungiamo a DESTRA qualcosa (in questo caso un'icona)
            ),
          ),



        ],

      ),

    );
  }

}