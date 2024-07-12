import 'dart:async';

import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';

class OnboardingTools {
  static Future<void> startTour() async {
    await _waitPage(
      image: CustomPngs.onboardings__onboarding_1,
      title: tr("utils.onboarding_tools.1.title"),
      description: tr("utils.onboarding_tools.1.description"),
      btnText: tr("utils.onboarding_tools.1.btn_text"),
      subBtnText: tr("utils.onboarding_tools.1.sub_btn_text"),
    );
    await _waitPage(
      image: CustomPngs.onboardings__onboarding_2,
      title: tr("utils.onboarding_tools.2.title"),
      description: tr("utils.onboarding_tools.2.description"),
      btnText: tr("utils.onboarding_tools.2.btn_text"),
    );
    await _waitPage(
      image: CustomPngs.onboardings__onboarding_3,
      title: tr("utils.onboarding_tools.3.title"),
      description: tr("utils.onboarding_tools.3.description"),
      btnText: tr("utils.onboarding_tools.3.btn_text"),
    );
    await _waitPage(
      image: CustomPngs.onboardings__onboarding_4,
      title: tr("utils.onboarding_tools.4.title"),
      description: tr("utils.onboarding_tools.4.description"),
      btnText: tr("utils.onboarding_tools.4.btn_text"),
    );
  }

  static Future<void> _waitPage({
    required CustomPngs image,
    required String title,
    required String description,
    required String btnText,
    String? subBtnText,
  }) async {
    Completer<void> c = Completer<void>();
    await GlobalNavigator().navigate(
      "/OnboardingPage",
      args: {
        "image": image,
        "title": title,
        "description": description,
        "btnText": btnText,
        if (subBtnText != null) "subBtnText": subBtnText,
      },
      callback: (res) async {
        if (c.isCompleted) return;
        c.complete();
      },
    );
    await c.future;
  }
}
