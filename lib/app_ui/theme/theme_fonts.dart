library theme_fonts;

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/theme/sub/font_watch.dart';
import 'package:photogenerator/app_ui/theme/theme_palette.dart';

class ThemeFonts extends ThemeExtension<ThemeFonts> {
  final ThemePalette _palette;
  final double _sp;

  late FontSwatch _body;
  late FontSwatch _sBody;
  late FontSwatch _xsBody;
  late FontSwatch _xxsBody;

  late FontSwatch _lTitle;
  late FontSwatch _title;
  late FontSwatch _sTitle;
  late FontSwatch _xsTitle;

  late FontSwatch _textField;

  ThemeFonts(ThemePalette palette, double sp)
      : _palette = palette,
        _sp = sp {
    _generateTextStyles();
  }

  FontSwatch get body => _body;
  FontSwatch get sBody => _sBody;
  FontSwatch get lTitle => _lTitle;
  FontSwatch get title => _title;
  FontSwatch get sTitle => _sTitle;
  FontSwatch get xsTitle => _xsTitle;
  FontSwatch get xsBody => _xsBody;
  FontSwatch get xxsBody => _xxsBody;

  FontSwatch get textField => _textField;

  @override
  ThemeExtension<ThemeFonts> copyWith() => this;

  @override
  ThemeExtension<ThemeFonts> lerp(
    covariant ThemeExtension<ThemeFonts>? other,
    double t,
  ) {
    if (other is! ThemeFonts) {
      return this;
    } else {
      return other;
    }
  }

  void _generateTextStyles() {
    _body = _createStyle(
      size: 16,
      height: 22.4,
    );
    _sBody = _createStyle(
      size: 14,
      height: 20,
    );
    _xsBody = _createStyle(
      size: 12,
      height: 16,
    );
    _xxsBody = _createStyle(
      size: 9,
      height: 12,
    );
    _lTitle = _createStyle(
      size: 28,
      height: 32,
    );
    _title = _createStyle(
      size: 25,
      height: 32,
    );
    _sTitle = _createStyle(
      size: 20,
      height: 28,
    );
    _xsTitle = _createStyle(
      size: 18,
      height: 24,
    );
    
    _textField = _createStyle(
      size: 16,
      height: 16,
    );
  }

  FontSwatch _createStyle({
    required double size,
    required double height,
  }) {
    return FontSwatch(
      TextStyle(
        fontFamily: 'Roboto',
        fontSize: size * _sp,
        height: height / size,
        color: _palette.textColor,
      ),
      _palette,
    );
  }
}
