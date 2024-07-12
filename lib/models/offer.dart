import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';

class Offer {
  String _id;
  String? _bannerText;
  Color? _bannerColor;
  CustomPngs _illustration;
  double _price;
  int _credits;
  int _bonus;

  Offer({
    required String id,
    required String? bannerText,
    required Color? bannerColor,
    required CustomPngs illustration,
    required double price,
    required int credits,
    required int bonus,
  })  : _id = id,
        _bannerText = bannerText,
        _bannerColor = bannerColor,
        _illustration = illustration,
        _price = price,
        _credits = credits,
        _bonus = bonus;

  bool get hasBanner => _bannerColor != null && _bannerText != null;

  String get id => _id;
  String? get bannerText => _bannerText;
  Color? get bannerColor => _bannerColor;
  CustomPngs get illustration => _illustration;
  double get price => _price;
  int get credits => _credits;
  int get bonus => _bonus;
}
