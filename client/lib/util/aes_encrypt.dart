import 'dart:typed_data';

import 'package:pointycastle/export.dart';

Uint8List aesCbcEncrypt(
    Uint8List key, Uint8List iv, Uint8List paddedPlaintext) {
  assert(key.length == 32); // aes-256은 키 길이가 32바이트입니다.
  assert(iv.length == 16); // aes-cbc는 IV 길이가 16바이트입니다.

  // AES를 사용하여 CBC 블록 암호를 생성하고 지정된 키와 IV로 초기화합니다.

  final cbc = CBCBlockCipher(AESEngine())
    ..init(true, ParametersWithIV(KeyParameter(key), iv)); // true=encrypt

  // 평문을 블록 단위로 암호화합니다.

  final cipherText = Uint8List(paddedPlaintext.length); // allocate space

  var offset = 0;
  while (offset < paddedPlaintext.length) {
    offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
  }
  assert(offset == paddedPlaintext.length);

  return cipherText;
}