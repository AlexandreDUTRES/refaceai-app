library grey_out_container;

import 'package:flutter/material.dart';

class GreyOutContainer extends StatelessWidget {
  const GreyOutContainer({
    Key? key,
    required this.child,
    this.active = true,
  }) : super(key: key);

  final Widget child;
  final bool active;

  Widget _buildOverlayParent(Widget child) {
    return Opacity(
      opacity: 0.6,
      child: ColorFiltered(
        // colorFilter: ColorFilter.mode(
        //   Colors.grey[400]!,
        //   BlendMode.,
        // ),
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0
        ]),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!active) return child;
    return _buildOverlayParent(child);
  }
}
