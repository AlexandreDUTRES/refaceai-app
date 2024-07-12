import 'dart:async';

import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';

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
      tr("pages.loading.sentence_1"),
      tr("pages.loading.sentence_2"),
      tr("pages.loading.sentence_3"),
      tr("pages.loading.sentence_4"),
      tr("pages.loading.sentence_5"),
      tr("pages.loading.sentence_6"),
      tr("pages.loading.sentence_7"),
    ];
    loadingSentences.shuffle();
    loadingSentences.insert(0, tr("pages.loading.sentence_0"));

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
