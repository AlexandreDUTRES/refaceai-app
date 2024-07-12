import 'dart:async';

import 'package:photogenerator/app_ui/loader_utils.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/models/global_app_data.dart';
import 'package:photogenerator/models/home_navigation_state.dart';
import 'package:photogenerator/models/model.dart';
import 'package:photogenerator/utils/Api.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';

class ModelPageData {}

class ModelPageBloc extends Bloc<ModelPageData> {
  late int _index;
  late List<Model> _models;

  late PreloadPageController preloadPageController;

  ModelPageBloc(Map<String, dynamic> args) : super(ModelPageData()) {
    assert(args.containsKey("index") && args["index"] is int);
    _index = args["index"];

    assert(args.containsKey("models") && args["models"] is List<Model>);
    _models = args["models"];

    preloadPageController = PreloadPageController(initialPage: _index);
  }

  List<Model> get models => _models;

  void setIndex(int v) {
    _index = v;
  }

  Future<void> openGalleryPage() async {
    Completer<String?> c = Completer<String?>();
    await GlobalNavigator().navigate(
      "/GalleryPage",
      callback: (res) {
        if (c.isCompleted) return;
        if (res != null && res.containsKey("filePath")) {
          return c.complete(res["filePath"]);
        }
        return c.complete(null);
      },
    );
    String? filePath = await c.future;
    if (filePath == null) return;

    await _generate(filePath);
  }

  Future<void> _generate(String filePath) async {
    if (blocManager.userBloc.credits!.count < Api.creditCost) {
      await GlobalNavigator().navigate("/CreditsModal");
      return;
    }

    await GlobalLoader.showLoadingPage();
    try {
      Generation _generation =
          await blocManager.generationBloc.createGeneration(
        blocManager.userBloc.userId!,
        filePath: filePath,
        promptId: _models[_index].id,
      );

      await blocManager.userBloc.refresh(
        maxCredits: Api.maxCredits,
        creditGainPeriod: Api.creditGainPeriod,
      );

      await GlobalLoader.hideLoadingPage();

      Provider.of<GlobalAppData>(
        GlobalNavigator().currentContext,
        listen: false,
      ).updateHomeNavigationState(HomeNavigationState.generations);
      await GlobalNavigator().popWithRemoval();
      await Common.goToGenerationPage(_generation);
    } catch (e) {
      await GlobalLoader.hideLoadingPage();
      if (e is Error) print(e.stackTrace);
      Common.showSnackbar();
      rethrow;
    }
  }
}
