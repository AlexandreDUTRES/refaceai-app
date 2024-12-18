import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_localization/easy_localization.dart';
import 'package:photogenerator/global_localization/utils.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/models/model.dart';
import 'package:photogenerator/models/model_category.dart';
import 'package:photogenerator/pages/home/models/models_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/bloc_manager/models_builder.dart';
import 'package:photogenerator/ui/widgets/model_preview.dart';
import 'package:photogenerator/ui/widgets/static_grid.dart';
import 'package:photogenerator/utils/Common.dart';

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
    final int maxModels = min(6, category.modelsCnt);
    final List<Model> _models = [
      ...category.topModels,
      ...category.randomOthersModels
    ].sublist(0, maxModels);

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
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    if (category.id == 'trends') ...[
                      Color(0xffe6c619),
                      Color(0xffe6c619).withOpacity(0.2),
                    ] else ...[
                      _appTheme.palette.primaryColor,
                      _appTheme.palette.borderColor.withOpacity(0.2),
                    ]
                  ],
                ),
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        category.name(
                            getGlobalLocale(GlobalNavigator().currentContext)),
                        style: _appTheme.fonts.xsTitle.semibold.style,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (maxModels < category.modelsCnt) ...[
                    Padding(padding: EdgeInsets.only(right: 10.sp)),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6.sp),
                      child: Text(
                        tr(
                          "pages.home.models.btn_see_all",
                          namedArgs: {
                            "modelsCnt": category.modelsCnt.toString()
                          },
                        ),
                        style: _appTheme.fonts.xsBody.semibold.style
                            .copyWith(fontSize: 11.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 7.sp)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.sp),
            child: StaticGrid(
              columnCount: 3,
              verticalGap: 5.sp,
              horizontalGap: 5.sp,
              children: _models
                  .map(
                    (model) => LayoutBuilder(
                      builder: (context, constraints) => ModelPreview(
                        model: model,
                        width: constraints.maxWidth,
                        onTap: () async => await Common.goToModelPage(model),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.sp),
      width: double.infinity,
      child: ModelBuilder((categories) {
        List<Widget> children = [];
        for (ModelCategory category in categories) {
          if (children.isNotEmpty)
            children.add(Padding(padding: EdgeInsets.only(top: 14.sp)));
          children.add(_buildCategoryContainer(category));
        }
        return Column(
          children: children,
        );
      }),
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
