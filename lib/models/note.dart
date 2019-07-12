
class note{

  int _id;
  String _descr;
  String _date;
  String _title;
  int _priority;

  note(this._title,this._date,this._priority,[this._descr]);

  note.withId(this._id,this._title,this._date,this._priority,[this._descr]);

  int get id => _id;
  int get priority => _priority;
  String get descr => _descr;
  String get title => _title;
  String get date => _date;

  set title(String newTitle){
    if (newTitle.length <=255){
      this._descr = newTitle;
    }
  }
  set descr(String newDescr){
    if (newDescr.length <=255){
      this._descr = newDescr;
    }
  }

  set priority(int newPriority){
    if(newPriority>=1 && newPriority<=2 ){
      this._priority = newPriority;
    }
  }
  set date(String newDate){
    this._date = newDate;
  }
  // convert note obj to map obj
  Map<String,dynamic> toMap(){

    var map = Map<String, dynamic>();
    if(id!= null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['descr'] = _descr;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }
  //Extract map obj to  note obj
  note.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._descr = map['descr'];
    this._priority = map['priority'];
    this._date = map['date'];
  }

 }