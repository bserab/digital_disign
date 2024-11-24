import 'package:flutter/material.dart';
import 'util.dart';
import 'course_maker.dart';

class CampusTourHome extends StatefulWidget {
  const CampusTourHome({super.key});
  @override
  _CampusTourHome createState() => _CampusTourHome();
}

//キャンパスツアーの属性選択画面
class _CampusTourHome extends State<CampusTourHome> {
  int _selectedIndex = 1; // 初期選択（キャンパスツアー）

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // 画面遷移
    if (index == 0) {
      Navigator.pop(context);
    } else if (index == 1) {
      // 現在のページなので何もしない
    }
  }
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
                    navigateToPage(context, 0);
                  },
                ),
                RoundedButton(
                  label: "新入生：情報科学科",
                  onPressed: () {
                    // 他の画面遷移
                    navigateToPage(context, 1);
                  },
                ),
                RoundedButton(
                  label: "新入生：??学科",
                  onPressed: () {
                    navigateToPage(context, 2);
                  },
                ),
                // 必要に応じてボタンを追加
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "マップ検索",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: "キャンパスツアー",
          ),
        ],
      ),
    );
  }
}

// データリスト
final List<Map<String, String>> pages = [
  {"title": "高校生：学校見学", "description": "学校見学の詳細ページ"},
  {"title": "新入生：情報科学科", "description": "学校見学の詳細ページ"},
  {"title": "新入生：??学科", "description": "学校見学の詳細ページ"},
];

// 任意のページに遷移する関数
void navigateToPage(BuildContext context, int index) {
  final page = pages[index]; // 指定したインデックスのページデータを取得
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CourseMaker(
        title: page["title"]!,
        description: page["description"]!,
      ),
    ),
  );
}