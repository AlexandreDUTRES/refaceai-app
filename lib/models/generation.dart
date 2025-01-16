import 'dart:convert';

class Generation {
  String _id;
  String _userId;
  String _created;
  String _promptId;
  String _url;
  int? _rating;

  Generation({
    required String id,
    required String userId,
    required String created,
    required String promptId,
    required String url,
    required int? rating,
  })  : _id = id,
        _userId = userId,
        _created = created,
        _promptId = promptId,
        _url = url,
        _rating = rating;

  String get id => _id;
  String get promptId => _promptId;
  String get url => _url;
  int? get rating => _rating;
  int get createdTimestamp => DateTime.parse(_created).millisecondsSinceEpoch;

  void setRating(int rating) {
    _rating = rating;
  }

  factory Generation.fromMap(Map data) {
    return Generation(
      id: data["id"],
      userId: data["userId"],
      created: data["created"],
      promptId: data["promptId"],
      url: data["url"],
      rating: data["rating"] != null ? data["rating"] : null,
    );
  }

  Map toMap() => {
        "id": _id,
        "userId": _userId,
        "created": _created,
        "promptId": _promptId,
        "url": _url,
        if (_rating != null) "rating": _rating,
      };

  @override
  String toString() {
    return json.encode(toMap());
  }
}
