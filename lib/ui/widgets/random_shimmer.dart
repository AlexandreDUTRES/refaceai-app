library random_shimmer;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RandomShimmer extends StatefulWidget {
  const RandomShimmer({
    Key? key,
    required this.child,
    this.noStartDelayed = false,
  }) : super(key: key);

  final Widget child;
  final bool noStartDelayed;
  @override
  RandomShimmerState createState() => RandomShimmerState();
}

class RandomShimmerState extends State<RandomShimmer> {
  final _random = new Random();
  bool _isShimmering = false;

  late Duration _startDelayed;
  late Duration _animationDuration;
  late Duration _intervalDuration;

  @override
  void initState() {
    super.initState();
    _startDelayed = Duration(milliseconds: _random.nextInt(8000));
    _animationDuration = Duration(milliseconds: 2500 + _random.nextInt(1000));
    _intervalDuration = Duration(milliseconds: 2000 + _random.nextInt(3000));

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (!widget.noStartDelayed) await Future.delayed(_startDelayed);
        _setIsShimmering(true);
      },
    );
  }

  void _setIsShimmering(bool v) {
    if (!mounted) return;
    setState(() {
      _isShimmering = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShimmering) return widget.child;

    return Shimmer(
      duration: _animationDuration,
      interval: _intervalDuration,
      child: widget.child,
    );
  }
}
