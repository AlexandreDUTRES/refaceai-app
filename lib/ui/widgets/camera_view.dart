library camera_view;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photogenerator/app_ui/utils.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    this.initialDirection = CameraLensDirection.back,
  }) : super(key: key);

  final CameraLensDirection initialDirection;

  static List<CameraDescription> cameras = [];

  static Future<void> setCameras() async {
    try {
      cameras = await availableCameras();
    } catch (_) {}
  }

  @override
  CameraViewState createState() => CameraViewState();
}

class CameraViewState extends State<CameraView> {
  CameraController? _controller;
  int _cameraIndex = 0;
  bool _showCameraPreview = false;

  @override
  void initState() {
    super.initState();
    if (CameraView.cameras.isNotEmpty) {
      _initializeCamera();
      setShowCameraPreview(true);
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  void _initializeCamera() {
    if (CameraView.cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = CameraView.cameras.indexOf(
        CameraView.cameras.firstWhere((element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      _cameraIndex = CameraView.cameras.indexOf(
        CameraView.cameras.firstWhere(
          (element) => element.lensDirection == widget.initialDirection,
        ),
      );
    }

    _startLiveFeed();
  }

  Widget _buildCameraPreview() {
    return CameraPreview(_controller!);
  }

  bool _isControllerInitialized() {
    return _controller != null && _controller!.value.isInitialized;
  }

  @override
  Widget build(BuildContext context) {
    if (!_showCameraPreview || !_isControllerInitialized()) {
      return Container();
    }
    return _buildCameraPreview();
  }

  void setShowCameraPreview(bool value) {
    if (!mounted) return;
    setState(() {
      _showCameraPreview = value;
    });
  }

  Future _startLiveFeed() async {
    final CameraDescription camera = CameraView.cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) => setState(() {}));
    _controller?.lockCaptureOrientation(DeviceOrientation.portraitUp);
  }

  Future _stopLiveFeed() async {
    if (_isControllerInitialized()) {
      await _controller?.dispose();
    }
    _controller = null;
  }

  Future switchLiveCamera() async {
    if (CameraView.cameras.length - 1 > _cameraIndex) {
      _cameraIndex++;
    } else {
      _cameraIndex = 0;
    }

    setShowCameraPreview(false);
    await _startLiveFeed();
    setShowCameraPreview(true);
  }

  void switchFlashMode(FlashMode flashMode) {
    if (_isControllerInitialized()) _controller!.setFlashMode(flashMode);
  }

  Future<void> pausePreview() async {
    if (_isControllerInitialized()) await _controller!.pausePreview();
  }

  Future<void> resumePreview() async {
    if (_isControllerInitialized()) await _controller!.resumePreview();
  }

  Future<XFile?> takePhoto() async {
    if (_isControllerInitialized())
      return await _controller!.takePicture();
    else
      return null;
  }
}
