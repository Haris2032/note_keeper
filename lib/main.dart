import 'package:flutter/material.dart';
import 'package:note_keeper/Screens/node_list.dart';
import 'package:note_keeper/Screens/node_details.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorLight:Colors.white ,
        primarySwatch: Colors.pink,
      ),
      home: NodeList(),
    );  }

}



