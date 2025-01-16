import 'package:flutter/material.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/bloc_data/model_bloc_data.dart';
import 'package:photogenerator/models/model_category.dart';

class ModelsBuilder extends StatelessWidget {
  final Widget Function(List<ModelCategory>) builder;
  final String? promptId;
  final Widget? placeHolder;

  ModelsBuilder(
    this.builder, {
    this.promptId,
    this.placeHolder,
  });

  Widget get _placeHolder => placeHolder ?? Container();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ModelBlocData>(
      stream: blocManager.modelBloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _placeHolder;
        return builder(
          snapshot.data!.categories
              .where((category) => promptId == null
                  ? true
                  : category.models.any((model) => model.id == promptId))
              .toList(),
        );
      },
    );
  }
}
