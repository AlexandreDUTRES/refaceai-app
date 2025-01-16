import 'package:flutter/material.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/bloc_data/generation_bloc_data.dart';
import 'package:photogenerator/models/generation.dart';

class GenerationBuilder extends StatelessWidget {
  final Widget Function(Generation) builder;
  final String generationId;
  final Widget? placeHolder;

  GenerationBuilder(
    this.builder, {
    required this.generationId,
    this.placeHolder,
  });

  Widget get _placeHolder => placeHolder ?? Container();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenerationBlocData>(
      stream: blocManager.generationBloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _placeHolder;
        final generation = snapshot.data!.generations.firstWhere((g) => g.id == generationId);
        return builder(generation);
      },
    );
  }
}
