import 'package:flutter/material.dart';
import 'util.dart';
import 'course_maker.dart';

class CampusTourHome extends StatefulWidget {
  const CampusTourHome({super.key});

  @override
  _CampusTourHomeState createState() => _CampusTourHomeState();
}

// キャンパスツアーの属性選択画面
class _CampusTourHomeState extends State<CampusTourHome> {
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white), 
        title: const Text(
          "キャンパスツアー",
          style: TextStyle(
            color: Color.fromRGBO(242, 242, 242, 1), // テキストの色を設定
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 98, 83, 1), // AppBarの背景色を変更
      ),
      body: Container(
        color: Colors.white, // 背景色を白に設定
        child: Column(
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
                      navigateToPage(context, 0);
                    },
                  ),
                  RoundedButton(
                    label: "新入生：情報科学科",
                    onPressed: () {
                      navigateToPage(context, 1);
                    },
                  ),
                  // 必要に応じてボタンを追加
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // 必要最小限の高さに設定
        children: [
          // ナビゲーションバーの上に線を残す
          Container(
            height: 2.0, // 線の高さ
            color: Colors.black, // 線の色
          ),
          // ナビゲーションバー
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color.fromRGBO(0, 98, 83, 1), // 選択時のアイコン色
            unselectedItemColor: const Color.fromRGBO(75, 75, 75, 1), // 非選択時のアイコン色
            backgroundColor: Colors.white, // ナビゲーションバーの背景を白に設定
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: "マップ",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flag),
                label: "キャンパスツアー",
              ),
            ],
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
        id: index,
      ),
    ),
  );
}
