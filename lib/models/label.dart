import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:pref_dessert/pref_dessert.dart';

class Label {

  final String id;

  String title;
  String description;

  Color color;

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