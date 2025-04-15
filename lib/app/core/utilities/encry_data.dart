import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class EncryptData {
  factory EncryptData() => _instance;

  EncryptData._internal();
  static final EncryptData _instance = EncryptData._internal();

  static late IV iv;
  static late Key key;

  static const String _privateKey = 'zasdOyWOqczUffkizwypQadNLv2h4oA0';
  static const String _privateINV = 'xfpkDQJXIfb3mcnb';
  static void init() {
    key = Key.fromUtf8(_privateKey);
    iv = IV.fromUtf8(utf8.decode(_privateINV.codeUnits));
  }

  static String crypteFile(String? data) {
    final encrypter = Encrypter(AES(key, padding: null));
    final encrypted = encrypter.encrypt(data ?? '', iv: iv);
    return encrypted.base64;
  }

  static String decryptFile(String? data) {
    final encrypter = Encrypter(AES(key, padding: null));
    final decrypted = encrypter.decrypt(Encrypted.from64(data ?? ''), iv: iv);
    return decrypted;
  }
}
