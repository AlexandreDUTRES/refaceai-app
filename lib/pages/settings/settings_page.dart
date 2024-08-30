import 'package:flutter/material.dart';
import 'package:photogenerator/Globals.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/pages/settings/settings_page_bloc.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';
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

    final ScrollController customScrollController = ScrollController();

    return StreamBuilder<SettingsPageData>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return PageLayout(
          mainScrollController: customScrollController,
          backgroundColor: _appTheme.palette.backgroundColor,
          bodyBuilder: (
            BuildContext context,
            BoxConstraints constraints,
            double topPadding,
            double bottomPadding,
          ) {
            return SingleChildScrollView(
              controller: customScrollController,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: topPadding)),
                  PageTopBar(
                    backButton: false,
                    title: tr("pages.settings.txt_title"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.sp)),
                  _buildSectionTitle(
                    tr("pages.settings.txt_account"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.sp)),
                  _buildButton(
                    iconData: Icons.delete_outline,
                    title: tr("pages.settings.txt_account_delete"),
                    onTap: () async => await bloc.openDeleteUserModal(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.sp)),
                  _buildSectionTitle(
                    tr("pages.settings.txt_about"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.sp)),
                  _buildButton(
                    iconData: Icons.help_outline,
                    title: tr("pages.settings.txt_about_help"),
                    onTap: () async => await bloc.startOnboardingTour(),
                  ),
                  _buildButton(
                    iconData: Icons.mail_outline,
                    title: tr("pages.settings.txt_about_contact"),
                    text: "madproject.corp@gmail.com",
                    onTap: () async => await bloc.contactUs(),
                  ),
                  _buildButton(
                    iconData: Icons.gavel_rounded,
                    title: tr("pages.settings.txt_about_terms"),
                    onTap: () async => await bloc.openTerms(),
                  ),
                  _buildButton(
                    iconData: Icons.policy_outlined,
                    title: tr("pages.settings.txt_about_policy"),
                    onTap: () async => await bloc.openPrivacy(),
                  ),
                  _buildButton(
                    iconData: Icons.radio_button_off,
                    title: Globals.appName,
                    text: Globals.appVersion,
                    subText: blocManager.userBloc.userId!,
                    onTap: () => {},
                  ),
                  Padding(padding: EdgeInsets.only(top: bottomPadding)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
