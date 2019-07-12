import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'dart:async';


class NodeDetails extends StatefulWidget {
  final String app_Bar;
  final note Note;

  NodeDetails(this.Note, this.app_Bar);

  @override
  State<StatefulWidget> createState() {
    return AddNodeDetails(this.Note, this.app_Bar);
  }
}

class AddNodeDetails extends State<NodeDetails> {
  static var _priority = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  String app_Bar;
  note Note;

  TextEditingController title_c = TextEditingController();
  TextEditingController descr_c = TextEditingController();

  AddNodeDetails(this.Note, this.app_Bar);

  @override
  Widget build(BuildContext context) {
    TextStyle textstyle = Theme.of(context).textTheme.title;

    title_c.text = Note.title;
    descr_c.text = Note.descr;

    return WillPopScope(
        onWillPop: () {
      // Write some code to control things, when user press Back navigation button in device navigationBar
      moveToLastScreen();
    },

    child: Scaffold(
        appBar: AppBar(
          title: Text(app_Bar),
          leading: IconButton(
              onPressed: (){moveToLastScreen();},
              icon: Icon(Icons.arrow_back),
              ),
        ),
        body: Padding(
          padding:
              EdgeInsets.only(top: 15.0, bottom: 10.0, right: 10.0, left: 10.0),
          child: ListView(
            children: <Widget>[
              //First Element
              ListTile(
                title: DropdownButton(
                    items: _priority.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style: textstyle,
                    value: updatePriorityAsString(Note.priority),
                    onChanged: (valueSelectedbyUser) {
                      setState(() {
                        debugPrint('Dp');
                        updatePriorityASInt(valueSelectedbyUser);
                      });
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: title_c,
                  style: textstyle,
                  onChanged: (titlevalue) {
                    debugPrint('Title');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textstyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descr_c,
                  style: textstyle,
                  onChanged: (titlevalue) {
                    debugPrint('Descr');
                    updateDescr();
                  },
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textstyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint('Save button');
                            _save();
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorLight,
                        textColor: Theme.of(context).primaryColorDark,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint('Delete button');
                            _delete();
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
    ));
  }

  void updatePriorityASInt(String value) {
    switch (value) {
      case 'High':
        Note.priority = 1;
        break;
      case 'low':
        Note.priority = 2;
        break;
    }
  }

  String updatePriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priority[0];
        break;
      case 2:
        priority = _priority[1];
        break;
    }
    return priority;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    Note.title = title_c.text;
  }

  void updateDescr() {
    Note.descr = descr_c.text;
  }

  void _save() async {

    moveToLastScreen();

    Note.date= DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (Note.id != null) {
      result = await helper.updatenote(Note);
    } else {
      result = await helper.insertnote(Note);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async{

    moveToLastScreen();
    if(Note.id == null){
      _showAlertDialog('Status', 'No Notes was deleted');
      return;
    }
    int result = await helper.deletenote(Note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting the Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }
}
