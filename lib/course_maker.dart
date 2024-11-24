import 'package:flutter/material.dart';
import 'util.dart';

class CourseMaker extends StatefulWidget {
  final String title;
  final String description;

  const CourseMaker({required this.title, required this.description, Key? key}) : super(key: key);
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
  // 状態を保持する変数
  String currentDescription = "";

  @override
  void initState() {
    super.initState();
    // 初期状態を設定
    currentDescription = widget.description;
  }

  void updateDescription(String newDescription) {
    // 状態を更新する
    setState(() {
      currentDescription = newDescription;
    });
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // 状態ではなく初期値を表示
      ),
      body: Center(
        child: Text(currentDescription),
      ),
      floatingActionButton: Stack(
        children: [
          // RoundedButton を FloatingActionButton の横に配置
          Positioned(
            right: 80, // 右端からの距離を調整
            bottom: 0, // 下端からの距離を調整
            child: SizedBox(
              width: size.width - 124, //ボタンの幅を指定
              height: 73.0,
              child: RoundedButton(
                label: "ツアーを開始する",
                onPressed: () {
                  // 長方形ボタンが押されたときの処理
                  updateDescription("ツアーが開始されました！");
                },
              ),
            ),
          ),
          // FloatingActionButton を配置
          Positioned(
            right: 5,
            bottom: 8,
            child: FloatingActionButton(
              onPressed: () {
                // 丸ボタンが押されたときの処理
                updateDescription("新しい説明に更新されました！");
              },
              child: const Icon(Icons.add), // ボタンの中のアイコン
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
