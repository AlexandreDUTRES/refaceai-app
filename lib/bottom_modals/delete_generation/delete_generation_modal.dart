import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/bottom_modals/delete_generation/delete_generation_modal_bloc.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/ui/widgets/bottom_modal_layout.dart';

// responsive ok
// ignore: must_be_immutable
class DeleteGenerationModal extends StatelessWidget {
  late DeleteGenerationModalBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildInfoText() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Text(
        tr('bottom_modals.delete_generation.txt_title'),
        style: _appTheme.fonts.sBody.semibold.style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: () async => await bloc.confirm(),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.sp),
        padding: EdgeInsets.symmetric(
          vertical: 12.sp,
          horizontal: 50.sp,
        ),
        decoration: BoxDecoration(
          gradient: _appTheme.palette.primaryGradient,
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: Text(
          tr('globals.confirm'),
          style: _appTheme.fonts.body.bold.style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DeleteGenerationModalBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return BottomModalLayout(
      backgroundColor: _appTheme.palette.borderColor,
      content: StreamBuilder<DeleteGenerationModalData>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: EdgeInsets.only(top: 16.sp)),
              _buildInfoText(),
              Padding(padding: EdgeInsets.only(top: 24.sp)),
              _buildConfirmButton(),
              Padding(padding: EdgeInsets.only(top: 16.sp)),
            ],
          );
        },
      ),
    );
  }
}
