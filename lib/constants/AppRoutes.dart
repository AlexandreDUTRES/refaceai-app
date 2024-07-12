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
          createBloc: (args) => SplashPageBloc(),
          createChild: (_) => SplashPage(),
        ),
        AppRoute<HomePageBloc>(
          name: "/HomePage",
          dataSharingName: "HomePage",
          pushFunction: pushAndRemoveUntilToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          createBloc: (args) => HomePageBloc(args),
          createChild: (_) => HomePage(),
        ),
        AppRoute<GalleryPageBloc>(
          name: "/GalleryPage",
          dataSharingName: "GalleryPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          createBloc: (args) => GalleryPageBloc(args),
          createChild: (_) => GalleryPage(),
        ),
        AppRoute<CategoryPageBloc>(
          name: "/CategoryPage",
          dataSharingName: "CategoryPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          createBloc: (args) => CategoryPageBloc(args),
          createChild: (_) => CategoryPage(),
        ),
        AppRoute<ModelPageBloc>(
          name: "/ModelPage",
          dataSharingName: "ModelPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          createBloc: (args) => ModelPageBloc(args),
          createChild: (_) => ModelPage(),
        ),
        AppRoute<GenerationPageBloc>(
          name: "/GenerationPage",
          dataSharingName: "GenerationPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          createBloc: (args) => GenerationPageBloc(args),
          createChild: (_) => GenerationPage(),
        ),
        AppRoute<LoadingPageBloc>(
          name: "/LoadingPage",
          dataSharingName: "LoadingPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          createBloc: (args) => LoadingPageBloc(),
          createChild: (_) => LoadingPage(),
        ),
        AppRoute<OnboardingPageBloc>(
          name: "/OnboardingPage",
          dataSharingName: "OnboardingPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          createBloc: (args) => OnboardingPageBloc(args),
          createChild: (_) => OnboardingPage(),
        ),
        AppRoute<CameraPageBloc>(
          name: "/CameraPage",
          dataSharingName: "CameraPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          createBloc: (args) => CameraPageBloc(args),
          createChild: (_) => CameraPage(),
        ),
        AppRoute<PhotoPageBloc>(
          name: "/PhotoPage",
          dataSharingName: "PhotoPage",
          pushFunction: pushToGN,
          disableOverlayAlerts: true,
          forcedLightStatusBar: true,
          createBloc: (args) => PhotoPageBloc(args),
          createChild: (_) => PhotoPage(),
        ),
      ];
}
