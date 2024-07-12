library theme_palette;

import 'package:flutter/material.dart';

class ThemePalette extends ThemeExtension<ThemePalette> {
  final Color _primaryColor;
  final Color _secondaryColor;
  final Color _textColor;
  final Color _borderColor;
  final Color _backgroundColor;

  final LinearGradient _primaryGradient;

  ThemePalette({
    required Color primaryColor,
    required Color secondaryColor,
    required Color textColor,
    required Color borderColor,
    required Color backgroundColor,
    required LinearGradient primaryGradient,
  })  : _primaryColor = primaryColor,
        _secondaryColor = secondaryColor,
        _textColor = textColor,
        _borderColor = borderColor,
        _backgroundColor = backgroundColor,
        _primaryGradient = primaryGradient;

  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get textColor => _textColor;
  Color get borderColor => _borderColor;
  Color get backgroundColor => _backgroundColor;
  LinearGradient get primaryGradient => _primaryGradient;

  // @override
  // ThemeExtension<ThemePalette> copyWith({
  //   Color? primaryColor,
  //   Color? secondaryColor,
  //   Color? textColor,
  //   Color? borderColor,
  //   Color? backgroundColor,
  //   Color? whiteColor,
  //   Color? successColor,
  //   Color? errorColor,
  //   Color? warningColor,
  //   LinearGradient? primaryGradient,
  //   LinearGradient? darkGradient,
  // }) =>
  //     ThemePalette(
  //       primaryColor: primaryColor ?? this.primaryColor,
  //       secondaryColor: secondaryColor ?? this.secondaryColor,
  //       textColor: textColor ?? this.textColor,
  //       borderColor: borderColor ?? this.borderColor,
  //       backgroundColor: backgroundColor ?? this.backgroundColor,
  //       whiteColor: whiteColor ?? this.whiteColor,
  //       successColor: successColor ?? this.successColor,
  //       errorColor: errorColor ?? this.errorColor,
  //       warningColor: warningColor ?? this.warningColor,
  //       primaryGradient: primaryGradient ?? this.primaryGradient,
  //       darkGradient: darkGradient ?? this.darkGradient,
  //     );

  @override
  ThemeExtension<ThemePalette> copyWith() => this;

  @override
  ThemeExtension<ThemePalette> lerp(
    covariant ThemeExtension<ThemePalette>? other,
    double t,
  ) {
    if (other is! ThemePalette) {
      return this;
    } else {
      return other;
    }
  }
}
