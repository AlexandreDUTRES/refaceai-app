import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photogenerator/models/model.dart';

String _extractLocaleValue(Map<String, String> map, Locale locale) {
  String languageCode = locale.languageCode;
  if (!map.containsKey(languageCode)) return "";
  return map[languageCode]!;
}

class ModelCategory {
  String _id;
  Map<String, String> _name;
  List<Model> _models;

  ModelCategory({
    required String id,
    required Map<String, String> name,
    required List<Model> models,
  })  : _id = id,
        _name = name,
        _models = models;

  String get id => _id;
  String name(Locale locale) => _extractLocaleValue(_name, locale);
  
  int get modelsCnt => _models.length;
  List<Model> get models => _models;
  List<Model> get topModels => _models.sublist(0, 2);
  List<Model> get randomOthersModels => _models.sublist(2)..shuffle();

  factory ModelCategory.fromMap(Map data) {
    return ModelCategory(
      id: data["id"],
      name: Map<String, String>.from(data["name"]),
      models: List<Model>.from(data["models"].map((m) => Model.fromMap(m))),
    );
  }

  Map toMap() => {
        "id": _id,
        "name": _name,
        "models": _models.map((e) => e.toMap()).toList(),
      };

  @override
  String toString() {
    return json.encode(toMap());
  }
}
