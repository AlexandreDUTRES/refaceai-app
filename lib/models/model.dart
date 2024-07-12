import 'dart:convert';

import 'package:flutter/material.dart';

String _extractLocaleValue(Map<String, String> map, Locale locale) {
  String languageCode = locale.languageCode;
  if (!map.containsKey(languageCode)) return "";
  return map[languageCode]!;
}

class Model {
  String _id;
  List<String> _images;
  Map<String, String> _name;

  Model({
    required String id,
    required List<String> images,
    required Map<String, String> name,
  })  : _id = id,
        _images = images,
        _name = name;

  String get id => _id;
  List<String> get randomImages => _images..shuffle();
  String name(Locale locale) => _extractLocaleValue(_name, locale);

  factory Model.fromMap(Map data) {
    return Model(
      id: data["id"],
      images: List<String>.from(data["images"]),
      name: Map<String, String>.from(data["name"]),
    );
  }

  Map toMap() => {
        "id": _id,
        "images": _images,
        "name": _name,
      };

  @override
  String toString() {
    return json.encode(toMap());
  }
}
