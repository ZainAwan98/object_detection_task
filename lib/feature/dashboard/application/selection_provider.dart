import 'package:flutter/material.dart';

class SelectionProvider extends ChangeNotifier {
  int? _selectedIndex;

  int? get selectedIndex => _selectedIndex;

  set selectedIndex(int? index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
