import 'package:flutter/foundation.dart'; // kIsWebを使う
import 'main_native.dart' as native; // ネイティブ用
import 'main_web.dart' as web; // Web用

void main() {
  if (kIsWeb) {
    web.main(); // Web用のエントリーポイント
  } else {
    native.main(); // ネイティブ用のエントリーポイント
  }
}
