import 'package:flutter/material.dart';
import 'util.dart';
import 'high_school_course_home.dart';

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