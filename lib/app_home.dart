import 'package:flutter/material.dart';
import 'campus_tour_home.dart';

//ホーム画面
class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _selectedIndex = 0; // ナビゲーションバーの選択状態

  void _onItemTapped(int index) {
    if (index == 0) {
      // 現在の画面が「マップ」なら何もしない
      setState(() {
        _selectedIndex = index;
      });
    } else if (index == 1) {
      // キャンパスツアー画面に遷移
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CampusTourHome()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("マップ"),
        centerTitle: true,
      ),
      body: Center(
        //ここに表示したいものを書く
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
    );
  }
}