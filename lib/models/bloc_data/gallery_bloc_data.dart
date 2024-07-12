import 'dart:io';

class GalleryBlocData {
  List<File> files = [];

  List<File> get sortedFiles {
    RegExp regExp = RegExp(r"(media_)(.*)(\.jpg)");

    List<File> sortedFiles = [...files];
    sortedFiles.sort((a, b) {
      int t1 = DateTime.parse(regExp.firstMatch(a.path)!.group(2)!)
          .millisecondsSinceEpoch;
      int t2 = DateTime.parse(regExp.firstMatch(b.path)!.group(2)!)
          .millisecondsSinceEpoch;
      return t1 < t2 ? 1 : -1;
    });
    return sortedFiles;
  }
}
