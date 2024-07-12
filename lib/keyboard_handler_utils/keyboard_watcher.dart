library keyboard_watcher;

import 'dart:async';

import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:keyboard_utils/keyboard_listener.dart' as keyboard_listener;
import 'package:rxdart/rxdart.dart';

class KeyboardState {
  final bool isOpened;
  final double height;
  const KeyboardState(this.isOpened, this.height);
  @override
  String toString() {
    return "isOpened: $isOpened; height: $height";
  }
}

class KeyboardWatcher {
  static final KeyboardUtils _keyboardUtils = KeyboardUtils();
  // ignore: close_sinks
  static final StreamController<KeyboardState> _controller =
      BehaviorSubject<KeyboardState>();
  static Sink<KeyboardState> get _sink => _controller.sink;
  static Stream<KeyboardState> get stream => _controller.stream;

  static KeyboardState state = const KeyboardState(false, 0);

  static Future<void> _setNewValue(bool val) async {
    // check if state correspond to keyboard height
    double kHeight;
    do {
      kHeight = _keyboardUtils.keyboardHeight;
      await Future.delayed(const Duration(milliseconds: 5));
    } while ((val && kHeight == 0) || (!val && kHeight != 0));

    state = KeyboardState(val, kHeight);
    _sink.add(state);
  }

  static void initListener() {
    _sink.add(state);
    _keyboardUtils.add(
        listener: keyboard_listener.KeyboardListener(
      willHideKeyboard: () {
        _setNewValue(false);
      },
      willShowKeyboard: (double keyboardHeight) {
        _setNewValue(true);
      },
    ));
  }

  static Future<void> waitKeyboardClosed() async {
    while (state.isOpened) {
      await Future.delayed(const Duration(milliseconds: 5));
    }
  }

  static Future<void> waitKeyboardOpened() async {
    while (!state.isOpened) {
      await Future.delayed(const Duration(milliseconds: 5));
    }
  }
}
