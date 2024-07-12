
import 'package:flutter/material.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/bloc_data/model_bloc_data.dart';
import 'package:photogenerator/models/model_category.dart';

class ModelBuilder extends StatelessWidget {
  final Widget Function(List<ModelCategory>) builder;
  final Widget? placeHolder;

  ModelBuilder(this.builder, {this.placeHolder});

  Widget get _placeHolder => placeHolder ?? Container();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ModelBlocData>(
      stream: blocManager.modelBloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _placeHolder;
        return builder(snapshot.data!.categories);
      },
    );
  }
}
