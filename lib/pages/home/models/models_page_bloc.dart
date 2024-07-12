import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/models/model_category.dart';

class ModelsPageData {}

class ModelsPageBloc extends Bloc<ModelsPageData> {
  ModelsPageBloc() : super(ModelsPageData()) {}

  Future<void> goToSettingsPage() async {
    await GlobalNavigator().navigate("/SettingsPage");
  }

  Future<void> goToCategoryPage(ModelCategory category) async {
    await GlobalNavigator().navigate(
      "/CategoryPage",
      args: {"category": category},
    );
  }
}
