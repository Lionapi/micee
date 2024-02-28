// ignore_for_file: avoid_init_to_null, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_constructors, unused_local_variable, unnecessary_string_escapes

import 'dart:math';
import 'package:encrypt/encrypt.dart';

class RandomCode {
  static dynamic rand = null, color = null;
  static String character = '0123456789', randstring = '';  // String character = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  
  dynamic generateRandomColor() {
    rand = Random().nextInt(10000000);
    color = '0x' + rand.toRadixString(16).toString().toUpperCase();
    if(color.length != 10){
      color = color.toString().padRight(10, '0');
      color = color.toString().substring(0, 10);
    }
    return color;
  }

  dynamic generateRandomString(){
    randstring = '';
    for(var i=0; i<8; i++){
      if(i == 4){ randstring += '-'; }
      randstring += character[Random().nextInt(character.length - 1)];
    }
    return randstring;
  }

  // 256keysize = 32chars     128ivsize = 16chars    \u{0} = \0
  
  String encryptAESQr(clearText, secretKey, secretIv){
    try{
      final key = Key.fromUtf8(secretKey.toString().padRight(32, '\u{0}')); 
      final iv = IV.fromUtf8(secretIv.toString().padRight(16, '\u{0}'));
      final xcrypt = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
      final finalcrypt = xcrypt.encrypt(clearText, iv: iv).base64;
      return finalcrypt;
    }catch(e){
      return e.toString();
    }
  }

  String decryptAESQr(data, secretKey, secretIv) {
    try{
      final key = Key.fromUtf8(secretKey.toString().padRight(32, '\u{0}'));
      final iv = IV.fromUtf8(secretIv.toString().padRight(16, '\u{0}'));
      final xcrypt = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
      final finalcrypt = xcrypt.decrypt(Encrypted.from64(data), iv: iv);
      return finalcrypt;
    }catch(e){
      return e.toString();
    }
  }

  // https://github.com/iotjin/jh_flutter_demo
  // https://github.com/dint-dev/cryptography/tree/master/cryptography
  // https://gist.github.com/jiavictor/1c6238e5069ea8d9eb50501d0ac4eb17
}