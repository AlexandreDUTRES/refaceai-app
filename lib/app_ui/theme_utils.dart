library theme_utils;

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/theme/theme_buttons.dart';
import 'package:photogenerator/app_ui/theme/theme_fonts.dart';
import 'package:photogenerator/app_ui/theme/theme_palette.dart';

class ThemeUtils {
  static ThemeData buildThemeData({
    required int id,
    required ThemePalette palette,
    required double sp,
  }) {
    return ThemeData(
      fontFamily: 'Roboto',
      extensions: [
        palette,
        ThemeFonts(palette, sp),
        ThemeButtons(palette, sp),
      ],
      primaryColor: palette.primaryColor,
      checkboxTheme: _getCheckboxTheme(palette, sp),
      inputDecorationTheme: _getInputDecorationTheme(palette, sp),
      tooltipTheme: _getToolTipTheme(palette, sp),
    );
  }

  static InputDecorationTheme _getInputDecorationTheme(
    ThemePalette palette,
    double sp,
  ) {
    return InputDecorationTheme(
      alignLabelWithHint: true,
      filled: true,
      fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return palette.backgroundColor;
        }
        return palette.backgroundColor;
      }),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1 * sp,
          color: palette.primaryColor,
        ),
        borderRadius: BorderRadius.circular(8 * sp),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1 * sp,
          color: palette.borderColor,
        ),
        borderRadius: BorderRadius.circular(8 * sp),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1 * sp,
          color: palette.borderColor,
        ),
        borderRadius: BorderRadius.circular(8 * sp),
      ),
      contentPadding:
          EdgeInsets.symmetric(horizontal: 20 * sp, vertical: 20 * sp),
    );
  }

  static CheckboxThemeData _getCheckboxTheme(
    ThemePalette palette,
    double sp,
  ) {
    return CheckboxThemeData(
      fillColor: WidgetStateColor.resolveWith((s) {
        if (s.contains(WidgetState.selected)) return palette.primaryColor;
        return palette.backgroundColor;
      }),
      side: BorderSide(
        color: palette.borderColor,
        width: 2 * sp,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3 * sp),
      ),
      checkColor: WidgetStatePropertyAll(palette.backgroundColor),
      visualDensity: VisualDensity.compact,
    );
  }

  static TooltipThemeData _getToolTipTheme(
    ThemePalette palette,
    double sp,
  ) {
    return TooltipThemeData(
      padding: EdgeInsets.symmetric(horizontal: 16 * sp, vertical: 8 * sp),
      textStyle: TextStyle(fontSize: 12 * sp, color: palette.backgroundColor),
      decoration: BoxDecoration(
          color: palette.textColor,
          borderRadius: BorderRadius.circular(5 * sp)),
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 100),
    );
  }
}
