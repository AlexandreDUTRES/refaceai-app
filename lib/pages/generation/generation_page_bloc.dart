import 'dart:io';
import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photogenerator/app_ui/loader_utils.dart';
import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/functional/AppReview.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/v4.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class GenerationPageData {}

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
  }

  List<Generation> get generations => _generations;

  void setIndex(int v) {
    _index = v;
  }

  Future<String> _downloadImage(Generation generation) async {
    final response = await http.get(Uri.parse(generation.url));
    if (response.statusCode != 200) throw "null";

    Uint8List webpImage = response.bodyBytes;
    img.Image? decodedImage = img.decodeWebP(webpImage);
    if (decodedImage == null) throw "null";
    Uint8List jpgImage = Uint8List.fromList(img.encodeJpg(decodedImage));

    // Save to gallery
    final result = await ImageGallerySaver.saveImage(
      jpgImage,
      quality: 100,
      name: UuidV4().generate(),
    );
    if (result == null || result['isSuccess'] != true) {
      throw "Failed to save to gallery";
    }

    return result['filePath'];
  }

  Future<void> locallySaveImage() async {
    await GlobalLoader.showOverlayLoader();
    try {
      await _downloadImage(_generations[_index]);
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
      final response = await http.get(Uri.parse((_generations[_index].url)));
      if (response.statusCode != 200) throw "null";

      Uint8List webpImage = response.bodyBytes;
      img.Image? decodedImage = img.decodeWebP(webpImage);
      if (decodedImage == null) throw "null";
      Uint8List jpgImage = Uint8List.fromList(img.encodeJpg(decodedImage));

      final directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/${UuidV4().generate()}.jpg';

      File file = File(filePath);
      await file.writeAsBytes(jpgImage);
      GlobalLoader.hideOverlayLoader();

      await Share.shareXFiles(
        [XFile(file.path)],
        text: tr("pages.generation.share_msg"),
      );
    } catch (_) {
      GlobalLoader.hideOverlayLoader();
      Common.showSnackbar();
    }
  }

  Future<void> review(int rating) async {
    await GlobalLoader.showOverlayLoader();
    try {
      await blocManager.generationBloc.reviewGeneration(
        blocManager.userBloc.userId!,
        _generations[_index].id,
        rating,
      );
      GlobalLoader.hideOverlayLoader();
      Common.showSnackbar(tr("pages.generation.snackbar_review_sent"));
    } catch (_) {
      GlobalLoader.hideOverlayLoader();
      Common.showSnackbar();
    }
    if (rating == 5) {
      await AppReview.requestReview();
    }
  }

  Future<void> goToDeleteGenerationModal() async {
    await GlobalNavigator().navigate("/DeleteGenerationModal", args: {
      "generation": _generations[_index],
    });
  }

  Future<void> goToModelPage() async {
    await Common.goToModelPage(
      blocManager.modelBloc.blocData!.allModels
          .firstWhere((e) => e.id == _generations[_index].promptId),
      true,
    );
  }
}
