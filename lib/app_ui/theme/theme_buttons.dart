library theme_buttons;

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/theme/sub/button_watch.dart';
import 'package:photogenerator/app_ui/theme/theme_palette.dart';

class ThemeButtons extends ThemeExtension<ThemeButtons> {
  final ThemePalette _palette;
  final double _sp;

  late ButtonWatch _mainElevated;
  late ButtonWatch _smallMainElevated;
  late ButtonWatch _secondaryElevated;
  late ButtonWatch _smallSecondaryElevated;
  late ButtonWatch _borderedElevated;
  late ButtonWatch _smallBorderedElevated;
  late ButtonWatch _mainText;
  late ButtonWatch _textLike;
  late ButtonWatch _smallTextLike;
  late ButtonWatch _bottomElevated;

  ThemeButtons(ThemePalette palette, double sp)
      : _palette = palette,
        _sp = sp {
    _generateButtonStyles();
  }

  ButtonWatch get mainElevated => _mainElevated;
  ButtonWatch get smallMainElevated => _smallMainElevated;
  ButtonWatch get secondaryElevated => _secondaryElevated;
  ButtonWatch get smallSecondaryElevated => _smallSecondaryElevated;
  ButtonWatch get borderedElevated => _borderedElevated;
  ButtonWatch get smallBorderedElevated => _smallBorderedElevated;
  ButtonWatch get mainText => _mainText;
  ButtonWatch get textLike => _textLike;
  ButtonWatch get smallTextLike => _smallTextLike;
  ButtonWatch get bottomElevated => _bottomElevated;

  @override
  ThemeExtension<ThemeButtons> copyWith() => this;

  @override
  ThemeExtension<ThemeButtons> lerp(
    covariant ThemeExtension<ThemeButtons>? other,
    double t,
  ) {
    if (other is! ThemeButtons) {
      return this;
    } else {
      return other;
    }
  }

  void _generateButtonStyles() {
    _mainElevated = _createStyle(
      backgroundColor: _palette.primaryColor,
      textSize: 16,
      textColor: _palette.textColor,
      verticalPadding: 10,
      horizontalPadding: 20,
      borderRadius: 6,
    );
    _smallMainElevated = _createStyle(
      backgroundColor: _palette.primaryColor,
      textSize: 11,
      textColor: _palette.textColor,
      verticalPadding: 10,
      horizontalPadding: 14,
      borderRadius: 6,
    );
    _secondaryElevated = _createStyle(
      backgroundColor: _palette.backgroundColor,
      textSize: 18,
      textColor: _palette.textColor,
      verticalPadding: 15,
      horizontalPadding: 30,
      borderRadius: 8,
    );
    _smallSecondaryElevated = _createStyle(
      backgroundColor: _palette.backgroundColor,
      textSize: 11,
      textColor: _palette.textColor,
      verticalPadding: 10,
      horizontalPadding: 14,
      borderRadius: 6,
    );
    _borderedElevated = _createStyle(
      backgroundColor: Colors.transparent,
      textSize: 18,
      textColor: _palette.textColor,
      verticalPadding: 15,
      horizontalPadding: 30,
      borderRadius: 8,
      borderColor: _palette.textColor,
    );
    _smallBorderedElevated = _createStyle(
      backgroundColor: Colors.transparent,
      textSize: 18,
      textColor: _palette.textColor,
      verticalPadding: 8,
      horizontalPadding: 24,
      borderRadius: 8,
      borderColor: _palette.textColor,
    );
    _mainText = _createStyle(
      backgroundColor: Colors.transparent,
      textSize: 18,
      textColor: _palette.primaryColor,
      verticalPadding: 15,
      horizontalPadding: 30,
    );
    _textLike = _createStyle(
      backgroundColor: Colors.transparent,
      textSize: 16,
      textColor: _palette.primaryColor,
    );
    _smallTextLike = _createStyle(
      backgroundColor: Colors.transparent,
      textSize: 12,
      textColor: _palette.primaryColor,
    );
    _bottomElevated = _createStyle(
      backgroundColor: _palette.textColor.withOpacity(0.8),
      textSize: 18,
      textColor: _palette.textColor,
      verticalPadding: 16,
      horizontalPadding: 10,
    );
  }

  ButtonWatch _createStyle({
    required Color backgroundColor,
    required double textSize,
    required Color textColor,
    FontWeight textWeight = FontWeight.w700,
    double verticalPadding = 0,
    double horizontalPadding = 0,
    double borderRadius = 0,
    Color? borderColor,
  }) {
    return ButtonWatch(
      ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor),
        foregroundColor: MaterialStatePropertyAll<Color>(textColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius * _sp),
          ),
        ),
        side: borderColor != null
            ? MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: borderColor,
                  width: 1 * _sp,
                ),
              )
            : null,
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontFamily: 'Roboto',
            fontSize: textSize * _sp,
            fontWeight: textWeight,
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(
            vertical: verticalPadding * _sp,
            horizontal: horizontalPadding * _sp,
          ),
        ),
        elevation: const MaterialStatePropertyAll<double>(0),
        minimumSize: const MaterialStatePropertyAll<Size>(Size.zero),
      ),
      _palette,
    );
  }
}
