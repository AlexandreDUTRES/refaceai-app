import 'dart:async';
import 'dart:io';

import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_cropper/image_cropper.dart';

class GalleryPageData {}

class GalleryPageBloc extends Bloc<GalleryPageData> {
  GalleryPageBloc(Map<String, dynamic> args) : super(GalleryPageData());

  Future<void> selectMedia(File file) async {
    await GlobalNavigator().pop({"filePath": file.path});
  }

  Future<void> goToDeleteGalleryImageModal(File file) async {
    await GlobalNavigator().navigate(
      "/DeleteGalleryImageModal",
      args: {"file": file},
    );
  }

  Future<void> openCameraPage() async {
    Completer<String?> c = Completer<String?>();
    await GlobalNavigator().navigate(
      "/CameraPage",
      callback: (res) {
        if (c.isCompleted) return;
        if (res != null && res.containsKey("filePath")) {
          return c.complete(res["filePath"]);
        }
        return c.complete(null);
      },
    );
    String? filePath = await c.future;
    if (filePath == null) return;

    await GlobalNavigator().pop({"filePath": filePath});
  }

  Future<void> openFilePicker(AppThemeV2 appTheme) async {
    File image;
    try {
      XFile? result =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result == null) return;
      image = await FlutterExifRotation.rotateImage(path: result.path);
    } catch (e) {
      return;
    }

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: tr("pages.gallery.txt_cropper_title"),
          toolbarColor: appTheme.palette.primaryColor,
          toolbarWidgetColor: appTheme.palette.textColor,
          activeControlsWidgetColor: appTheme.palette.primaryColor,
          hideBottomControls: true,

        ),
      ],
    );
    if (croppedFile == null) return;

    Completer<String?> c = Completer<String?>();
    await GlobalNavigator().navigate(
      "/PhotoPage",
      args: {"filePath": croppedFile.path},
      callback: (res) {
        if (c.isCompleted) return;
        if (res != null && res.containsKey("filePath")) {
          return c.complete(res["filePath"]);
        }
        return c.complete(null);
      },
    );
    String? finalFilePath = await c.future;
    if (finalFilePath == null) return;

    await GlobalNavigator().pop({"filePath": finalFilePath});
  }
}
