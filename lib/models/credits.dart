import 'dart:convert';

class Credits {
  final int _count;
  final int _lastGain;

  Credits({
    required int count,
    required int lastGain,
  })  : _count = count,
        _lastGain = lastGain;

  int get count => _count;
  int get lastGain => _lastGain;

  // int get nextGain => lastGain + gainPeriod * 1000;

  factory Credits.fromMap(Map data) {
    return Credits(
      count: data["credits"],
      lastGain: DateTime.parse(data["lastCreditGain"]).millisecondsSinceEpoch,
    );
  }

  Map toMap() => {
        "count": _count,
        "lastGain": _lastGain,
      };

  @override
  String toString() {
    return json.encode(toMap());
  }
}
