import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Global with ChangeNotifier {

  // the first time the app was opened
  bool firstTime = true;

  Future <void> toggleFirstTime() async { 
    // this.firstTime = !this.firstTime;
    this.firstTime = false;

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', this.firstTime);

    notifyListeners(); 
  }

  Future <void> loadGlobal() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('first_time')) {
      this.firstTime = prefs.getBool('first_time');
    }

    notifyListeners();
  }

}