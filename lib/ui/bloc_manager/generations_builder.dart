import 'package:flutter/material.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/bloc_data/generation_bloc_data.dart';
import 'package:photogenerator/models/generation.dart';

class GenerationsBuilder extends StatelessWidget {
  final Widget Function(List<Generation>) builder;
  final Widget? placeHolder;

  GenerationsBuilder(this.builder, {this.placeHolder});

  Widget get _placeHolder => placeHolder ?? Container();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenerationBlocData>(
      stream: blocManager.generationBloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _placeHolder;
        return builder(snapshot.data!.sortedGenerations);
      },
    );
  }
}
