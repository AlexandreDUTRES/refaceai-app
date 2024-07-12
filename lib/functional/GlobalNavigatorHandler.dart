import 'package:photogenerator/constants/AppBottomModals.dart';
import 'package:photogenerator/constants/AppRoutes.dart';
import 'package:photogenerator/functional/AnalyticsHandler.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';

class GlobalNavigatorHandler {
  static void initialize() {
    GlobalNavigator().setStatusBarTheme();
    GlobalNavigator()
        .setHistoryChangeStream(changeCallback: _onNavigationChange);
    GlobalNavigator().setAppRoutes([...AppRoutes.routes]);
    GlobalNavigator().setAppBottomModals([...AppBottomModals.bottomModals]);
  }

  static String? _lastDataSharingName;
  static _onNavigationChange(String? dataSharingName) {
    if (dataSharingName == null || dataSharingName == _lastDataSharingName)
      return;
    _lastDataSharingName = dataSharingName;
    AnalyticsHandler.navigation(dataSharingName);
  }
}
