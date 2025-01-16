library model_bloc;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:photogenerator/bloc_utils/bloc_rx.dart';
import 'package:photogenerator/models/bloc_data/model_bloc_data.dart';
import 'package:photogenerator/utils/Api.dart';
import 'package:photogenerator/utils/Common.dart';

class ModelBloc extends BlocRx<ModelBlocData> {
  ModelBloc() {
    initialize(ModelBlocData());
  }

  void resetData() {
    blocData!.categories = [];
    updateUI();
  }

  Future<void> refreshAll(String userId) async {
    try {
      blocData!.categories = await Api.getModelCategories(userId);
      updateUI();
    } catch (e) {
      if (kDebugMode) print(e);
      Common.showSnackbar();
    }
  }

  Future<void> refreshModel(
    String userId,
    String modelId,
  ) async {
    final int indexCategory = blocData!.categories.indexWhere(
      (category) => category.models.any((model) => model.id == modelId),
    );
    if (indexCategory == -1) return;
    try {
      blocData!.categories[indexCategory]
          .replaceModel(await Api.getModel(userId, modelId));
      updateUI();
    } catch (e) {
      if (kDebugMode) print(e);
      Common.showSnackbar();
    }
  }
}
