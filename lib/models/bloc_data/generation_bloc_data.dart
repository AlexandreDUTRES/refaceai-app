import 'package:photogenerator/models/generation.dart';

class GenerationBlocData {
  List<Generation> generations = [];

  List<Generation> get sortedGenerations {
    List<Generation> sortedGenerations = [...generations];
    sortedGenerations
        .sort((a, b) => a.createdTimestamp < b.createdTimestamp ? 1 : -1);
    return sortedGenerations;
  }
}
