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

    final double? borderSize =
        model.type != ModelType.premium_ad ? null : width / 80;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width / 10),
          gradient: borderSize != null
              ? LinearGradient(
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFB8860B),
                    Color(0xFFDAA520),
                    Color(0xFFFCC200),
                    Color(0xFFFFD700),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: borderSize != null
              ? Border.all(color: Colors.transparent, width: borderSize)
              : null,
          shape: BoxShape.rectangle,
        ),
        child: Container(
          width: width,
          height: width,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular((width / 10) - (borderSize ?? 0)),
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
                        Colors.black.withValues(alpha: 0.8),
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
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (model.type == ModelType.premium_ad)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.all(width / 30),
                      child: Icon(
                        Icons.auto_awesome,
                        color: Color(0xFFFFD700),
                        size: width / 5.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
