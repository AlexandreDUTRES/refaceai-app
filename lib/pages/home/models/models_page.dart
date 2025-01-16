import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_localization/utils.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/models/model.dart';
import 'package:photogenerator/models/model_category.dart';
import 'package:photogenerator/pages/home/models/models_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/bloc_manager/models_builder.dart';
import 'package:photogenerator/ui/widgets/model_preview.dart';
import 'package:photogenerator/utils/Common.dart';
import 'package:styled_widget/styled_widget.dart';

// ignore: must_be_immutable
class ModelsPage extends StatelessWidget {
  late ModelsPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildIconContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 35.sp,
            width: 4 * 35.sp,
            child: CustomSvgs.logo__logo_txt.build(
              size: 1.sp,
              color: _appTheme.palette.textColor,
              noWidth: true,
              noHeight: true,
            ),
          ),
          GestureDetector(
            onTap: bloc.goToSettingsPage,
            child: Container(
              height: 35.sp,
              width: 35.sp,
              color: Colors.transparent,
              child: Icon(
                Icons.settings,
                color: _appTheme.palette.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContainer(ModelCategory category) {
    final List<Model> _models = [
      ...category.topModels,
      ...category.randomOthersModels
    ].take(4).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async => await bloc.goToCategoryPage(category),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 2.sp),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(category.banner),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Text(
                category
                    .name(getGlobalLocale(GlobalNavigator().currentContext)),
                style: _appTheme.fonts.body.semibold.style.copyWith(
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black.withValues(alpha:0.3),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 7.sp)),
          Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                child: Row(
                  children: List.generate(
                    _models.length,
                    (index) => ModelPreview(
                      model: _models[index],
                      width: 0.24.sw,
                      onTap: () async =>
                          await Common.goToModelPage(_models[index]),
                    ).padding(
                      left: index == 0 ? 0 : 4.sp,
                      right: index == _models.length - 1 ? 0 : 4.sp,
                    ),
                  ).toList(),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 0.24.sw,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha:0.1),
                        Colors.black,
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha:0.9),
                    size: 40.sp,
                  ).padding(all: 3.sp).padding(left: 30.sp),
                ).gestures(
                  onTap: () async => await bloc.goToCategoryPage(category),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.sp),
      width: double.infinity,
      child: ModelsBuilder(
        (categories) {
          List<Widget> children = [];
          for (ModelCategory category in categories) {
            if (children.isNotEmpty)
              children.add(Padding(padding: EdgeInsets.only(top: 16.sp)));
            children.add(_buildCategoryContainer(category));
          }
          return Column(
            children: children,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ModelsPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 20.sp)),
            _buildIconContainer(),
            Padding(padding: EdgeInsets.only(top: 10.sp)),
            _buildCategoriesList(),
            Padding(padding: EdgeInsets.only(top: 15.sp)),
          ],
        ),
      ),
    );
  }
}
