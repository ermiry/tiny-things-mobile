import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:pref_dessert/pref_dessert.dart';

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

  final Color color;

  Label ({
    @required this.id,

    @required this.title,
    @required this.description,

    @required this.color,
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

  Category.fromJson(Map <String, dynamic> json)
    : id = json['name'],
      title = json['title'],
      description = json['description'];

  Map <String, dynamic> toJson() => {
    'id': this.id,
    'title': this.title,
    'description': this.description,
  };

}

class CategoryDesSer extends DesSer <Category> {

  @override
  String get key => "PREF_CATEGORY";

  @override
  Category deserialize(String s) {
    var map = json.decode(s);
    return new Category(
      id: map['id'] as String,
      title: map['title'] as String, 
      description: map['description'] as String,
    );
  }

  @override
  String serialize(Category c) {
    return json.encode(c);
  }

}

class Things with ChangeNotifier {

  List <Category> _categories = [
    // new Category(id: '1', title: 'All', description: 'All'),
    // new Category(id: '2', title: 'Home', description: 'Home')
  ];

  List <Category> get categories { return [..._categories]; }

  int _selectedCategoryIdx = 0;

  int get selectedCategoryIdx => this._selectedCategoryIdx;

  set selectedCategoryIdx(int idx) {
    this._selectedCategoryIdx = idx;
    notifyListeners();
  }

  Future <void> addCategory(String title, String description) async {
    Category cat = new Category(
      id: DateTime.now().toString(),
      title: title, 
      description: description
    );

    this._categories.add(cat);

    // save to local storage
    var repo = new FuturePreferencesRepository <Category> (new CategoryDesSer());
    await repo.save(cat);

    notifyListeners();
  }

  Future <void> loadCategories() async {
    try {
      var repo = new FuturePreferencesRepository <Category> (new CategoryDesSer ());
      this._categories = await repo.findAll();
    }

    catch (error) {
      print('Failed to load categories from local storage!');
    }

    notifyListeners();
  }

  void addLabel(Category category, String title, String description, Color color) {
    Category cat = this._categories.firstWhere((c) => c.title == category.title);

    Label label = new Label(
      id: DateTime.now().toString(),
      title: title, 
      description: description, 
      color: color
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