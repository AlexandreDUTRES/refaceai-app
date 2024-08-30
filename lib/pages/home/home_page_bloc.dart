import 'package:flutter/material.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/functional/FcmHandler.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/models/global_app_data.dart';
import 'package:photogenerator/models/home_navigation_state.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';

class HomePageData {
  HomeNavigationState? navigationState;
}

class HomePageBloc extends Bloc<HomePageData> {
  late GlobalAppData _globalAppData;
  final PreloadPageController preloadPageController = PreloadPageController();
  List<HomeNavigationState> _navHistory = [HomeNavigationState.models];

  HomePageBloc(Map<String, dynamic> args) : super(HomePageData()) {
    _setNavigationListener();
    setNavigationState(_globalAppData.homeNavigationState);
  }

  bool get canPop => _navHistory.length == 1;

  Future<void> afterFirstBuild() async {
    await super.singleExecutionTask('after_build', () async {
      await FcmHandler.interactWithInitialMessage();
    });
  }

  @override
  void dispose() {
    _globalAppData.removeListener(_listener);
    super.dispose();
  }

  void _setNavigationListener() {
    _globalAppData = GlobalNavigator().currentContext.read<GlobalAppData>();
    _globalAppData.addListener(_listener);
  }

  void _listener() {
    goToNavigationState(_globalAppData.homeNavigationState, false);
  }

  void onPopInvoked(bool didPop) {
    if (didPop) return;
    goToNavigationState(_navHistory[_navHistory.length - 2]);
  }

  void setNavigationState(HomeNavigationState state) {
    if (state == blocData.navigationState) return;
    blocData.navigationState = state;
    _addToNavHistory(state);
    updateUI();
  }

  void goToNavigationState(HomeNavigationState state, [bool animate = true]) {
    int index = HomeNavigationState.values.indexOf(state);
    if (!animate)
      preloadPageController.jumpToPage(index);
    else
      preloadPageController.animateToPage(
        index,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    setNavigationState(state);
  }

  void _addToNavHistory(HomeNavigationState state) {
    int index = _navHistory.indexWhere((e) => e == state);
    if (index == -1) {
      _navHistory.add(state);
    } else {
      _navHistory = _navHistory.sublist(0, index);
      _navHistory.add(state);
    }
  }
}
