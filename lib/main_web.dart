import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:html' as html;

import 'my_app.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // .envファイルをロード

  // Google Maps APIキーをHTMLに動的に設定
  final apiKey = dotenv.env['API_KEY'] ?? '';
  if (apiKey.isNotEmpty) {

    // Google Mapsスクリプトタグの動的追加
    final script = html.ScriptElement()
      ..src = 'https://maps.googleapis.com/maps/api/js?key=$apiKey'
      ..type = 'text/javascript'
      ..async = true;
    html.document.head?.append(script);

    script.onLoad.listen((event) {
      print("Web: Google Maps script loaded successfully.");
      runApp(const MyApp()); // スクリプトロード後にアプリを起動
    });

    script.onError.listen((event) {
      print("Web: Failed to load Google Maps script.");
    });
  } else {
    print("Web: API Key is missing.");
  }
}
