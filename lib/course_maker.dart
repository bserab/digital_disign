import 'package:flutter/material.dart';

class CourseMaker extends StatefulWidget {
  const CourseMaker({super.key});
  @override
  _CourseMaker createState() => _CourseMaker();
}

//キャンパスツアーの順番表示するページの親（仮）
class _CourseMaker extends State<CourseMaker> {
  int _selectedIndex = 1; // 初期選択（キャンパスツアー）

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // 画面遷移
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == 1) {
      // 現在のページなので何もしない
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
