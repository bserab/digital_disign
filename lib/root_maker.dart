import 'package:flutter/material.dart';
import 'dart:convert'; // JSONパース用
import 'package:flutter/services.dart'; // rootBundle用

class RootMaker extends StatefulWidget {
  final String title;
  final String description;

  const RootMaker({required this.title, required this.description, Key? key}) : super(key: key);

  @override
  _RootMaker createState() => _RootMaker();
}

class _RootMaker extends State<RootMaker> {
  List<Map<String, String>> originalItems = []; // JSONから読み込むリストを保持
  List<Map<String, String>> additionalItems = [];
  List<Map<String, String>> selectedItems = [];

  @override
  void initState() {
    super.initState();
    loadAdditionalItems(); // JSONデータを読み込む
  }

  Future<void> loadAdditionalItems() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/root_data.json');
      if (jsonString.isEmpty) {
        throw Exception("JSONファイルが空です");
      }
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        originalItems = jsonData.map((item) => Map<String, String>.from(item)).toList();
        additionalItems = List.from(originalItems); // 順序を保持
      });
    } catch (e) {
      print("エラー: $e");
      setState(() {
        additionalItems = []; // エラー時は空リストにする
      });
    }
  }

  void addSelectedItem(Map<String, String> item) {
    setState(() {
      if (!selectedItems.contains(item)) {
        selectedItems.add(item);
        additionalItems.remove(item); // 下部リストから削除
      }
    });
  }

  void removeSelectedItem(Map<String, String> item) {
  setState(() {
    if (selectedItems.contains(item)) {
      // 上部リストから削除
      selectedItems.remove(item);
      // 下部リストに元の順序で追加
      final originalIndex = originalItems.indexOf(item);
      if (originalIndex >= 0) {
        additionalItems.remove(item); // 念のため、重複防止のため削除
        additionalItems.insert(originalIndex, item);
      }
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "キャンパスツアー",
          style: const TextStyle(
            color: Color.fromRGBO(242, 242, 242, 1), // AppBarの文字色を変更
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 98, 83, 1),
      ),
body: Container(
      color: Colors.white, // 背景色を白に設定
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: selectedItems.length,
              itemBuilder: (context, index) {
                final item = selectedItems[index];
                return ListTile(
                  title: Text(item['title'] ?? "タイトルがありません"),
                  subtitle: Text(item['description'] ?? "説明がありません"),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      removeSelectedItem(item);
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: additionalItems.length,
              itemBuilder: (context, index) {
                final item = additionalItems[index];
                return ListTile(
                  title: Text(item['title'] ?? "タイトルがありません"),
                  subtitle: Text(item['description'] ?? "説明がありません"),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      addSelectedItem(item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // 必要最小限の高さに設定
        children: [
          // ナビゲーションバーの上に黒い線を追加
          Container(
            height: 2.0, // 線の高さ
            color: Colors.black, // 線の色
          ),
          // ナビゲーションバー
          Container(
            height: 70.0, // ナビゲーションバーの高さを設定
            child: BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              selectedItemColor: const Color.fromRGBO(0, 98, 83, 1), // 選択時のアイコン色
              unselectedItemColor: const Color.fromRGBO(75, 75, 75, 1), // 非選択時のアイコン色
              backgroundColor: Colors.white, // ナビゲーションバーの背景色
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
          ),
        ],
      ),
    );
  }
}