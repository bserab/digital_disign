import 'package:flutter/material.dart';
import 'my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


  
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // MethodChannelのインポート
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // .envファイルをロード
  runApp(const MyApp());

  // MethodChannelでネイティブにAPIキーを送る
  const platform = MethodChannel('com.example.myapp/env');
  try {
    final apiKey = dotenv.env['API_KEY'] ?? 'No API Key';
    await platform.invokeMethod('setApiKey', {'apiKey': apiKey});
  } on PlatformException catch (e) {
    print("Failed to send API key: ${e.message}");
  }
}
