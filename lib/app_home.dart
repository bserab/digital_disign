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
        appBar: AppBar(
          title: const Text("マップ"),
          centerTitle: true,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
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
      ),
    );
  }
}