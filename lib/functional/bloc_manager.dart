import 'package:photogenerator/blocs/gallery_bloc.dart';
import 'package:photogenerator/blocs/generation_bloc.dart';
import 'package:photogenerator/blocs/model_bloc.dart';
import 'package:photogenerator/blocs/user_bloc.dart';

class BlocManager {
  void initializeAllBlocs() {
    _initUserBloc();
    _initGenerationBloc();
    _initGalleryBloc();
    _initModelBloc();
  }

  Future<void> disposeAllBlocs() async {
    await Future.wait([
      _disposeUserBloc(),
      _disposeGenerationBloc(),
      _disposeGalleryBloc(),
      _disposeModelBloc(),
    ]);
  }

  // USER BLOC
  late UserBloc _userBloc;
  UserBloc get userBloc => _userBloc;
  void _initUserBloc() {
    _userBloc = UserBloc();
  }

  Future<void> _disposeUserBloc() async {
    await _userBloc.waitTillListenerAndDispose();
  }

  // GENERATION BLOC
  late GenerationBloc _generationBloc;
  GenerationBloc get generationBloc => _generationBloc;
  void _initGenerationBloc() {
    _generationBloc = GenerationBloc();
  }

  Future<void> _disposeGenerationBloc() async {
    await _generationBloc.waitTillListenerAndDispose();
  }

  // GENERATION BLOC
  late GalleryBloc _galleryBloc;
  GalleryBloc get galleryBloc => _galleryBloc;
  void _initGalleryBloc() {
    _galleryBloc = GalleryBloc();
  }

  Future<void> _disposeGalleryBloc() async {
    await _galleryBloc.waitTillListenerAndDispose();
  }

  // GENERATION BLOC
  late ModelBloc _modelBloc;
  ModelBloc get modelBloc => _modelBloc;
  void _initModelBloc() {
    _modelBloc = ModelBloc();
  }

  Future<void> _disposeModelBloc() async {
    await _modelBloc.waitTillListenerAndDispose();
  }
}
