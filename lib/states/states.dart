import 'package:flutter/cupertino.dart';

class States with ChangeNotifier {
  bool newNotification = false;

  void changeNewNotification(bool value){
    newNotification = value;
    notifyListeners();
  }
}