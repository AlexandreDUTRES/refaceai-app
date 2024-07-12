import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';

class OnboardingPageData {}

class OnboardingPageBloc extends Bloc<OnboardingPageData> {
  late CustomPngs image;
  late String title;
  late String description;
  late String btnText;
  String? subBtnText;

  OnboardingPageBloc(Map<String, dynamic> args) : super(OnboardingPageData()) {
    assert(args.containsKey("image") && args["image"] is CustomPngs);
    image = args["image"];

    assert(args.containsKey("title") && args["title"] is String);
    title = args["title"];

    assert(args.containsKey("description") && args["description"] is String);
    description = args["description"];

    assert(args.containsKey("btnText") && args["btnText"] is String);
    btnText = args["btnText"];

    if (args.containsKey("subBtnText") && args["subBtnText"] is String)
      subBtnText = args["subBtnText"];
  }

  Future<void> goNext() async {
    await GlobalNavigator().pop();
  }
}
