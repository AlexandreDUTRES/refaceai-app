import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:photogenerator/utils/OnboardingTools.dart';

class SettingsPageData {}

class SettingsPageBloc extends Bloc<SettingsPageData> {
  SettingsPageBloc(Map<String, dynamic> args) : super(SettingsPageData());

  Future<void> openDeleteUserModal() async {
    await GlobalNavigator().navigate("/DeleteUserModal");
  }

  Future<void> contactUs() async {
    await Common.launchURL("mailto:madproject.corp@gmail.com");
  }

  Future<void> openTerms() async {
    await Common.launchURL("https://nextmove-e83e3.web.app/terms.html");
  }

  Future<void> openPrivacy() async {
    await Common.launchURL("https://nextmove-e83e3.web.app/privacy.html");
  }

  Future<void> startOnboardingTour() async {
    await OnboardingTools.startTour();
  }
}
