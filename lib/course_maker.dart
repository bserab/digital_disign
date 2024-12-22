import 'package:flutter/material.dart';
import 'util.dart';
import 'root_maker.dart';

class CourseMaker extends StatefulWidget {
  final String title;
  final String description;

  const CourseMaker({required this.title, required this.description, Key? key}) : super(key: key);
  @override
  _CourseMakerState createState() => _CourseMakerState();
}

// キャンパスツアーの順番表示するページの親（仮）
class _CourseMakerState extends State<CourseMaker> {
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "キャンパスツアー",
          style: TextStyle(
            color: Color.fromRGBO(242, 242, 242, 1), // テキストの色を設定
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 98, 83, 1), // AppBarの背景色を変更
      ),
      body: Column(
        children: [
          // 少し下に移動させるための余白を追加
          const SizedBox(height: 8.0),
          // AppBarの下に帯状のテキストを表示
          Container(
            width: double.infinity, // 横幅を画面全体に設定
            color: const Color.fromRGBO(166, 202, 236, 1),
            padding: const EdgeInsets.symmetric(vertical: 8.0), // 上下の余白
            child: Text(
              widget.title,
              textAlign: TextAlign.center, // テキストを中央揃え
              style: const TextStyle(
                color: Colors.black, // テキストの色
                fontSize: 18, // フォントサイズ
                fontWeight: FontWeight.bold, // 太字
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white, // 画面全体の背景色を白に設定
              child: Center(
                child: Text(currentDescription),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // "ツアーを開始する" ボタン
          SizedBox(
            width: size.width * 0.7, // ボタンの幅を調整
            height: 50.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // ボタンの角を丸く
                ),
                backgroundColor: const Color.fromRGBO(0, 98, 83, 1), // ボタンの背景色
              ),
              onPressed: () {
                updateDescription("ツアーが開始されました！");
              },
              child: const Text(
                "ツアーを開始する",
                style: TextStyle(
                  color: Colors.white, // テキストの色
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10), // ボタン間の余白
          // FloatingActionButton
          FloatingActionButton(
            onPressed: () {
              navigateToPage(context, 1);
            },
            backgroundColor: const Color.fromRGBO(217, 242, 208, 1), // 背景色
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0), // 丸い形
              side: const BorderSide(
                color: Colors.black, // 黒い枠線
                width: 2.0,
              ),
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min, // 必要最小限の高さに設定
          children: [
            // ナビゲーションバーの上に黒い線を追加
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
      ),
    );
  }
}

final List<Map<String, String>> pages = [
  {"title": "ルートA", "description": "ルートAの詳細情報"},
  {"title": "ルートB", "description": "ルートBの詳細情報"},
  {"title": "ルートC", "description": "ルートCの詳細情報"},
];

void navigateToPage(BuildContext context, int index) {
  // 指定されたインデックスからページデータを取得
  final page = pages[index];

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RootMaker(
        title: page["title"]!,
        description: page["description"]!,
      ),
    ),
  );
}
