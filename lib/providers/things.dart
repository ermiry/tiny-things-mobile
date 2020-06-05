import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:pref_dessert/pref_dessert.dart';

class Thing {

  final String id;

  String title;
  String description;

  // Things status:
  // 0 -> todo
  // 1 -> in progress
  // 2 -> done
  int status;

  // category's id - used for easier local storage
  final String category;

  List <Label> labels = [];
  // List <Label> get labels { return [...this._labels]; }

  // labels' ids
  List <String> loadedLabels;

  final DateTime date;

  Thing ({
    @required this.id,

    @required this.title,
    @required this.description,
    @required this.status,

    @required this.category,

    @required this.date
  });

  Thing.load({
    @required this.id,

    @required this.title,
    @required this.description,
    @required this.status,

    @required this.category,

    @required this.date,

    this.loadedLabels
  });

  void addLabel(Label label) {
    this.labels.add(label);
  }

  void removeLabel(String id) {
    this.labels.removeWhere((l) => l.id == id);
  }

  List <String> encodeLabels() {
    List <String> jsonLabels = [];
    for (var l in this.labels) {
      jsonLabels.add(l.id);
    }

    return jsonLabels;
  }

  factory Thing.fromJson(Map <String, dynamic> json) {
    return new Thing(
      id : json['id'] as String,
      title : json['title'] as String,
      description : json['description'] as String,
      status: json['color'] as int,
      category : json['category'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map <String, dynamic> toJson() => {
    'id': this.id,
    'title': this.title,
    'description': this.description,
    'status': this.status,
    'category': this.category,
    'date': this.date.toIso8601String(),
    'labels': this.encodeLabels()
  };

}

class ThingDesSer extends DesSer <Thing> {

  @override
  String get key => "PREF_TING";

  @override
  Thing deserialize(String s) {
    var map = json.decode(s);

    var labelsJson = jsonDecode(s)['labels'];
    List <String> labels = labelsJson != null ? List.from(labelsJson) : null;

    return new Thing.load(
      id: map['id'] as String,
      title: map['title'] as String, 
      description: map['description'] as String,
      status: map['status'] as int,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      loadedLabels: labels
    );
  }

  @override
  String serialize(Thing t) {
    return json.encode(t);
  }

}

class Label {

  final String id;

  final String title;
  final String description;

  final Color color;

  // category's id - used for easier local storage
  final String category;

  Label ({
    @required this.id,

    @required this.title,
    @required this.description,

    @required this.color,

    @required this.category
  });

  static Color _colorFromJson(String colorString) {
    String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    return new Color(int.parse(valueString, radix: 16));
  }

  factory Label.fromJson(Map <String, dynamic> json) {
    return new Label(
      id : json['id'],
      title : json['title'],
      description : json['description'],
      color : _colorFromJson(json['color']),
      category : json['category']
    );
  }

  Map <String, dynamic> toJson() => {
    'id': this.id,
    'title': this.title,
    'description': this.description,
    'color': this.color.toString(),
    'category': this.category
  };

}

class LabelDesSer extends DesSer <Label> {

  @override
  String get key => "PREF_LABEL";

  @override
  Label deserialize(String s) {
    var map = json.decode(s);
    return new Label(
      id: map['id'] as String,
      title: map['title'] as String, 
      description: map['description'] as String,
      color: Label._colorFromJson(map['color']),
      category: map['category']
    );
  }

  @override
  String serialize(Label l) {
    return json.encode(l);
  }

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

  void removeLabel(String id) {
    this._labels.removeWhere((l) => l.id == id);
  }

  void addThing(Thing thing) {
    this._things.add(thing);
  }

  void removeThing(String id) {
    this._things.removeWhere((t) => t.id == id);
  }

  List <Thing> todo() {
    List <Thing> retval = [];
    for (var t in this._things) {
      if (t.status == 0) {
        retval.add(t);
      }
    }

    return retval;
  }

  List <Thing> progress() {
    List <Thing> retval = [];
    for (var t in this._things) {
      if (t.status == 1) {
        retval.add(t);
      }
    }

    return retval;
  }

  List <Thing> done() {
    List <Thing> retval = [];
    for (var t in this._things) {
      if (t.status == 2) {
        retval.add(t);
      }
    }

    return retval;
  }

  Category.fromJson(Map <String, dynamic> json)
    : id = json['id'],
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

  // 04/06/2020 -- used to select labels for a new thing
  List <Label> selectedLabels = [];

  Future <void> addLabel(Category category, String title, String description, Color color) async {
    try {
      Category cat = this._categories.firstWhere((c) => c.title == category.title);

      Label label = new Label(
        id: DateTime.now().toString(),
        title: title, 
        description: description, 
        color: color,
        category: cat.id
      );

      cat.addLabel(label);

      // save to local storage
      var repo = new FuturePreferencesRepository <Label> (new LabelDesSer());
      await repo.save(label);
    }

    catch (error) {
      print('Failed to add label!');
    } 

    notifyListeners();
  }

  // FIXME: also remove from things
  void deleteLabel(Category cat, String id) {
    try {
      // remove from memory
      cat.removeLabel(id);

      // remove from local storage
      var repo = new FuturePreferencesRepository <Label> (new LabelDesSer());
      repo.removeWhere((l) => l.id == id);
    }

    catch (error) {
      print('Failed to delete label!');
    }

    notifyListeners();
  }

  int countLabelThings(Label label) {
    int count = 0;
    for (var t in this._categories[this._selectedCategoryIdx].things) {
      for (var l in t.labels) {
        if (l.id == label.id) {
          count += 1;
        }
      }
    }

    return count;
  }

  Future <void> loadLabels() async {
    try {
      var repo = new FuturePreferencesRepository <Label> (new LabelDesSer ());
      List <Label> labels = await repo.findAll();

      for (var l in labels) {
        for (var c in this._categories) {
          if (l.category == c.id) {
            c.addLabel(l);
          }
        }
      }
    }

    catch (error) {
      print('Failed to load labels from local storage!');
    }

    notifyListeners();
  }

  Future <void> addThing(Category category, String title, String description) async {
    try {
      Category cat = this._categories.firstWhere((c) => c.title == category.title);

      Thing thing = new Thing(
        id: DateTime.now().toString(),
        title: title, 
        description: description, 
        status: 0,      // todo
        category: cat.id, 
        date: DateTime.now()
      );

      // 04/06/2020 -- add the list of selected labels
      for (var l in this.selectedLabels) {
        thing.addLabel(
          new Label(
            id: l.id, 
            title: l.title, 
            description: l.description, 
            color: l.color, 
            category: l.description
          )
        );
      }

      this.selectedLabels = [];

      cat.addThing(thing);

      // save to local storage
      var repo = new FuturePreferencesRepository <Thing> (new ThingDesSer());
      await repo.save(thing);
    }

    catch (error) {
      print('Failed to save thing!');
    } 

    notifyListeners();
  }

  void setThingStatus(Thing thing, int status) {
    try {
      if (thing != null) {
        thing.status = status;

        // save to local storage
        var repo = new FuturePreferencesRepository <Thing> (new ThingDesSer());
        repo.updateWhere((t) => t.id == thing.id, thing);

        notifyListeners();
      }
    }

    catch (error) {
      print(error);
      print('Failed to set thing status!');
    }
  }

  void updateThing(Thing thing, String title, String description) {
    try {
      if (thing != null) {
        thing.title = title;
        thing.description = description;

        // save to local storage
        var repo = new FuturePreferencesRepository <Thing> (new ThingDesSer());
        repo.updateWhere((t) => t.id == thing.id, thing);

        notifyListeners();
      }
    }

    catch (error) {
      print(error);
      print('Failed to update thing!');
    }
  }

  void deleteThing(Category cat, String id) {
    try {
      // remove from memory
      cat.removeThing(id);

      // remove from local storage
      var repo = new FuturePreferencesRepository <Thing> (new ThingDesSer ());
      repo.removeWhere((t) => t.id == id);
    }

    catch (error) {
      print('Failed to delete thing!');
    }

    notifyListeners();
  }

  Future <void> loadThings() async {
    try {
      var repo = new FuturePreferencesRepository <Thing> (new ThingDesSer ());
      List <Thing> things = await repo.findAll();

      for (var t in things) {
        for (var c in this._categories) {
          if (t.category == c.id) {
            c.addThing(t);

            for (var l in t.loadedLabels) {
              for (var foundLabel in c.labels) {
                if (foundLabel.id == l) {
                  t.addLabel(
                    new Label(
                      id: foundLabel.id, 
                      title: foundLabel.title, 
                      description: foundLabel.description, 
                      color: foundLabel.color, 
                      category: null
                    )
                  );
                }
              }
            }
          }
        }
      }
    }

    catch (error) {
      print(error);
      print('Failed to load things from local storage!');
    }

    notifyListeners();
  }

}