import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/screenutil.dart';
import 'package:photogenerator/app_ui/theme/app_theme_v2.dart';
import 'package:photogenerator/global_localization/utils.dart';
import 'package:photogenerator/global_navigator/global_navigator.dart';
import 'package:photogenerator/pages/category/category_page_bloc.dart';
import 'package:photogenerator/bloc_utils/bloc_provider.dart';
import 'package:photogenerator/ui/widgets/model_preview.dart';
import 'package:photogenerator/ui/widgets/page_layout.dart';
import 'package:photogenerator/ui/widgets/page_top_bar.dart';
import 'package:photogenerator/ui/widgets/static_grid.dart';
import 'package:photogenerator/utils/Common.dart';

// ignore: must_be_immutable
class CategoryPage extends StatelessWidget {
  late CategoryPageBloc bloc;
  late AppThemeV2 _appTheme;

  Widget _buildModelsList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      width: double.infinity,
      child: StaticGrid(
        columnCount: 3,
        verticalGap: 5.sp,
        horizontalGap: 5.sp,
        children: bloc.category.models
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
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<CategoryPageBloc>(context);
    _appTheme = AppThemeV2.of(context);

    final ScrollController customScrollController = ScrollController();

    return PageLayout(
      mainScrollController: customScrollController,
      backgroundColor: _appTheme.palette.backgroundColor,
      bodyBuilder: (
        BuildContext context,
        BoxConstraints constraints,
        double topPadding,
        double bottomPadding,
      ) {
        return SingleChildScrollView(
          controller: customScrollController,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: topPadding)),
              PageTopBar(
                backButton: true,
                title: bloc.category
                    .name(getGlobalLocale(GlobalNavigator().currentContext)),
              ),
              Padding(padding: EdgeInsets.only(top: 5.sp)),
              _buildModelsList(),
              Padding(padding: EdgeInsets.only(top: bottomPadding + 15.sp)),
            ],
          ),
        );
      },
    );
  }
}
