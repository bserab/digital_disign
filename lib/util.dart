import 'package:flutter/material.dart';

// 便利機能をいっぱい詰め込むクラス

// 角が丸の四角いボタンを表示するクラス
// 第一引数：表示する文字，第二引数：ボタン押された時のアクション
class RoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const RoundedButton({required this.label, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 角丸
            side: const BorderSide(
              color: Colors.black, // ボーダーの色を黒に設定
              width: 2.0, // ボーダーの太さ
            ),
          ),
          minimumSize: const Size(double.infinity, 50), // ボタンのサイズ
          backgroundColor: const Color.fromRGBO(217, 242, 208, 1), // ボタンの背景色を変更
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black, // テキスト色を黒に設定
          ),
        ),
      ),
    );
  }
}

// 丸いボタンを表示するクラス
// 第一引数：ボタン内に表示するアイコン，第二引数：ボタン押された時のアクション
class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircleButton({required this.icon, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // ボタン上下の余白
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(), // 完全な丸型
          padding: const EdgeInsets.all(20), // アイコン周囲の余白
          minimumSize: const Size(60, 60), // ボタンの最小サイズ
        ),
        child: Icon(icon, size: 24), // ボタン内のアイコン
      ),
    );
  }
}

