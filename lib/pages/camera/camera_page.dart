import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/pages/camera/camera_page_bloc.dart';
import 'package:photogenerator/ui/widgets/camera_view.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';

// responsive ok
// ignore: must_be_immutable
class CameraPage extends StatelessWidget {
  late CameraPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildBottomButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30.sp,
          ),
          GestureDetector(
            onTap: () async => await bloc.takePhoto(),
            child: Container(
              color: Colors.transparent,
              child: Icon(
                Icons.adjust,
                size: 60.sp,
                color: _appTheme.palette.textColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => bloc.switchCamera(),
            child: Container(
              color: Colors.transparent,
              child: Icon(
                Icons.cameraswitch_outlined,
                size: 30.sp,
                color: _appTheme.palette.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return LayoutBuilder(
      builder: ((context, constraints) {
        double size = constraints.maxWidth * 4;
        return Stack(
          children: [
            CameraView(
              key: bloc.cameraViewKey,
              initialDirection: CameraLensDirection.front,
            ),
            Positioned(
              top: -size / 3.7,
              left: -size / 4 - constraints.maxWidth / 2,
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: size,
                  height: size,
                  color: Colors.transparent,
                  child: CustomPngs.others__face_mask.build(
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CameraPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return PageLayout(
      backgroundColor: _appTheme.palette.backgroundColor,
      bodyBuilder: (
        BuildContext context,
        BoxConstraints constraints,
        double topPadding,
        double bottomPadding,
      ) {
        return Column(
          children: [
            Padding(padding: EdgeInsets.only(top: topPadding)),
            Expanded(
              child: StreamBuilder<CameraPageData>(
                stream: bloc.stream,
                builder: (_, snapshot) =>
                    snapshot.data?.cameraState == CameraState.active
                        ? _buildCameraView()
                        : Container(
                            color: Colors.black,
                          ),
              ),
            ),
            _buildBottomButton(),
            Padding(padding: EdgeInsets.only(top: bottomPadding)),
          ],
        );
      },
    );
  }
}
