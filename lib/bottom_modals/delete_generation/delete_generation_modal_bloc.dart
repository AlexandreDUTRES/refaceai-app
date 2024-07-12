import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:photogenerator/app_ui/loader_utils.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/models/global_app_data.dart';
import 'package:photogenerator/models/home_navigation_state.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:provider/provider.dart';

class DeleteGenerationModalData {}

class DeleteGenerationModalBloc extends Bloc<DeleteGenerationModalData> {
  late Generation _generation;

  DeleteGenerationModalBloc(Map<String, dynamic> args)
      : super(DeleteGenerationModalData()) {
    assert(args.containsKey("generation") && args["generation"] is Generation);
    _generation = args["generation"];
  }

  Future<void> confirm() async {
    await GlobalLoader.showOverlayLoader();
    try {
      await blocManager.generationBloc.deleteGeneration(
        blocManager.userBloc.userId!,
        generation: _generation,
      );
    } catch (e) {
      if (kDebugMode) print(e);
      GlobalLoader.hideOverlayLoader();
      return Common.showSnackbar();
    }
    await GlobalNavigator().pop();
    GlobalLoader.hideOverlayLoader();

    Provider.of<GlobalAppData>(
      GlobalNavigator().currentContext,
      listen: false,
    ).updateHomeNavigationState(HomeNavigationState.generations);
    await GlobalNavigator().popWithRemoval();
  }
}
