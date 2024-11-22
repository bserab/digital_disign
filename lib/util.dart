import 'package:flutter/material.dart';

//便利機能をいっぱい詰め込むクラス

//角が丸の四角いボタンを表示するクラス
//第一引数：表示する文字，第二引数：ボタン押された時のアクション
class RoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const RoundedButton({required this.label, required this.onPressed,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 角丸
          ),
          minimumSize: const Size(double.infinity, 50), // ボタンのサイズ
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}