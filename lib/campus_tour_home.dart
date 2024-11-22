import 'package:flutter/material.dart';
import 'util.dart';
import 'high_school_course_home.dart';


//キャンパスツアーの属性選択画面
class CampusTourHome extends StatelessWidget {
  const CampusTourHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("キャンパスツアー"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // 上部の余白
          const Text(
            "希望するツアーを選択してください。",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                RoundedButton(
                  label: "高校生：学校見学",
                  onPressed: () {
                    // 他の画面遷移（例: SchoolTourPage）
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HighSchoolCourseHome()),
                    );
                  },
                ),
                RoundedButton(
                  label: "新入生：情報科学科",
                  onPressed: () {
                    // 他の画面遷移
                  },
                ),
                RoundedButton(
                  label: "新入生：??学科",
                  onPressed: () {},
                ),
                // 必要に応じてボタンを追加
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // 親ページ（MapPage）に戻る
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // 角丸なし
              ),
              minimumSize: const Size(double.infinity, 50), // 幅いっぱいのボタン
            ),
            child: const Text("マップに戻る"),
          ),
        ],
      ),
    );
  }
}