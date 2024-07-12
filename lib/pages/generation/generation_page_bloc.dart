import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:photogenerator/app_ui/loader_utils.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/storage_utils/shared_preferences_storage.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/v4.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class GenerationPageData {
  late List<bool> isLocallySaved;
}

class GenerationPageBloc extends Bloc<GenerationPageData> {
  late int _index;
  late List<Generation> _generations;

  late PreloadPageController preloadPageController;

  GenerationPageBloc(Map<String, dynamic> args) : super(GenerationPageData()) {
    assert(args.containsKey("index") && args["index"] is int);
    _index = args["index"];

    assert(args.containsKey("generations") &&
        args["generations"] is List<Generation>);
    _generations = args["generations"];

    preloadPageController = PreloadPageController(initialPage: _index);

    blocData.isLocallySaved =
        List<bool>.generate(_generations.length, (_) => false, growable: false);
    _checkIsLocallySaved();
  }

  List<Generation> get generations => _generations;

  void setIndex(int v) {
    _index = v;
  }

  void _checkIsLocallySaved() {
    for (int i = 0; i < _generations.length; i++) {
      String? path = _getLocalPath(_generations[i]);
      blocData.isLocallySaved[i] = path != null;
    }
    updateUI();
  }

  String? _getLocalPath(Generation generation) {
    Map<String, String> savedPictures =
        SharedPreferencesStorage.getSavedPictures();

    if (!savedPictures.containsKey(generation.url)) {
      return null;
    } else {
      return File(savedPictures[generation.url]!).existsSync()
          ? savedPictures[generation.url]!
          : null;
    }
  }

  Future<String> _downloadImage(Generation generation) async {
    String? localPath = _getLocalPath(generation);
    if (localPath != null) return localPath;

    final response = await http.get(Uri.parse(generation.url));
    if (response.statusCode != 200) throw "null";

    Uint8List webpImage = response.bodyBytes;
    img.Image? decodedImage = img.decodeWebP(webpImage);
    if (decodedImage == null) throw "null";
    Uint8List jpgImage = Uint8List.fromList(img.encodeJpg(decodedImage));

    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/${UuidV4().generate()}.jpg';

    File file = File(filePath);
    await file.writeAsBytes(jpgImage);

    Map<String, String> savedPictures =
        SharedPreferencesStorage.getSavedPictures();
    savedPictures[generation.url] = file.path;
    await SharedPreferencesStorage.storeSavedPictures(savedPictures);

    return file.path;
  }

  Future<void> locallySaveImage() async {
    await GlobalLoader.showOverlayLoader();
    try {
      await _downloadImage(_generations[_index]);
      _checkIsLocallySaved();

      GlobalLoader.hideOverlayLoader();
      Common.showSnackbar(tr("pages.generation.snackbar_image_saved"));
    } catch (error) {
      GlobalLoader.hideOverlayLoader();
      Common.showSnackbar();
    }
  }

  Future<void> share() async {
    await GlobalLoader.showOverlayLoader();
    try {
      String filePath = await _downloadImage(_generations[_index]);
      _checkIsLocallySaved();
      GlobalLoader.hideOverlayLoader();
      await Share.shareXFiles(
        [XFile(filePath)],
        text: tr("pages.generation.share_msg"),
      );
    } catch (_) {
      GlobalLoader.hideOverlayLoader();
      Common.showSnackbar();
    }
  }

  Future<void> goToDeleteGenerationModal() async {
    await GlobalNavigator().navigate("/DeleteGenerationModal", args: {
      "generation": _generations[_index],
    });
  }
}
