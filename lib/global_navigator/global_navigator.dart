library global_navigator;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photogenerator/global_localization/utils.dart';
import 'package:photogenerator/global_navigator/models/app_bottom_modal.dart';
import 'package:photogenerator/global_navigator/models/app_route.dart';
import 'package:photogenerator/global_navigator/widgets/no_animation_material_page_route.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:statusbarz/statusbarz.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

export 'package:navigation_history_observer/navigation_history_observer.dart';

class GlobalNavigator {
  // singeton constructor
  GlobalNavigator._privateConstructor();
  static final GlobalNavigator _instance =
      GlobalNavigator._privateConstructor();
  factory GlobalNavigator() {
    return _instance;
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final NavigationHistoryObserver _historyObserver =
      NavigationHistoryObserver();

  NavigationHistoryObserver get historyObserver => _historyObserver;
  List<Route<dynamic>> get history =>
      List<Route<dynamic>>.from(_historyObserver.history);

  BuildContext get currentContext => navigatorKey.currentContext != null
      ? navigatorKey.currentContext!
      : throw "Trying to get current context but is null";

  bool get hasContext => navigatorKey.currentContext != null;

  List<AppRoute> _appRoutes = [];
  List<AppRoute> get routes => _appRoutes;
  List<AppBottomModal> _appBottomModals = [];
  List<AppBottomModal> get bottomModals => _appBottomModals;

  int get historyLength => _historyObserver.history.where((p) {
        return p.runtimeType is DialogRoute ||
            p is CupertinoDialogRoute ||
            p is ModalSheetRoute ||
            p.settings.name != null;
      }).length;

  bool canPop() =>
      historyLength > 1 &&
      _historyObserver.history[historyLength - 2].settings.name !=
          "/EmptyRoute";

  void setStatusBarTheme() {
    Statusbarz.instance.setTheme(StatusbarzTheme(
      darkStatusBar: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white.withOpacity(0.01),
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white.withOpacity(0.01),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      lightStatusBar: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black.withOpacity(0.01),
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.black.withOpacity(0.01),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    ));
  }

  void setAppRoutes(List<AppRoute> appRoutes) {
    _appRoutes = [...appRoutes];
  }

  void setAppBottomModals(List<AppBottomModal> appBottomModals) {
    _appBottomModals = [...appBottomModals];
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Map<String, dynamic> args = settings.arguments == null
        ? {}
        : settings.arguments as Map<String, dynamic>;
    Widget? currentBlocProvider;
    Locale currentLocale = getGlobalLocale(currentContext);
    return NoAnimationMaterialPageRoute(
      settings: settings,
      builder: (context) {
        if (currentBlocProvider != null &&
            currentLocale == getGlobalLocale(currentContext)) {
          return currentBlocProvider!;
        }

        currentLocale = getGlobalLocale(currentContext);
        AppRoute appRoute = _getAppRouteByName(settings.name!)!;
        currentBlocProvider = appRoute.getBlocProvider(args);

        return currentBlocProvider!;
      },
    );
  }

  Future<void> _waitCurrentStateValue() async {
    while (navigatorKey.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<dynamic> navigate(
    String name, {
    Map<String, dynamic> args = const {},
    Function(dynamic)? callback,
    Future<bool> Function()? authMethod,
  }) async {
    await _waitCurrentStateValue();
    await removeAllFocus();
    AppRoute? appRoute = _getAppRouteByName(name);
    AppBottomModal? appBottomModal = _getAppBottomModalByName(name);
    if (appRoute == null && appBottomModal == null) {
      if (kDebugMode) print("Route $name not found");
      return;
    }
    if (authMethod != null && !(await authMethod())) return;

    if (appRoute != null) return appRoute.pushPage(callback, args);
    if (appBottomModal != null) return appBottomModal.pushPage(callback, args);
  }

  Future<dynamic> pop([
    Map<String, dynamic> args = const {},
  ]) async {
    await _waitCurrentStateValue();
    await removeAllFocus();
    if (!canPop()) return;
    if (_historyObserver.history.last.settings.name == "/flushbarRoute") {
      navigatorKey.currentState!.pop();
    }
    return navigatorKey.currentState!.pop(args);
  }

  Future<dynamic> popWithRemoval([
    List<String> additionalPagesPop = const [],
  ]) async {
    await pop();
    return navigatorKey.currentState!.popUntil((route) {
      return route.isFirst || !additionalPagesPop.contains(route.settings.name);
    });
  }

  Future<dynamic> popUntil(String name) async {
    await removeAllFocus();
    if (!canPop()) return;
    AppRoute? appRoute = _getAppRouteByName(name);
    if (appRoute == null) return;
    return navigatorKey.currentState!.popUntil(
        (route) => route.isFirst || route.settings.name == appRoute.name);
  }

  AppRoute? _getAppRouteByName(String name) {
    int index = _appRoutes.indexWhere((r) => r.name == name);
    if (index == -1) return null;
    return _appRoutes[index];
  }

  AppRoute? _getAppRouteByRouteSettings(RouteSettings settings) {
    if (settings.name == null) return null;
    return _getAppRouteByName(settings.name!);
  }

  AppBottomModal? _getAppBottomModalByName(String name) {
    int index = _appBottomModals.indexWhere((r) => r.name == name);
    if (index == -1) return null;
    return _appBottomModals[index];
  }

  AppBottomModal? _getAppBottomModalByRouteSettings(RouteSettings settings) {
    if (settings.name == null) return null;
    return _getAppBottomModalByName(settings.name!);
  }

  bool isLastHistoryElementAppRoute() {
    if (_historyObserver.history.isEmpty) return false;
    Route<dynamic> lastElement = _historyObserver.history.last;
    if (lastElement is! MaterialPageRoute) return false;
    AppRoute? appRoute = _getAppRouteByRouteSettings(lastElement.settings);
    if (appRoute == null) return false;
    return true;
  }

  AppRoute? getLastAppRouteInHistory() {
    for (dynamic e in _historyObserver.history.reversed) {
      if (e is MaterialPageRoute) {
        AppRoute? appRoute = _getAppRouteByRouteSettings(e.settings);
        if (appRoute != null) return appRoute;
      }
    }
    return null;
  }

  Future<void> restoreHistory(List<Route<dynamic>> history) async {
    for (Route<dynamic> route in history) {
      if (route.settings.name == null) continue;
      AppRoute? _appRoute = _getAppRouteByName(route.settings.name!);
      if (_appRoute == null) continue;
      Map<String, dynamic> args = route.settings.arguments != null
          ? route.settings.arguments! as Map<String, dynamic>
          : {};
      await navigate(
        route.settings.name!,
        args: args,
      );
    }
  }

  Future<void> removeAllFocus() async {
    if (!hasContext) return;
    FocusScopeNode currentScope = FocusScope.of(currentContext);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  bool? isLightTheme;

  void setHistoryChangeStream({
    required Function(String?) changeCallback,
  }) {
    _historyObserver.historyChangeStream.listen((event) {
      if (event is HistoryChange &&
          event.oldRoute != null &&
          event.newRoute != null) {
        AppRoute? currentRoute;
        AppBottomModal? currentModal;
        if (event.action == NavigationStackAction.push) {
          currentRoute = _getAppRouteByRouteSettings(event.newRoute!.settings);
          currentModal =
              _getAppBottomModalByRouteSettings(event.newRoute!.settings);
        }
        if (event.action == NavigationStackAction.pop) {
          currentRoute = _getAppRouteByRouteSettings(event.oldRoute!.settings);
          currentModal =
              _getAppBottomModalByRouteSettings(event.oldRoute!.settings);
        }

        if (currentRoute != null) {
          changeCallback(currentRoute.dataSharingName);
        }
        if (currentModal != null) {
          changeCallback(currentModal.dataSharingName);
        }

        if (currentRoute != null) {
          if (currentRoute.forcedLightStatusBar && isLightTheme != true) {
            isLightTheme = true;
            Statusbarz.instance.setLightStatusBar();
          }
          if (!currentRoute.forcedLightStatusBar && isLightTheme != false) {
            isLightTheme = false;
            Statusbarz.instance.setDarkStatusBar();
          }
        }
      }
    });
  }
}
