library utils;

import 'dart:io';

import 'package:flutter/foundation.dart';

bool get isIOS {
  try {
    return !kIsWeb && Platform.isIOS;
  } catch (e) {
    return false;
  }
}

bool get isAndroid {
  try {
    return !kIsWeb && Platform.isAndroid;
  } catch (e) {
    return false;
  }
}

bool get isWeb => kIsWeb;
