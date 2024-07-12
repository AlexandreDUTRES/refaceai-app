import 'package:photogenerator/bloc_utils/bloc.dart';
import 'package:photogenerator/models/model_category.dart';

class CategoryPageData {}

class CategoryPageBloc extends Bloc<CategoryPageData> {
  late ModelCategory _category;

  CategoryPageBloc(Map<String, dynamic> args) : super(CategoryPageData()) {
    assert(args.containsKey("category") && args["category"] is ModelCategory);
    _category = args["category"];
  }

  ModelCategory get category => _category;
}
