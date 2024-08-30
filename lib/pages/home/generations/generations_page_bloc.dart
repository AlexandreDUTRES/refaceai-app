import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/models/global_app_data.dart';
import 'package:photogenerator/models/home_navigation_state.dart';
import 'package:provider/provider.dart';

class GenerationsPageData {
}

class GenerationsPageBloc extends Bloc<GenerationsPageData> {
  GenerationsPageBloc() : super(GenerationsPageData());

  Future<void> goToModelsPage() async {
    Provider.of<GlobalAppData>(
      GlobalNavigator().currentContext,
      listen: false,
    ).updateHomeNavigationState(HomeNavigationState.models);
  }
}
