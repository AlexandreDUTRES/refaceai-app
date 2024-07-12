library main_app_widget_bloc;

import 'package:flutter/material.dart';
import 'package:photogenerator/bloc_utils/bloc_rx.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/global_navigator/utils.dart';

class MainAppWidgetBlocData {
  AppLifecycleState appLifecycleState = AppLifecycleState.resumed;
  UniqueKey layoutKey = UniqueKey();
}

class MainAppWidgetBloc extends BlocRx<MainAppWidgetBlocData> {
  static final MainAppWidgetBloc _bloc = MainAppWidgetBloc._internal();
  factory MainAppWidgetBloc() {
    if (_bloc.blocData == null || _bloc.streamController == null) {
      _bloc.initialize(MainAppWidgetBlocData());
    }

    return _bloc;
  }
  MainAppWidgetBloc._internal();

  AppLifecycleState get currentState => blocData!.appLifecycleState;

  Future<void> Function(bool)? _restartComputeFunction;

  bool hasBeenRestarted = false;
  List<Route<dynamic>>? _history;

  bool get canRestoreOldSession =>
      hasBeenRestarted && _history != null && _history!.isNotEmpty;

  void setRestartComputeFunction(Future<void> Function(bool) f) {
    _restartComputeFunction = f;
  }

  void setAppLifecycleState(AppLifecycleState state) {
    blocData!.appLifecycleState = state;
    updateUI();
  }

  void _updateLayoutKey() {
    blocData!.layoutKey = UniqueKey();
    updateUI();
  }

  Future<void> restoreOldNavigation() async {
    if (_history == null) return;
    await GlobalNavigator().restoreHistory(_history!);
    _history = null;
  }

  Future<void> restartApp({
    List<Route<dynamic>>? history,
    bool resetUniverseHandlerHasBeenRefreshed = true,
  }) async {
    await GlobalNavigator().removeAllFocus();
    hasBeenRestarted = true;
    _history = history;
    pushEmptyStartPageToGN(Colors.black);

    if (_restartComputeFunction != null) {
      await _restartComputeFunction!(resetUniverseHandlerHasBeenRefreshed);
    }

    _updateLayoutKey();
  }
}
