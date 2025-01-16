import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';

class PremiumAdInfoPageData {}

class PremiumAdInfoPageBloc extends Bloc<PremiumAdInfoPageData> {
  PremiumAdInfoPageBloc(Map<String, dynamic> args)
      : super(PremiumAdInfoPageData()) {}

  Future<void> confirm() async {
    await GlobalNavigator().pop({'confirm': true});
  }
}
