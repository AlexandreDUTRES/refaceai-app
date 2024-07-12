library loader_utils;

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/ui/widgets/loader.dart';

class GlobalLoader {
  static late Color _overlayColor;
  static late Color _loaderColor;
  static late double _size;

  static GlobalLoaderOverlay buildOverlay(
    Widget child, {
    required Color overlayColor,
    required Color loaderColor,
    required double size,
  }) {
    _overlayColor = overlayColor;
    _loaderColor = loaderColor;
    _size = size;
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayColor: _overlayColor,
      child: child,
    );
  }

  static Widget _buildLoader(_) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Loader(
            color: _loaderColor,
            size: _size,
          ),
        ],
      ),
    );
  }

  static Future<void> showOverlayLoader([int awaitDurationInMs = 50]) async {
    GlobalNavigator()
        .currentContext
        .loaderOverlay
        .show(widgetBuilder: _buildLoader);
    await Future.delayed(Duration(milliseconds: awaitDurationInMs));
  }

  static void hideOverlayLoader() {
    GlobalNavigator().currentContext.loaderOverlay.hide();
  }

  static bool _isLoadingPageOpened = false;
  static Future<void> showLoadingPage([int awaitDurationInMs = 50]) async {
    if (_isLoadingPageOpened) return;    
    GlobalNavigator().navigate("/LoadingPage");
    await Future.delayed(Duration(milliseconds: awaitDurationInMs));
    _isLoadingPageOpened = true;
  }

  static Future<void> hideLoadingPage([int awaitDurationInMs = 50]) async {
    if (!_isLoadingPageOpened) return;
    await GlobalNavigator().pop();
    await Future.delayed(Duration(milliseconds: awaitDurationInMs));
    _isLoadingPageOpened = false;
  }
}
