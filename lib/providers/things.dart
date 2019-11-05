import 'package:flutter/foundation.dart';

class Thing {

  final String id;
  final String title;
  final String description;

  Thing ({
    @required this.id,
    @required this.title,
    @required this.description
  });

}

class Things with ChangeNotifier {

  List <Thing> _things = [
    new Thing (id: '1', title: 'This is a test tilte', description: 'This is a test description'),
    new Thing (id: '2', title: 'This is a test tilte', description: 'This is a test description'),
    new Thing (id: '3', title: 'This is a test tilte', description: 'This is a test description')
  ];

  List <Thing> get things { return [..._things]; }

  void removeThing(String id) {
    this._things.removeWhere((t) => t.id == id);
    notifyListeners();
  }

}