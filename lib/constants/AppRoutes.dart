import 'package:photogenerator/global_navigator/models/app_route.dart';
import 'package:photogenerator/global_navigator/utils.dart';
import 'package:photogenerator/pages/category/category_page.dart';
import 'package:photogenerator/pages/category/category_page_bloc.dart';
import 'package:photogenerator/pages/gallery/gallery_page.dart';
import 'package:photogenerator/pages/gallery/gallery_page_bloc.dart';
import 'package:photogenerator/pages/generation/generation_page.dart';
import 'package:photogenerator/pages/generation/generation_page_bloc.dart';
import 'package:photogenerator/pages/home/home_page.dart';
import 'package:photogenerator/pages/home/home_page_bloc.dart';
import 'package:photogenerator/pages/loading/loading_page.dart';
import 'package:photogenerator/pages/loading/loading_page_bloc.dart';
import 'package:photogenerator/pages/model/model_page.dart';
import 'package:photogenerator/pages/model/model_page_bloc.dart';
import 'package:photogenerator/pages/camera/camera_page.dart';
import 'package:photogenerator/pages/camera/camera_page_bloc.dart';
import 'package:photogenerator/pages/photo/photo_page.dart';
import 'package:photogenerator/pages/photo/photo_page_bloc.dart';
import 'package:photogenerator/pages/onboarding/onboarding_page.dart';
import 'package:photogenerator/pages/onboarding/onboarding_page_bloc.dart';
import 'package:photogenerator/pages/premium_ad_info/premium_ad_info_page.dart';
import 'package:photogenerator/pages/premium_ad_info/premium_ad_info_page_bloc.dart';
import 'package:photogenerator/pages/settings/settings_page.dart';
import 'package:photogenerator/pages/settings/settings_page_bloc.dart';
import 'package:photogenerator/pages/splash/splash_page.dart';
import 'package:photogenerator/pages/splash/splash_page_bloc.dart';

class AppRoutes {
  static List<AppRoute> get routes => [
        AppRoute<SplashPageBloc>(
          name: "/",
          dataSharingName: "SplashPage",
          pushFunction: pushAndRemoveUntilToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: null,
          createBloc: (args) => SplashPageBloc(),
          createChild: (_) => SplashPage(),
        ),
        AppRoute<HomePageBloc>(
          name: "/HomePage",
          dataSharingName: "HomePage",
          pushFunction: pushAndRemoveUntilToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: null,
          createBloc: (args) => HomePageBloc(args),
          createChild: (_) => HomePage(),
        ),
        AppRoute<SettingsPageBloc>(
          name: "/SettingsPage",
          dataSharingName: "SettingsPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: PageTransitionType.fade,
          createBloc: (args) => SettingsPageBloc(args),
          createChild: (_) => SettingsPage(),
        ),
        AppRoute<GalleryPageBloc>(
          name: "/GalleryPage",
          dataSharingName: "GalleryPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: PageTransitionType.fade,
          createBloc: (args) => GalleryPageBloc(args),
          createChild: (_) => GalleryPage(),
        ),
        AppRoute<CategoryPageBloc>(
          name: "/CategoryPage",
          dataSharingName: "CategoryPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: PageTransitionType.fade,
          createBloc: (args) => CategoryPageBloc(args),
          createChild: (_) => CategoryPage(),
        ),
        AppRoute<ModelPageBloc>(
          name: "/ModelPage",
          dataSharingName: "ModelPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: PageTransitionType.rightToLeft,
          createBloc: (args) => ModelPageBloc(args),
          createChild: (_) => ModelPage(),
        ),
        AppRoute<GenerationPageBloc>(
          name: "/GenerationPage",
          dataSharingName: "GenerationPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: PageTransitionType.rightToLeft,
          createBloc: (args) => GenerationPageBloc(args),
          createChild: (_) => GenerationPage(),
        ),
        AppRoute<LoadingPageBloc>(
          name: "/LoadingPage",
          dataSharingName: "LoadingPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: PageTransitionType.fade,
          createBloc: (args) => LoadingPageBloc(),
          createChild: (_) => LoadingPage(),
        ),
        AppRoute<OnboardingPageBloc>(
          name: "/OnboardingPage",
          dataSharingName: "OnboardingPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: PageTransitionType.fade,
          createBloc: (args) => OnboardingPageBloc(args),
          createChild: (_) => OnboardingPage(),
        ),
        AppRoute<PremiumAdInfoPageBloc>(
          name: "/PremiumAdInfoPage",
          dataSharingName: "PremiumAdInfoPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: PageTransitionType.fade,
          createBloc: (args) => PremiumAdInfoPageBloc(args),
          createChild: (_) => PremiumAdInfoPage(),
        ),
        AppRoute<CameraPageBloc>(
          name: "/CameraPage",
          dataSharingName: "CameraPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: PageTransitionType.fade,
          createBloc: (args) => CameraPageBloc(args),
          createChild: (_) => CameraPage(),
        ),
        AppRoute<PhotoPageBloc>(
          name: "/PhotoPage",
          dataSharingName: "PhotoPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          pageTransitionType: PageTransitionType.fade,
          createBloc: (args) => PhotoPageBloc(args),
          createChild: (_) => PhotoPage(),
        ),
      ];
}
