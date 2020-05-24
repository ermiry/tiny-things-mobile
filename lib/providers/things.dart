import 'package:flutter/foundation.dart';

class Category {

  final String id;

  final String title;
  final String description;

  List <Thing> _things = [];
  List <Thing> get things { return [...this._things]; }

  Category ({
    @required this.id,

    @required this.title,
    @required this.description,
  });

}

class Thing {

  final String id;

  final String title;
  final String description;

  // Things status:
  // 0 -> todo
  // 1 -> in progress
  // 2 -> done
  final int status;

  final DateTime date;

  Thing ({
    @required this.id,

    @required this.title,
    @required this.description,
    @required this.status,

    @required this.date
  });

}

class Things with ChangeNotifier {

  List <Category> _categories = [
    new Category(id: '1', title: 'All', description: 'All'),
    new Category(id: '2', title: 'Home', description: 'Home')
  ];

  List <Category> get categories { return [..._categories]; }

  int _selectedCategoryIdx = 0;

  // int get doors => _doors;
  // set doors(int numberOfDoors) {
  //   if(numberOfDoors >= 2 && numberOfDoors <= 6) {
  //     _doors = numberOfDoors;
  //   }
  // }

  int get selectedCategoryIdx => this._selectedCategoryIdx;

  set selectedCategoryIdx(int idx) {
    this._selectedCategoryIdx = idx;
    notifyListeners();
  }

  // new Thing (id: '1', title: 'This is a test tilte', description: 'This is a test description', status: 0, date: DateTime.now()),
  // new Thing (id: '2', title: 'This is a test tilte', description: 'This is a test description', status: 0, date: DateTime.now()),
  // new Thing (id: '3', title: 'This is a test tilte', description: 'This is a test description', status: 0, date: DateTime.now())

  // void addThing(String title, String description) {
  //   // this._things.add(new Thing (id: DateTime.now().toString(), title:  title, description: description));
  //   // notifyListeners();
  // }

  // void removeThing(String id) {
  //   this._things.removeWhere((t) => t.id == id);
  //   notifyListeners();
  // }

}