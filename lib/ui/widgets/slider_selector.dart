library mic_button;

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';

class SliderSelector extends StatefulWidget {
  SliderSelector({
    Key? key,
    required this.width,
    required this.initialValue,
    required this.leftText,
    required this.rightText,
    required this.reversed,
  }) : super(key: key);

  final double width;
  final int initialValue;
  final String leftText;
  final String rightText;
  final bool reversed;

  @override
  SliderSelectorState createState() => SliderSelectorState();
}

class SliderSelectorState extends State<SliderSelector> {
  late AppThemeV2 _appTheme;
  final int _maxValue = 5;
  final int _minValue = 1;

  late int _value;

  int get current =>
      !widget.reversed ? _value : (_maxValue + _minValue - _value);

  void _setValue(int v) {
    if (!mounted) return;
    setState(() {
      _value = v;
    });
  }

  @override
  void initState() {
    super.initState();
    _value = !widget.reversed
        ? widget.initialValue
        : (_maxValue + _minValue - widget.initialValue);
    if (_value > _maxValue) _value = _maxValue;
    if (_value < _minValue) _value = _minValue;
  }

  Widget _buildSlider() {
    return Container(
      width: widget.width * 0.5,
      child: Slider(
        value: _value.toDouble(),
        max: _maxValue.toDouble(),
        min: _minValue.toDouble(),
        divisions: _maxValue - _minValue,
        onChanged: (v) => _setValue(v.round()),
        inactiveColor: _appTheme.palette.borderColor,
        activeColor: _appTheme.palette.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppThemeV2.of(context);

    return Container(
      width: widget.width,
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Text(
                widget.leftText,
                textAlign: TextAlign.end,
                style: _appTheme.fonts.xsBody.style,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          _buildSlider(),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Text(
                widget.rightText,
                style: _appTheme.fonts.xsBody.style,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
