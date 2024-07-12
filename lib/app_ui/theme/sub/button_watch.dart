library button_watch;

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/theme/theme_palette.dart';

class ButtonWatch {
  final ButtonStyle _primary;
  final ThemePalette _palette;

  const ButtonWatch(
    ButtonStyle primary,
    ThemePalette palette,
  )   : _primary = primary,
        _palette = palette;

  ButtonStyle get style => _primary;

  ButtonWatch get darkFont => ButtonWatch(
        _primary.copyWith(
          foregroundColor: MaterialStatePropertyAll<Color>(_palette.textColor),
        ),
        _palette,
      );


  ButtonWatch get noHorizontalPadding => ButtonWatch(
        _primary.copyWith(
          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
              horizontal: 0,
              vertical: _primary.padding!
                  .resolve(MaterialState.values.toSet())!
                  .vertical,
            ),
          ),
        ),
        _palette,
      );

  ButtonWatch get noVerticalPadding => ButtonWatch(
        _primary.copyWith(
          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
              vertical: 0,
              horizontal: _primary.padding!
                  .resolve(MaterialState.values.toSet())!
                  .horizontal,
            ),
          ),
        ),
        _palette,
      );

  ButtonWatch setFontSize(double fontSize) => ButtonWatch(
        _primary.copyWith(
          textStyle: MaterialStateProperty.all<TextStyle>(
            _primary.textStyle!.resolve(MaterialState.values.toSet())!.copyWith(
                  fontSize: fontSize,
                ),
          ),
        ),
        _palette,
      );
}
