import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/blocs/main_app_widget_bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/ui/widgets/camera_view.dart';

enum CameraState { active, denied, waiting }

class CameraPageData {
  CameraState cameraState = CameraState.waiting;
}

class CameraPageBloc extends Bloc<CameraPageData> {
  late StreamSubscription<MainAppWidgetBlocData> _mainAppWidgetSubscription;
  final GlobalKey<CameraViewState> cameraViewKey = GlobalKey<CameraViewState>();

  PermissionStatus? cameraPermissionStatus;

  CameraPageBloc(Map<String, dynamic> args) : super(CameraPageData()) {
    _checkCameraPermission();

    _mainAppWidgetSubscription = MainAppWidgetBloc().stream.listen((data) {
      if (cameraPermissionStatus != PermissionStatus.granted) return;
      if (data.appLifecycleState != AppLifecycleState.resumed) {
        _setCameraState(CameraState.waiting);
      } else if (blocData.cameraState == CameraState.waiting) {
        _setCameraState(CameraState.active);
      }
    });
  }

  @override
  void dispose() {
    _mainAppWidgetSubscription.cancel();
    super.dispose();
  }

  void _setCameraState(CameraState state) {
    blocData.cameraState = state;
    updateUI();
  }

  void switchCamera() {
    cameraViewKey.currentState!.switchLiveCamera();
  }

  Future<void> _checkCameraPermission() async {
    cameraPermissionStatus = await Permission.camera.request();
    if (cameraPermissionStatus == PermissionStatus.granted ||
        cameraPermissionStatus == PermissionStatus.limited)
      _setCameraState(CameraState.active);
    else
      _setCameraState(CameraState.denied);
  }

  bool _isTakingPhoto = false;
  Future<void> takePhoto() async {
    if (_isTakingPhoto) return;
    _isTakingPhoto = true;

    XFile? file = await cameraViewKey.currentState!.takePhoto();
    if (file == null) return;

    _isTakingPhoto = false;

    Completer<String?> c = Completer<String?>();
    await GlobalNavigator().navigate(
      "/PhotoPage",
      args: {"filePath": file.path},
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
