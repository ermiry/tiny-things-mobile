import 'package:flutter/foundation.dart';

class Thing {

  final String id;
  final String title;
  final String description;

  final DateTime date;

  Thing ({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.date
  });

}

final Map <String, int> categories = {
  'All': 112,
  'Work': 58,
  'Home': 23,
};

class Things with ChangeNotifier {

  List <Thing> _things = [
    new Thing (id: '1', title: 'This is a test tilte', description: 'This is a test description', date: DateTime.now()),
    new Thing (id: '2', title: 'This is a test tilte', description: 'This is a test description', date: DateTime.now()),
    new Thing (id: '3', title: 'This is a test tilte', description: 'This is a test description', date: DateTime.now())
  ];

  List <Thing> get things { return [..._things]; }

  void addThing(String title, String description) {
    // this._things.add(new Thing (id: DateTime.now().toString(), title:  title, description: description));
    // notifyListeners();
  }

  void removeThing(String id) {
    this._things.removeWhere((t) => t.id == id);
    notifyListeners();
  }

}