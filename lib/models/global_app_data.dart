import 'package:flutter/material.dart';
import 'package:photogenerator/models/home_navigation_state.dart';

class GlobalAppData extends ChangeNotifier {
  HomeNavigationState _homeNavigationState = HomeNavigationState.models;
  HomeNavigationState get homeNavigationState => _homeNavigationState;

  void updateHomeNavigationState(HomeNavigationState state) {
    _homeNavigationState = state;
    notifyListeners();
  }
}