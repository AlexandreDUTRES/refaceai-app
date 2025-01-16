import 'dart:convert';

import 'package:flutter/material.dart';

String _extractLocaleValue(Map<String, String> map, Locale locale) {
  String languageCode = locale.languageCode;
  if (!map.containsKey(languageCode)) return "";
  return map[languageCode]!;
}

enum ModelType {
  basic,
  premium_ad;

  static ModelType fromString(String value) {
    return ModelType.values.firstWhere((e) => e.name == value);
  }
}

class Model {
  String _id;
  List<String> _images;
  Map<String, String> _name;
  ModelType _type;
  bool _owned;

  Model({
    required String id,
    required List<String> images,
    required Map<String, String> name,
    required ModelType type,
    required bool owned,
  })  : _id = id,
        _images = images,
        _name = name,
        _type = type,
        _owned = owned;

  String get id => _id;
  List<String> get randomImages => _images..shuffle();
  String name(Locale locale) => _extractLocaleValue(_name, locale);
  ModelType get type => _type;
  bool get owned => _owned;

  factory Model.fromMap(Map data) {
    return Model(
      id: data["id"],
      images: List<String>.from(data["images"]),
      name: Map<String, String>.from(data["name"]),
      type: data.containsKey("type")
          ? ModelType.fromString(data["type"])
          : ModelType.basic,
      owned: data["owned"],
    );
  }

  Map toMap() => {
        "id": _id,
        "images": _images,
        "name": _name,
        "type": _type.name,
        "owned": _owned,
      };

  @override
  String toString() {
    return json.encode(toMap());
  }
}
