import 'package:photogenerator/bloc_utils/bloc.dart';

class EmptyData {}

class EmptyBloc extends Bloc<EmptyData> {
  EmptyBloc() : super(EmptyData());

  void voidMethod() {}
}
