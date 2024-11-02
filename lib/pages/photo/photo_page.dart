import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/pages/photo/photo_page_bloc.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';

// responsive ok
// ignore: must_be_immutable
class PhotoPage extends StatelessWidget {
  late PhotoPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildNoFaceContainer() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.sp),
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        color: Colors.red[600],
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tr("pages.photo.txt_no_face"),
              style: _appTheme.fonts.body.semibold.style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 8.sp)),
          GestureDetector(
            onTap: () async => await bloc.goBack(),
            child: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _appTheme.palette.textColor,
              ),
              child: Icon(
                Icons.refresh,
                color: Colors.red,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => bloc.goBack(),
            child: Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 34.sp,
                color: _appTheme.palette.textColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => bloc.useImage(),
            child: Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 34.sp,
                color: _appTheme.palette.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    bloc = BlocProvider.of<PhotoPageBloc>(context);
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
              child: Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14159),
                        child: Image.file(
                          bloc.file,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 40.sp,
                      child: StreamBuilder<PhotoPageData>(
                        stream: bloc.stream,
                        builder: (_, snapshot) {
                          if (snapshot.data?.faceDetected == null)
                            return Container();
                          if (snapshot.data!.faceDetected!) {
                            return _buildBottomBar();
                          } else {
                            return _buildNoFaceContainer();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: bottomPadding)),
          ],
        );
      },
    );
  }
}
