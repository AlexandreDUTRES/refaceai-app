import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/global_app_data.dart';
import 'package:photogenerator/models/home_navigation_state.dart';
import 'package:provider/provider.dart';

class GenerationsPageData {
  int displayCnt = 14;
}

class GenerationsPageBloc extends Bloc<GenerationsPageData> {
  GenerationsPageBloc() : super(GenerationsPageData());

  void endingScrollCallback() {
    int maxCnt = blocManager.generationBloc.blocData!.generations.length;
    if (blocData.displayCnt >= maxCnt) return;
    _setDisplayCnt(blocData.displayCnt + 14);
  }

  void _setDisplayCnt(int v) {
    blocData.displayCnt = v;
    updateUI();
  }

  Future<void> goToModelsPage() async {
    Provider.of<GlobalAppData>(
      GlobalNavigator().currentContext,
      listen: false,
    ).updateHomeNavigationState(HomeNavigationState.models);
  }
}
