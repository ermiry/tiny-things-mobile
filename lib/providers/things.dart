import 'package:flutter/foundation.dart';

class Thing {

  final String id;

  final String title;
  final String description;

  // Things status:
  // 0 -> todo
  // 1 -> in progress
  // 2 -> done
  final int status;

  final String category;

  final DateTime date;

  Thing ({
    @required this.id,

    @required this.title,
    @required this.description,
    @required this.status,

    @required this.category,

    @required this.date
  });

}

class Label {

  final String id;

  final String title;
  final String description;

  Label ({
    @required this.id,

    @required this.title,
    @required this.description,
  });

}

class Category {

  final String id;

  final String title;
  final String description;

  List <Label> _labels = [];
  List <Label> get labels { return [...this._labels]; }

  List <Thing> _things = [];
  List <Thing> get things { return [...this._things]; }

  Category ({
    @required this.id,

    @required this.title,
    @required this.description,
  });

  void addLabel(Label label) {
    this._labels.add(label);
  }

  void addThing(Thing thing) {
    this._things.add(thing);
  }

}

class Things with ChangeNotifier {

  List <Category> _categories = [
    new Category(id: '1', title: 'All', description: 'All'),
    new Category(id: '2', title: 'Home', description: 'Home')
  ];

  List <Category> get categories { return [..._categories]; }

  int _selectedCategoryIdx = 0;

  int get selectedCategoryIdx => this._selectedCategoryIdx;

  set selectedCategoryIdx(int idx) {
    this._selectedCategoryIdx = idx;
    notifyListeners();
  }

  void addLabel(Category category, String title, String description) {
    Category cat = this._categories.firstWhere((c) => c.title == category.title);

    Label label = new Label(
      id: DateTime.now().toString(),
      title: title, 
      description: description, 
    );

    cat.addLabel(label);

    notifyListeners();
  }

  void addThing(Category category, String title, String description) {
    Category cat = this._categories.firstWhere((c) => c.title == category.title);

    Thing thing = new Thing(
      id: DateTime.now().toString(),
      title: title, 
      description: description, 
      status: 0,      // todo
      category: category.title, 
      date: DateTime.now()
    );

    cat.addThing(thing);

    notifyListeners();
  }

  void removeThing(String id) {
    // this._things.removeWhere((t) => t.id == id);
    // notifyListeners();
  }

}