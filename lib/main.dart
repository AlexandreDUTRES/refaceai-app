import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:photogenerator/app_ui/loader_utils.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/app_ui/theme/theme_palette.dart';
import 'package:photogenerator/app_ui/theme_utils.dart';
import 'package:photogenerator/functional/PurchaseHandler.dart';
import 'package:photogenerator/functional/bloc_manager.dart';
import 'package:photogenerator/functional/GlobalNavigatorHandler.dart';
import 'package:photogenerator/Globals.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/global_navigator/widgets/main_app_widget.dart';
import 'package:photogenerator/models/global_app_data.dart';
import 'package:photogenerator/storage_utils/shared_preferences_storage.dart';
import 'package:photogenerator/ui/widgets/camera_view.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final BlocManager blocManager = BlocManager();

final ThemePalette _themePalette = ThemePalette(
  primaryColor: Color(0xff0882ff),
  secondaryColor: Color(0xff7c8292),
  textColor: Color(0xffffffff),
  borderColor: Color(0xff26272c),
  backgroundColor: Color(0xff000000),
  primaryGradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xff3399ff), Color(0xff0073e6)],
  ),
);

void main() async {
  runZonedGuarded(() async {
    // ensure initialized objects
    WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    await MobileAds.instance.initialize();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Globals.initializeLateVariables();

    // set device settings
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await CameraView.setCameras();

    // load locale assets
    await FlutterConfig.loadEnvVariables();

    // load locale assets
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());

    // initialize storage
    await SharedPreferencesStorage.initialize();

    // intialize navigation
    GlobalNavigatorHandler.initialize();

    runApp(
      ChangeNotifierProvider(
        create: (context) => GlobalAppData(),
        child: MainAppWidget(
          binding: binding,
          child: _buildAppWidget(),
          restartComputeFunction: (resetUniverseHandlerHasBeenRefreshed) async {
            print("restartComputeFunction");
            await PurchaseHandler.reset();
            await blocManager.disposeAllBlocs();
          },
        ),
      ),
    );
  }, (e, r) => print(e));
}

Widget _buildAppWidget() {
  return EasyLocalization(
    // package to manage lang
    useOnlyLangCode: true,
    supportedLocales: Globals.supportedLocales,
    path: 'assets/translations',
    fallbackLocale: Globals.supportedLocales[0],
    child: MainApp(),
    // assetLoader: CustomLangageLoader(),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _materialAppParent(
      context,
      (themeData) => MaterialApp(
        navigatorKey: GlobalNavigator().navigatorKey,
        navigatorObservers: [NavigationHistoryObserver()],
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: Globals.supportedLocales,
        locale: context.locale,
        theme: themeData,
        title: Globals.appName,
        onGenerateRoute: GlobalNavigator().onGenerateRoute,
        initialRoute: "/",
      ),
    );
  }

  Widget _materialAppParent(
    BuildContext parentContext,
    MaterialApp Function(ThemeData) builder,
  ) {
    return SizerHandler.init(
      context: parentContext,
      builder: (c, o, s) {
        ThemeData themeData = ThemeUtils.buildThemeData(
          id: 1,
          palette: _themePalette,
          sp: 1.sp,
        );
        AppThemeV2 appTheme = AppThemeV2(themeData);
        EasyLocalization.ensureInitialized();
        return GlobalLoader.buildOverlay(
          builder(themeData),
          overlayColor: Colors.black.withOpacity(0.5),
          loaderColor: appTheme.palette.primaryColor,
          size: 70.sp,
        );
      },
    );
  }
}
