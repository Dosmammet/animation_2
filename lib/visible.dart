import 'package:flutter/material.dart';

class Visible with ChangeNotifier {
  bool visible = true;

  setTrue() {
    visible = true;

    notifyListeners();
  }

  setFalse() {
    visible = false;

    notifyListeners();
  }
}
