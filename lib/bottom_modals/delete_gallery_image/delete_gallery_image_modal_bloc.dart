import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';

class DeleteGalleryImageModalData {}

class DeleteGalleryImageModalBloc extends Bloc<DeleteGalleryImageModalData> {
  late File _file;

  DeleteGalleryImageModalBloc(Map<String, dynamic> args)
      : _file = args["file"] as File,
        super(DeleteGalleryImageModalData());

  Future<void> confirm() async {
    try {
      await blocManager.galleryBloc.deleteFile(_file);
    } catch (e) {
      if (kDebugMode) print(e);
    }
    await GlobalNavigator().pop();
  }
}
