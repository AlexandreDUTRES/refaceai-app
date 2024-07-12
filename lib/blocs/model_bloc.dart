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

  Future<void> refresh() async {
    try {
      blocData!.categories = await Api.getModelCategories();
      updateUI();
    } catch (e) {
      if (kDebugMode) print(e);
      Common.showSnackbar();
    }
  }
}
