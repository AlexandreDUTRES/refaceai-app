library font_style;

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/theme/theme_palette.dart';

class FontSwatch {
  final TextStyle _primary;
  final ThemePalette _palette;

  const FontSwatch(
    TextStyle primary,
    ThemePalette palette,
  )   : _primary = primary,
        _palette = palette;

  TextStyle get style => _primary;
  double get lineHeight => style.height! * style.fontSize!;

  FontSwatch get primary =>
      FontSwatch(_primary.copyWith(color: _palette.primaryColor), _palette);
  FontSwatch get secondary =>
      FontSwatch(_primary.copyWith(color: _palette.secondaryColor), _palette);
  FontSwatch get background =>
      FontSwatch(_primary.copyWith(color: _palette.backgroundColor), _palette);

  FontSwatch get thin =>
      FontSwatch(_primary.copyWith(fontWeight: FontWeight.w300), _palette);
  FontSwatch get normal =>
      FontSwatch(_primary.copyWith(fontWeight: FontWeight.w400), _palette);
  FontSwatch get semibold =>
      FontSwatch(_primary.copyWith(fontWeight: FontWeight.w500), _palette);
  FontSwatch get bold =>
      FontSwatch(_primary.copyWith(fontWeight: FontWeight.w700), _palette);
  FontSwatch get black =>
      FontSwatch(_primary.copyWith(fontWeight: FontWeight.w900), _palette);

  FontSwatch get italic =>
      FontSwatch(_primary.copyWith(fontStyle: FontStyle.italic), _palette);

  FontSwatch get underline => FontSwatch(
      _primary.copyWith(decoration: TextDecoration.underline), _palette);
  FontSwatch get noDecoration =>
      FontSwatch(_primary.copyWith(decoration: TextDecoration.none), _palette);
  FontSwatch get noHeight => FontSwatch(_primary.copyWith(height: 1), _palette);
  FontSwatch get smallHeight =>
      FontSwatch(_primary.copyWith(height: 1.1), _palette);
}
