import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/models/model.dart';
import 'package:photogenerator/ui/widgets/dynamic_network_images.dart';
import 'package:photogenerator/ui/widgets/random_shimmer.dart';

// ignore: must_be_immutable
class ModelPreview extends StatelessWidget {
  late AppThemeV2 _appTheme;

  ModelPreview({
    Key? key,
    required this.model,
    required this.width,
    required this.onTap,
  }) : super(key: key);

  final Model model;
  final double width;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    _appTheme = AppThemeV2.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: width,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width / 10),
        ),
        child: RandomShimmer(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              DynamicNetworkImages(
                urls: model.randomImages,
                width: width,
                height: width,
              ),
              Container(
                height: width / 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Container(
                width: width,
                padding: EdgeInsets.symmetric(
                  vertical: width / 25,
                  horizontal: width / 15,
                ),
                child: Text(
                  model.name(Locale("fr")),
                  style: _appTheme.fonts.body.semibold.style.copyWith(
                    fontSize: width / 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
