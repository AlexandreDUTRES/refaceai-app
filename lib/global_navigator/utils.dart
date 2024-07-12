library utils;

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photogenerator/global_navigator/models/app_bottom_modal.dart';
import 'package:photogenerator/global_navigator/models/app_route.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/global_navigator/widgets/no_animation_material_page_route.dart';

void pushEmptyStartPageToGN(Color backgroundColor) {
  GlobalNavigator().navigatorKey.currentState!.pushAndRemoveUntil(
        NoAnimationMaterialPageRoute(
          builder: (context) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: backgroundColor,
            );
          },
          settings: const RouteSettings(name: "/EmptyRoute"),
        ),
        (Route<dynamic> route) => false,
      );
}

void pushReplacementToGN(
  String name,
  Function? callback,
  Map<String, dynamic> args,
) {
  // // avoid duplicate page
  // AppRoute? lastAppRoute = GlobalNavigator().getLastAppRouteInHistory();
  // if (lastAppRoute != null && name == lastAppRoute.name) return;

  GlobalNavigator()
      .navigatorKey
      .currentState!
      .pushReplacementNamed(name, arguments: args)
      .then((value) => callback != null ? callback(value) : null);
}

void pushToGN(
  AppRoute appRoute,
  Function? callback,
  Map<String, dynamic> args,
) {
  // // avoid duplicate page
  // AppRoute? lastAppRoute = GlobalNavigator().getLastAppRouteInHistory();
  // if (lastAppRoute != null && appRoute.name == lastAppRoute.name) return;

  GlobalNavigator()
      .navigatorKey
      .currentState!
      .pushNamed(appRoute.name, arguments: args)
      .then((value) => callback != null ? callback(value) : null);
}

void pushAndRemoveUntilToGN(
  AppRoute appRoute,
  Function? callback,
  Map<String, dynamic> args,
) {
  // // avoid duplicate page
  // AppRoute? lastAppRoute = GlobalNavigator().getLastAppRouteInHistory();
  // if (lastAppRoute != null && appRoute.name == lastAppRoute.name) return;

  GlobalNavigator()
      .navigatorKey
      .currentState!
      .pushNamedAndRemoveUntil(appRoute.name, (Route<dynamic> route) {
    return false;
  }, arguments: args).then(
          (value) => callback != null ? callback(value) : null);
}

void openModalBottomSheet(
  AppBottomModal appBottomModal,
  Function? callback,
  Map<String, dynamic> args,
) {
  Widget child = SafeArea(
    child: PopScope(
      canPop: !appBottomModal.unskipable,
      child: appBottomModal.getBlocProvider(args),
    ),
  );
  showMaterialModalBottomSheet(
    settings: RouteSettings(name: appBottomModal.name),
    context: GlobalNavigator().currentContext,
    isDismissible: !appBottomModal.unskipable,
    enableDrag: !appBottomModal.unskipable,
    backgroundColor: Colors.transparent,
    builder: (_) => child,
  ).then((value) => callback != null ? callback(value) : null);
}
