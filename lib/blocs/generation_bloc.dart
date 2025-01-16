library verifiable_credential_digest_bloc;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:photogenerator/bloc_utils/bloc_rx.dart';
import 'package:photogenerator/models/bloc_data/generation_bloc_data.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/utils/Api.dart';
import 'package:photogenerator/utils/Common.dart';

class GenerationBloc extends BlocRx<GenerationBlocData> {
  GenerationBloc() {
    initialize(GenerationBlocData());
  }

  void resetData() {
    blocData!.generations = [];
    updateUI();
  }

  Future<void> refresh(String userId) async {
    try {
      blocData!.generations = await Api.getGenerations(userId);
      updateUI();
    } catch (e) {
      if (kDebugMode) print(e);
      Common.showSnackbar();
    }
  }

  Future<Generation> retreiveGenerationById(String generationId) async {
    Generation generation = await Api.getGeneration(
      generationId,
    );

    blocData!.generations.add(generation);
    updateUI();

    return generation;
  }

  Future<Generation> reviewGeneration(
    String userId,
    String generationId,
    int rating,
  ) async {
    await Api.reviewGeneration(
      userId,
      generationId: generationId,
      rating: rating,
    );

    final int index = blocData!.generations
        .indexWhere((Generation g) => g.id == generationId);
    if (index != -1) {
      blocData!.generations[index].setRating(rating);
      updateUI();
      return blocData!.generations[index];
    } else {
      throw "Generation not found";
    }
  }

  Future<void> deleteGeneration(
    String userId, {
    required Generation generation,
  }) async {
    int index = blocData!.generations.indexWhere((c) => c.id == generation.id);
    if (index == -1) return;

    await Api.deleteGeneration(
      userId,
      generationId: generation.id,
    );
    blocData!.generations.removeAt(index);
    updateUI();
  }
}
