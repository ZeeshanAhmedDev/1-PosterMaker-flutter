import 'package:flutter/material.dart';

class SwitchChanged extends ChangeNotifier {
   bool? val;
  SwitchChanged({this.val});


    void add(bool value) {
    val = value;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}