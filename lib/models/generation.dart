import 'dart:convert';

class Generation {
  String _id;
  String _userId;
  String _created;
  String _promptId;
  String _url;

  Generation({
    required String id,
    required String userId,
    required String created,
    required String promptId,
    required String url,
  })  : _id = id,
        _userId = userId,
        _created = created,
        _promptId = promptId,
        _url = url;

  String get id => _id;
  String get promptId => _promptId;
  String get url => _url;
  int get createdTimestamp =>
      DateTime.parse(_created).millisecondsSinceEpoch;

  factory Generation.fromMap(Map data) {
    return Generation(
      id: data["id"],
      userId: data["userId"],
      created: data["created"],
      promptId: data["promptId"],
      url: data["url"],
    );
  }

  Map toMap() => {
        "id": _id,
        "userId": _userId,
        "created": _created,
        "promptId": _promptId,
        "url": _url,
      };

  @override
  String toString() {
    return json.encode(toMap());
  }
}
