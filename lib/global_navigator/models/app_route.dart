library app_route;

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';

export 'package:page_transition/src/enum.dart';

class AppRoute<B extends Bloc> {
  final String name;
  final String? dataSharingName;
  final bool disableScreenCaptureAndRecording;
  final bool disableOverlayAlerts;
  final bool forcedLightStatusBar;
  final PageTransitionType? pageTransitionType;
  final void Function(AppRoute, Function?, Map<String, dynamic>) pushFunction;
  final B Function(Map<String, dynamic>) createBloc;
  final Widget Function(Map<String, dynamic>) createChild;

  AppRoute({
    required this.name,
    required this.dataSharingName,
    this.disableScreenCaptureAndRecording = false,
    this.disableOverlayAlerts = false,
    this.forcedLightStatusBar = false,
    required this.pushFunction,
    required this.createBloc,
    required this.createChild,
    required this.pageTransitionType,
  });

  void pushPage(
    Function? callback,
    Map<String, dynamic> args,
  ) {
    pushFunction(this, callback, args);
  }

  Widget getBlocProvider(Map<String, dynamic> args) {
    return BlocProvider<B>(
      bloc: createBloc(args),
      child: createChild(args),
    );
  }

  @override
  String toString() {
    return {
      "name": name,
      "dataSharingName": dataSharingName,
      "disableScreenCaptureAndRecording": disableScreenCaptureAndRecording,
      "disableOverlayAlerts": disableOverlayAlerts,
    }.toString();
  }
}
