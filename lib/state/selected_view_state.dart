import 'package:flutter/widgets.dart';
import 'package:sync_launcher/view/home_view.dart';

class SelectedViewState with ChangeNotifier {
  Widget view = HomeView();

  setView(Widget view) {
    this.view = view;
    notifyListeners();
  }
}