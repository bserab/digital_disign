import 'package:flutter/material.dart';
import 'campus_tour_home.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//ホーム画面
class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
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
    return MaterialApp(
        home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // 必要最小限の高さに設定
        children: [
          // 検索ボックスの上に線
          Container(
            height: 2.0, // 線の高さ
            color: Colors.black, // 線の色
          ),
          // 検索ボックス全体の背景色を白に
          Container(
            color: Colors.white, // 背景を白に設定
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '検索', // 検索と書かれたラベル
                  fillColor: Colors.white, // 背景色を白に設定
                  filled: true, // 背景を塗りつぶす
                  border: OutlineInputBorder(), // ボーダーを追加
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0), // 内側の余白
                ),
              ),
            ),
          ),
          // 検索ボックスとナビゲーションバーの間に線を追加
          Container(
            height: 2.0, // 線の高さ
            color: Colors.black, // 線の色
          ),
          // ナビゲーションバー
          Container(
            height: 70.0, // 高さを変更
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: const Color.fromRGBO(0, 98, 83, 1), // 選択時のアイコン色
              unselectedItemColor: const Color.fromRGBO(75, 75, 75, 1), // 非選択時のアイコン色
              backgroundColor: Colors.white,
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
    )
    );
  }
}
