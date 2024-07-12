import 'dart:async';
import 'dart:io';

import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

class GalleryPageData {}

class GalleryPageBloc extends Bloc<GalleryPageData> {
  GalleryPageBloc(Map<String, dynamic> args) : super(GalleryPageData());

  Future<void> selectMedia(File file) async {
    await GlobalNavigator().pop({"filePath": file.path});
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

  Future<void> openFilePicker() async {
    File image;
    try {
      XFile? result =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result == null) return;
      image = await FlutterExifRotation.rotateImage(path: result.path);
    } catch (e) {
      return;
    }

    Completer<String?> c = Completer<String?>();
    await GlobalNavigator().navigate(
      "/PhotoPage",
      args: {"filePath": image.path},
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
