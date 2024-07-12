import 'package:flutter/material.dart';
import 'package:photogenerator/Globals.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/pages/home/settings/settings_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/widgets/main_scroller.dart';
import 'package:photogenerator/ui/widgets/page_top_bar.dart';

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {
  late SettingsPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Text(
        title,
        style: _appTheme.fonts.sBody.semibold.style,
      ),
    );
  }

  Widget _buildButton({
    required String title,
    required Function()? onTap,
    required IconData iconData,
    String? text,
    String? subText,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(
            horizontal: 16.sp, vertical: text == null ? 16.sp : 12.sp),
        child: Row(
          children: [
            Icon(
              iconData,
              color: _appTheme.palette.textColor,
              size: 25.sp,
            ),
            Padding(padding: EdgeInsets.only(left: 10.sp)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: _appTheme.fonts.body.style,
                  ),
                  if (text != null)
                    Text(
                      text,
                      style: _appTheme.fonts.sBody.style,
                    ),
                  if (subText != null)
                    Opacity(
                      opacity: 0.5,
                      child: Text(
                        blocManager.userBloc.userId!,
                        style: _appTheme.fonts.xsBody.style,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<SettingsPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return StreamBuilder<SettingsPageData>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        return LayoutBuilder(
          builder: (context, constraints) => MainScroller(
            parentHeight: constraints.maxHeight,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: SizerHandler.statusBarHeight),
                ),
                PageTopBar(
                  backButton: false,
                  title: "Paramètres",
                ),
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                _buildSectionTitle("Compte"),
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                _buildButton(
                  iconData: Icons.delete_outline,
                  title: "Supprimer les données",
                  onTap: () async => await bloc.openDeleteUserModal(),
                ),
                Padding(padding: EdgeInsets.only(top: 20.sp)),
                _buildSectionTitle("A propos"),
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                _buildButton(
                  iconData: Icons.help_outline,
                  title: "Aide",
                  onTap: () async => await bloc.startOnboardingTour(),
                ),
                _buildButton(
                  iconData: Icons.mail_outline,
                  title: "Nous contacter",
                  text: "madproject.corp@gmail.com",
                  onTap: () async => await bloc.contactUs(),
                ),
                _buildButton(
                  iconData: Icons.gavel_rounded,
                  title: "Conditions générales d'utilisations",
                  onTap: () async => await bloc.openTerms(),
                ),
                _buildButton(
                  iconData: Icons.policy_outlined,
                  title: "Politique de confidentialité",
                  onTap: () async => await bloc.openPrivacy(),
                ),
                _buildButton(
                  iconData: Icons.radio_button_off,
                  title: Globals.appName,
                  text: Globals.appVersion,
                  subText: blocManager.userBloc.userId!,
                  onTap: () => {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
