import 'dart:async';

import 'package:photogenerator/bloc_utils/bloc.dart';

class LoadingPageData {
  int sentenceIndex = 0;
  double opacity = 1.0;
}

class LoadingPageBloc extends Bloc<LoadingPageData> {
  final Duration fadeDuration = Duration(milliseconds: 1000);
  late List<String> loadingSentences;
  late Timer _timer;

  LoadingPageBloc() : super(LoadingPageData()) {
    loadingSentences = [
      "Votre image est\nen cours de route",
      "La génération peut\nprendre jusqu'à une minute",
      "Veuillez patienter\nencore quelques instants",
      "Juste un moment,\nnous finalisons les détails",
      "Accrochez-vous,\nvotre image arrive bientôt",
      "Un petit instant,\nnous ajustons l'image",
      "C'est presque prêt,\nmerci de rester en ligne",
    ];
    loadingSentences.shuffle();
    loadingSentences.insert(
      0,
      "Chaque génération est unique,\ntestez ce modèle à volonté",
    );

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      blocData.opacity = 0;
      updateUI();

      Future.delayed(fadeDuration, () {
        blocData.sentenceIndex =
            (blocData.sentenceIndex + 1) % loadingSentences.length;
        blocData.opacity = 1;
        updateUI();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
