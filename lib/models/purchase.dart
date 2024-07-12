import 'dart:convert';

class Purchase {
  String _orderId;
  String _productId;
  String _purchaseToken;
  String _userId;
  String _service;
  String _created;
  bool _active;

  Purchase({
    required String orderId,
    required String productId,
    required String purchaseToken,
    required String userId,
    required String service,
    required String created,
    required bool active,
  })  : _orderId = orderId,
        _productId = productId,
        _purchaseToken = purchaseToken,
        _userId = userId,
        _service = service,
        _created = created,
        _active = active;

  String get purchaseToken => _purchaseToken;

  factory Purchase.fromMap(Map data) {
    return Purchase(
      orderId: data["orderId"],
      productId: data["productId"],
      purchaseToken: data["purchaseToken"],
      userId: data["userId"],
      service: data["service"],
      created: data["created"],
      active: data["active"],
    );
  }

  Map toMap() => {
        "orderId": _orderId,
        "productId": _productId,
        "userId": _userId,
        "service": _service,
        "created": _created,
        "active": _active,
      };

  @override
  String toString() {
    return json.encode(toMap());
  }
}
