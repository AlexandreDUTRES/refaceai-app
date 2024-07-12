import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';

class AdWarningPageData {}

class AdWarningPageBloc extends Bloc<AdWarningPageData> {
  AdWarningPageBloc(Map<String, dynamic> args) : super(AdWarningPageData()) {}

  Future<void> close() async {
    await GlobalNavigator().pop();
  }
}
