import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';

class PhotoPageData {
  bool? faceDetected;
}

class PhotoPageBloc extends Bloc<PhotoPageData> {
  late File _file;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      minFaceSize: 0.7,
      enableClassification: true,
    ),
  );

  PhotoPageBloc(Map<String, dynamic> args) : super(PhotoPageData()) {
    assert(args.containsKey("filePath") && args["filePath"] is String);
    _file = File(args["filePath"]);

    _processImage();
  }

  File get file => _file;

  Future<void> goBack() async {
    await GlobalNavigator().pop();
  }

  Future<void> _processImage() async {
    final inputImage = InputImage.fromFile(_file);
    List<Face> faces = await _faceDetector.processImage(inputImage);
    blocData.faceDetected = faces.length == 1;
    updateUI();
  }

  File? _galleryFile;
  Future<File> _getGalleryFile() async {
    if (_galleryFile != null) return _galleryFile!;
    return await blocManager.galleryBloc.addFile(_file);
  }

  Future<void> useImage() async {
    File galleryFile = await _getGalleryFile();
    await GlobalNavigator().pop({"filePath": galleryFile.path});
  }
}
