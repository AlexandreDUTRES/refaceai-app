import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateTools {
  static String timestampToDateAgo(int timestamp, Locale locale,
      [bool short = false]) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    String langCode = "${locale.languageCode}${short ? "_short" : ""}";
    return timeago.format(date, locale: langCode);
  }
}
