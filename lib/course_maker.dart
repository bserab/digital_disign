import 'package:flutter/material.dart';
import 'package:my_app/tour_macker.dart';
import 'util.dart';

class CourseMaker extends StatefulWidget {
  final String title;
  final String description;
  final int id;

  const CourseMaker({required this.title, required this.description, required this.id, Key? key}) : super(key: key);
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
    body: Column(
      children: [
        // AppBarの下にタイトル表示部分を変更
        Container(
          width: double.infinity, // 横幅を画面全体に設定
          color: const Color.fromRGBO(0, 98, 83, 1), // 背景色を変更
          padding: const EdgeInsets.symmetric(vertical: 6.0), // 上下の余白
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 80.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(166, 202, 236, 1), // 内部背景色
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white, // リスト部分の背景色を変更
            child: Column(
              children: [
                // おすすめコーステキスト
                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 8.0),
                //   child: Text(
                //     "おすすめコース",
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black, // テキストを白に設定
                //     ),
                //   ),
                // ),
                // コースリスト
                Expanded(
                  child: ListView.separated(
                    itemCount: courseTitles[widget.id].length + 1, // サンプルデータとして7項目を表示
                    itemBuilder: (context, index) {
                      if (index < courseTitles[widget.id].length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: ListTile(
                            title: Text(
                              "${index + 1}. ${courseTitles[widget.id][index]}",
                              style: const TextStyle(
                                fontSize: 19,
                                color: Colors.black, // 項目名を白に設定
                              ),
                            ),
                          ), // 項目名
                        );
                      } else {
                        return const SizedBox.shrink(); // 追加の線のための空要素
                      }
                    },
                    separatorBuilder: (context, index) {
                      return const Divider( // 各項目間の分割線
                        color: Colors.grey,
                        thickness: 1.0,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    floatingActionButton: Stack(
      children: [
        // RoundedButton を FloatingActionButton の横に配置
        Positioned(
          right: 0, // 右端からの距離を調整
          bottom: 0, // 下端からの距離を調整
          child: SizedBox(
            width: size.width - size.width / 11, //ボタンの幅を指定
            height: size.height / 11,
            child: RoundedButton(
              label: "ツアーを開始する",
              onPressed: () {
                // 長方形ボタンが押されたときの処理
                updateDescription("ツアーが開始されました！");
                navigateToPage(context, widget.title,widget.id);
              },
            ),
          ),
        ),
      ],
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

List<List<String>> courseTitles = [
  [
    "スタート位置：正門",
    "日本大学文理学部図書館",
    "ファミリーマート日本大学文理学部店",
    "桜門書房",
    "食堂 秋桜",
    "冨士房インターナショナル",
    "ラーニング・コモンズ",
  ],
  [
    "スタート位置：正門",
    "日本大学文理学部図書館",
    "ファミリーマート日本大学文理学部店",
    "食堂 秋桜",
    "ラーニング・コモンズ",
    "情報科学科事務室",
    "計算機室 8B203・8B210",
  ]
];

void navigateToPage(BuildContext context, String title,int id) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TourMaker(
        title: title, // 取得したタイトルを渡す
        id: id,
        courseList: courseTitles[id],
      ),
    ),
  );
}
