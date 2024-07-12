import 'dart:async';

import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';

class OnboardingTools {
  static Future<void> startTour() async {
    await _waitPage(
      image: CustomPngs.onboardings__onboarding_1,
      title: "Bienvenue sur ReFaceAI",
      description: "Transformez-vous en quelques secondes",
      btnText: "Commencer",
      subBtnText:
          "En appuyant sur le bouton 'Commencer', vous acceptez notre Politique de confidentialité et Conditions d'utilisation",
    );
    await _waitPage(
      image: CustomPngs.onboardings__onboarding_2,
      title: "Choisissez un modèle",
      description:
          "Parcourez les catégories et choisissez parmi une grande variété de scènes.",
      btnText: "Continuer",
    );
    await _waitPage(
      image: CustomPngs.onboardings__onboarding_3,
      title: "Sélectionnez une photo",
      description:
          "Prenez-vous en photo, ou sélectionnez une image existante dans votre galerie.",
      btnText: "Continuer",
    );
    await _waitPage(
      image: CustomPngs.onboardings__onboarding_4,
      title: "Admirez votre avatar réaliste !",
      description: "Et partagez le résultat époustouflant avec vos amis sur les réseaux.",
      btnText: "Continuer",
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
