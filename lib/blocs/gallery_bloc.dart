library gallery_bloc;

import 'dart:async';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photogenerator/bloc_utils/bloc_rx.dart';
import 'package:photogenerator/models/bloc_data/gallery_bloc_data.dart';

class GalleryBloc extends BlocRx<GalleryBlocData> {
  late Directory _directory;

  GalleryBloc() {
    initialize(GalleryBlocData());
  }

  void resetData() {
    blocData!.files = [];
    updateUI();
  }

  Future<void> initializeData() async {
    _directory = await getApplicationDocumentsDirectory();
    RegExp regExp = RegExp(r"(media_)(.*)(\.jpg)");
    for (FileSystemEntity e in _directory.listSync()) {
      if (regExp.hasMatch(e.path)) blocData!.files.add(File(e.path));
    }
  }

  Future<File> addFile(File inputFile) async {
    String imagePath =
        '${_directory.path}/media_${DateTime.now().toIso8601String()}.jpg';
    File compressedFile = await _compressFile(inputFile.path, imagePath);
    blocData!.files.add(compressedFile);
    updateUI();
    return compressedFile;
  }

  Future<void> deleteFile(File file) async {
    await file.delete();
    blocData!.files.remove(file);
    updateUI();
  }

  Future<File> _compressFile(String inPath, String outPath) async {
    XFile? xfile = await FlutterImageCompress.compressAndGetFile(
      inPath,
      outPath,
      quality: 88,
      minHeight: 500,
      minWidth: 500,
    );
    return File(xfile!.path);
  }
}
