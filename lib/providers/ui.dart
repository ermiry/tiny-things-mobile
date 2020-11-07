import 'package:flutter/widgets.dart';

class UI with ChangeNotifier {

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double yScaleFactor = 1;

  bool isDrawerOpen = false;

  String _currentScreen = 'Home';
  String get currentScreen { return this._currentScreen; }

  void openDrawer() {
    this.xOffset = 240;
    this.yOffset = 160;
    this.scaleFactor = 0.72;
    this.yScaleFactor = 0.64;
    this.isDrawerOpen = true;

    notifyListeners();
  }

  void closeDrawer() {
    this.xOffset = 0;
    this.yOffset = 0;
    this.scaleFactor = 1;
    this.yScaleFactor = 1;
    this.isDrawerOpen = false;

    notifyListeners();
  }

  void changeScreen(String value) {
    this._currentScreen = value;

    closeDrawer();
  }

}