import 'package:flutter/material.dart';

import 'package:things/models/thing.dart';
import 'package:things/models/label.dart';
import 'package:things/models/category.dart';

import 'package:pref_dessert/pref_dessert.dart';

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

  void updateCategory(Category category, 
    String title, String description) {
    try {
      if (category != null) {
        category.title = title;
        category.description = description;

        // save to local storage
        var repo = new FuturePreferencesRepository <Category> (new CategoryDesSer());
        repo.updateWhere((c) => c.id == category.id, category);

        notifyListeners();
      }
    }

    catch (error) {
      print(error);
      print('Failed to update label!');
    }
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

  void updateLabel(Label label, 
    String title, String description, Color color) {
    try {
      if (label != null) {
        label.title = title;
        label.description = description;
        label.color = color;

        // save to local storage
        var repo = new FuturePreferencesRepository <Label> (new LabelDesSer());
        repo.updateWhere((l) => l.id == label.id, label);

        notifyListeners();
      }
    }

    catch (error) {
      print(error);
      print('Failed to update label!');
    }
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

  Future <void> addThing(Category category, String title, String description, bool star) async {
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

      thing.star = star;

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

  void toggleThingStar(Thing thing) {
    try {
      if (thing != null) {
        thing.toggleStar();

        notifyListeners();
      }
    }

    catch (error) {
      print(error);
      print('Failed to toggle thing star!');
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