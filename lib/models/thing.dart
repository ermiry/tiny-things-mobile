import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:things/models/label.dart';

import 'package:pref_dessert/pref_dessert.dart';

class Thing with ChangeNotifier {

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

  bool star = false;

  Thing.empty(
    this.id,
    this.category,
    this.date
  );

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

    this.loadedLabels,

    this.star
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

  void toggleStar() {
    try {
      this.star = !this.star;

      // save to local storage
      var repo = new FuturePreferencesRepository <Thing> (new ThingDesSer());
      repo.updateWhere((t) => t.id == this.id, this);

      notifyListeners();
    }

    catch (error) {
      print(error);
      print('Failed to star thing!');
    }
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
    'labels': this.encodeLabels(),
    'star': this.star
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
      loadedLabels: labels,
      star: map['star'] as bool
    );
  }

  @override
  String serialize(Thing t) {
    return json.encode(t);
  }

}