import 'package:flutter/foundation.dart';

class SelectedViewState with ChangeNotifier {
  int index = 0;

  setIndex(int index) {
    this.index = index;
    notifyListeners();
  }
}