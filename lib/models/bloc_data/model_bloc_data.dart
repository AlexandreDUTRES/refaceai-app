import 'package:photogenerator/models/model_category.dart';

import '../model.dart';

class ModelBlocData {
  List<ModelCategory> categories = [];

  List<Model> get allModels {
    List<Model> res = [];
    for (ModelCategory cat in categories) {
      res.addAll(cat.models);
    }
    return res;
  }
}
