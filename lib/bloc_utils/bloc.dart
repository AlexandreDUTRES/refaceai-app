library bloc;

import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class Bloc<T> {
  final T blocData;

  late StreamController<T> streamController = BehaviorSubject<T>();
  Sink<T> get sink => streamController.sink;
  Stream<T> get stream => streamController.stream;

  Bloc(this.blocData) {
    updateUI();
  }

  void dispose() {
    streamController.close();
  }

  void updateUI() {
    if (streamController.isClosed) return;
    sink.add(blocData);
  }

  final Map<String, bool> _singleExecutionTaskKeys = {};
  Future<void> singleExecutionTask(
    String key,
    Future<void> Function() task,
  ) async {
    if (_singleExecutionTaskKeys[key] == true) return;
    _singleExecutionTaskKeys[key] = true;
    await task();
  }
}
