import 'package:flutter/foundation.dart';

class Thing {

  final String id;
  final String thing;

  Thing ({
    @required this.id,
    @required this.thing
  });

}

class Things with ChangeNotifier {

  List <Thing> _things = [];

  List <Thing> get things { return [..._things]; }

}