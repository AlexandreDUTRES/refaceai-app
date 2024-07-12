library responsive_keyboard_sized_container;

import 'package:flutter/material.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/utils.dart';

class ResponsiveKeyboardSizedContainer extends StatelessWidget {
  final double offset;

  const ResponsiveKeyboardSizedContainer({
    Key? key,
    this.offset = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardAware(builder: (context, keyboardConfig) {
      if (keyboardConfig.isKeyboardOpen) {
        double height = keyboardConfig.keyboardHeight - offset;
        if (isIOS) height -= SizerHandler.bottomBarHeight;
        return SizedBox(
          width: double.infinity,
          height: height,
        );
      } else {
        return Container();
      }
    });
  }
}