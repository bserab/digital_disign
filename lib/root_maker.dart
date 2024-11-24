import 'package:flutter/material.dart';

class RootMaker extends StatefulWidget {
  final String title;
  final String description;

  const RootMaker({required this.title, required this.description, Key? key}) : super(key: key);

  @override
  _RootMaker createState() => _RootMaker();
}

class _RootMaker extends State<RootMaker> {
  int _selectedIndex = 0; // 初期選択（例: ルート設定）

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(widget.description),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "ホーム",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "設定",
          ),
        ],
      ),
    );
  }
}
