import 'package:flutter/material.dart';

class HighSchoolCourseSetting extends StatelessWidget {
  const HighSchoolCourseSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //-----------------　ここタイトル -------------
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "高校生:学校見学",
          style: TextStyle(
            color: Color.fromRGBO(242, 242, 242, 1), // テキストの色を設定
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 98, 83, 1), // AppBarの背景色を変更
      ),
      // -----------------------ここからヘッダー---------------
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 必要に応じて変更
        children: [
          // 上部のスペースやヘッダー
          const SizedBox(height: 16), // 上部余白
          const Text(
            "おすすめコース",
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
