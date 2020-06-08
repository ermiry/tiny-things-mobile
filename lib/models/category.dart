import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:things/models/thing.dart';
import 'package:things/models/label.dart';

import 'package:pref_dessert/pref_dessert.dart';

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

  List <Thing> important() {
    List <Thing> retval = [];
    for (var t in this._things) {
      if (t.status == 0 && t.star) {
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