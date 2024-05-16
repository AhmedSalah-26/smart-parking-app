import 'package:flutter/material.dart';

class ParkingProvider extends ChangeNotifier {
  bool allowBook = true;

  void setAllowBook(bool value) {
    allowBook = value;
    notifyListeners();
  }
}
