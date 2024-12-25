import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // MethodChannel用
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'my_app.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // .envファイルをロード

  // MethodChannelでiOS/AndroidにAPIキーを送信
  const platform = MethodChannel('com.example.myapp/env');
  try {
    final apiKey = dotenv.env['API_KEY'] ?? 'No API Key';
    await platform.invokeMethod('setApiKey', {'apiKey': apiKey});
    print("Native: API Key sent successfully.");
  } on PlatformException catch (e) {
    print("Failed to send API key: ${e.message}");
  }

  runApp(const MyApp());
}
