import 'package:flutter/material.dart';

/// Controller que gerencia o estado do Dashboard
class DashboardController extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isRailExpanded = true;
  bool _isEstrategiasExpanded = false;
  int _rebuildCounter = 0;

  int get selectedIndex => _selectedIndex;
  bool get isRailExpanded => _isRailExpanded;
  bool get isEstrategiasExpanded => _isEstrategiasExpanded;
  int get rebuildCounter => _rebuildCounter;

  void selectIndex(int index) {
    if (index == _selectedIndex) {
      _rebuildCounter++;
    } else {
      _selectedIndex = index;
    }
    notifyListeners();
  }

  void toggleRailExpanded() {
    _isRailExpanded = !_isRailExpanded;
    notifyListeners();
  }

  void toggleEstrategiasExpanded() {
    _isEstrategiasExpanded = !_isEstrategiasExpanded;
    notifyListeners();
  }

  Key getScreenKey(String prefix) => Key('${prefix}_$_rebuildCounter');
}