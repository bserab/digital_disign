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
        title: Text(widget.title),
      ),
      body: Column(
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
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
