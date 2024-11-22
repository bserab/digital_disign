import 'package:flutter/material.dart';
import 'campus_tour_home.dart';

//ホーム画面
class AppHome extends StatelessWidget {
  const AppHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("マップ"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 子ページ（キャンパスツアー選択ページ）への遷移
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CampusTourHome()),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
          ),
          child: const Text("キャンパスツアーを見る"),
        ),
      ),
    );
  }
}