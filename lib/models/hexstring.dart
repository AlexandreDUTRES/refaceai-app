library hexstring;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import "package:hex/hex.dart";

class HexString {
  late String _value;

  HexString(String value) {
    value = value.replaceFirst("0x", "");
    try {
      BigInt.parse(value, radix: 16);
    } catch (e) {
      throw "HexString incorrect value : $value";
    }

    _value = value;
  }

  void removeInnerValue() {
    int length = _value.length;
    Random random = Random();
    StringBuffer hexString = StringBuffer();
    while (hexString.length < length) {
      hexString.write(random.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    _value = hexString.toString().substring(0, length);
  }

  @override
  String toString() => _value;
  String toLowerCaseString() => _value.toLowerCase();
  String to0xString() => "0x" + _value;
  String toLowerCase0xString() => "0x" + _value.toLowerCase();

  bool equals(HexString? hexString) {
    if (hexString == null) return false;
    return toBigInt() == hexString.toBigInt();
  }

  bool uppercaseEquals(HexString hexString) => _value == hexString.toString();

  factory HexString.fromBytes(List<int> bytes) => HexString(HEX.encode(bytes));
  List<int> toBytes() => HEX.decode(_value);

  factory HexString.fromUint8List(Uint8List uint8List) =>
      HexString.fromBytes(uint8List.toList());
  Uint8List toUint8List() => Uint8List.fromList(toBytes());

  factory HexString.fromInt(int integer) =>
      HexString("0x" + integer.toRadixString(16));
  int toInt() => int.parse(_value, radix: 16);

  factory HexString.fromBigInt(BigInt bigInt) =>
      HexString("0x" + bigInt.toRadixString(16));
  BigInt toBigInt() => BigInt.parse(_value, radix: 16);

  factory HexString.fromPadding0(String padding0Value) {
    padding0Value = padding0Value.replaceFirst("0x", "");
    String noPaddingValue = padding0Value.replaceFirst(RegExp(r"^(00)+"), "");
    return HexString(noPaddingValue);
  }

  factory HexString.fromPrefixString(String prefixString) {
    return HexString(prefixString.split(":")[1]);
  }

  factory HexString.fromUTF8(String utf8Val) =>
      HexString.fromBytes(utf8.encode(utf8Val));
  String toUTF8() => utf8.decode(toBytes());

  factory HexString.fromBase64(String base64Value) {
    if (base64Value.length % 4 > 0) {
      base64Value += '=' * (4 - base64Value.length % 4);
    }
    return HexString.fromUint8List(base64.decode(base64Value));
  }
  String toBase64() => base64.encode(toBytes());

  factory HexString.fromAscii(String asciiVal) {
    String hex = "";
    for (int i = 0; i < asciiVal.length; i += 2) {
      String str = asciiVal.substring(i, i + 2);
      hex += String.fromCharCode(HexString(str).toInt());
    }

    return HexString(hex);
  }
  String toAscii() {
    List<HexString> splitted = [];
    for (int i = 0; i < _value.length; i = i + 2) {
      splitted.add(HexString(_value.substring(i, i + 2)));
    }
    String ascii = "";
    // ignore: avoid_function_literals_in_foreach_calls
    splitted.forEach((e) {
      if (e.toString() == "00") return;
      ascii += String.fromCharCode(e.toInt());
    });
    return ascii;
  }
}
