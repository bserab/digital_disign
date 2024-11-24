import 'package:flutter/material.dart';
import 'root_maker.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // 状態ではなく初期値を表示
      ),
      body: Center(
        child: Text(currentDescription),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 丸ボタンが押されたときの処理
          navigateToPage(context, 1);
        },
        child: const Icon(Icons.add), // ボタンの中のアイコン
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

final List<Map<String, String>> pages =[
    { "title": "ルートA", "description": "ルートAの詳細情報" },
    { "title": "ルートB", "description": "ルートBの詳細情報" },
    { "title": "ルートC", "description": "ルートCの詳細情報" },
];

void navigateToPage(BuildContext context, int index) {
  // 指定されたインデックスからページデータを取得
  final page = pages[index];

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RootMaker(
        title: page["title"]!, // 取得したタイトルを渡す
        description: page["description"]!, // 取得した説明を渡す
      ),
    ),
  );
}

