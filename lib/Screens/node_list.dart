import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_keeper/Screens/node_details.dart';

class NodeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NodeListState();
  }
}

class NodeListState extends State<NodeList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<note>();
      updateListview();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: getNotelistView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigator(note(' ', '', 2), 'Add note');
        },
        tooltip: 'Add Note',
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
  ListView getNotelistView() {
    TextStyle titlestyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(
                this.noteList[position].title,
                style: titlestyle,
              ),
              subtitle: Text(this.noteList[position].date),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  _delete(context, noteList[position]);
                },
              ),
              onTap: () {
                debugPrint('onClick');
                navigator(this.noteList[position],'Edit Note');
              }),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, note note) async {
    int result = await databaseHelper.deletenote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListview();
    }
  }

  void navigator(note note,String title) async{
     bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NodeDetails(note,title);
    }));

     if (result == true){
       updateListview();
     }
  }

  void _showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(
      content: Text(s),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListview() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
     Future<List<note>> noteListFuteure = databaseHelper.getNotelist();
     noteListFuteure.then((noteList){
       setState(() {
         this.noteList = noteList;
         this.count=noteList.length;
       });
     });

    });
  }
}
