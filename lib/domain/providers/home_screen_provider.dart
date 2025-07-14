import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier {
  factory HomeScreenProvider.instance() {
    return _internal;
  }

  HomeScreenProvider.internal();

  static final HomeScreenProvider _internal = HomeScreenProvider.internal();

  int currentIndex = 0;

  void incrementIndex(int idx) {
    currentIndex = idx;
    notifyListeners();
  }
}
