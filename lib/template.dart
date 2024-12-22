import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //-----------------　ここタイトル -------------
      appBar: AppBar(
        title: const Text("画面タイトル"),
        centerTitle: true, 
      ),
      // -----------------------ここからヘッダー---------------
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 必要に応じて変更
        children: [
          // 上部のスペースやヘッダー
          const SizedBox(height: 16), // 上部余白
          const Text(
            "ここに説明文や見出しを追加",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16), // テキストの下の余白

          //------------------------ここから機能追加部分-----------------
          // リストやボタンを配置する部分
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // ボタンやリストアイテムをここに追加
              ],
            ),
          ),
          //------------------ 下部の固定ボタンやフッター部分 ----------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // ボタンの処理をここに記述
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // 幅いっぱい
              ),
              child: const Text("戻る"),
            ),
          ),
        ],
      ),
    );
  }
}
