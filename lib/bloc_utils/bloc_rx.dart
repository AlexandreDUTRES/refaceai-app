library bloc_rx;

import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class BlocRx<T> {
  T? blocData;

  // ignore: close_sinks
  StreamController<T>? streamController;
  Sink<T> get sink => streamController!.sink;
  Stream<T> get stream => streamController!.stream;

  void initialize(T blocData, [bool keepStream = false]) {
    if (!keepStream || streamController == null) {
      if (streamController != null && !streamController!.isClosed) {
        streamController!.close();
      }
      streamController = BehaviorSubject<T>();
    }
    this.blocData = blocData;
    updateUI();
  }

  Future<void> dispose() async {
    await streamController!.close();
    streamController = null;
  }

  void updateUI() {
    if (streamController == null || streamController!.isClosed) return;
    sink.add(blocData!);
  }

  Future<void> waitTillListenerAndDispose() async {    
    bool hasListener = streamController!.hasListener;
    while(hasListener) {
      await Future.delayed(const Duration(milliseconds: 10));
      hasListener = streamController!.hasListener;
      
    }
    await dispose();
  }
}
