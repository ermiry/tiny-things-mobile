import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier {

  bool enableCloud = true;

  bool centerAddButton = false;

  Future <void> toggleCenterAddButton() async { 
    this.centerAddButton = !this.centerAddButton;

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('center_add_button', this.centerAddButton);

    notifyListeners(); 
  }

  Future <void> loadSettings() async {

    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('center_add_button')) {
      this.centerAddButton = prefs.getBool('show_history_chart');
    }

    notifyListeners();

  }

}