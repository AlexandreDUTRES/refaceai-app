library app_theme_v2;

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/theme/theme_buttons.dart';
import 'package:photogenerator/app_ui/theme/theme_fonts.dart';
import 'package:photogenerator/app_ui/theme/theme_palette.dart';

class AppThemeV2 {
  final ThemeData _data;
  final ThemePalette _palette;
  final ThemeFonts _fonts;
  final ThemeButtons _buttons;

  AppThemeV2(
    ThemeData data,
  )   : _data = data,
        _palette = data.extension<ThemePalette>()!,
        _fonts = data.extension<ThemeFonts>()!,
        _buttons = data.extension<ThemeButtons>()!;

  ThemeData get data => _data;
  ThemeFonts get fonts => _fonts;
  ThemePalette get palette => _palette;
  ThemeButtons get buttons => _buttons;

  factory AppThemeV2.of(BuildContext context) {
    return AppThemeV2(Theme.of(context));
  }
}
