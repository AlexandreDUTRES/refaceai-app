import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';

class DynamicNetworkImages extends StatefulWidget {
  const DynamicNetworkImages({
    Key? key,
    required this.urls,
    required this.width,
    required this.height,
    this.animate = true,
  }) : super(key: key);

  final List<String> urls;
  final double width;
  final double height;
  final bool animate;
  @override
  DynamicNetworkImagesState createState() => DynamicNetworkImagesState();
}

class DynamicNetworkImagesState extends State<DynamicNetworkImages> {
  final PreloadPageController _controller = PreloadPageController();
  final _random = new Random();

  Timer? _startTimer;
  Timer? _animationTimer;

  int _currentPage = 0;
  bool _reverse = false;
  Future<void> _goToNextPage() async {
    int nextPage = !_reverse ? _currentPage + 1 : _currentPage - 1;
    if (nextPage >= widget.urls.length) _reverse = true;
    if (nextPage < 0) _reverse = false;

    if (!_reverse)
      await _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    else
      await _controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
  }

  @override
  void initState() {
    super.initState();

    if (!widget.animate || widget.urls.length < 2) return;

    Duration startDelayed = Duration(milliseconds: _random.nextInt(8000));
    Duration animationDuration =
        Duration(milliseconds: 5000 + _random.nextInt(3000));

    _startTimer = Timer(startDelayed, () async {
      await _goToNextPage;
      _animationTimer = Timer.periodic(animationDuration, (_) async {
        await _goToNextPage();
      });
    });
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _animationTimer?.cancel();
    super.dispose();
  }

  Widget _buildImage(String url) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.white.withOpacity(0.1),
      child: PreloadPageView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.urls.length,
        itemBuilder: (context, index) => _buildImage(widget.urls[index]),
        preloadPagesCount: widget.urls.length,
        controller: _controller,
        onPageChanged: (i) => _currentPage = i,
      ),
    );
  }
}
