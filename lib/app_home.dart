import 'dart:async';
import 'dart:convert'; // JSONデコード用
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart'; // アセット読み込み用
import 'package:location/location.dart'; // 位置情報取得用
import 'campus_tour_home.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.66216793880571, 139.63427019724344);

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  int _selectedIndex = 0; // BottomNavigationBarの選択状態

  // 現在地用
  late LocationData _currentLocation;
  final Location _location = Location();
  Marker? _currentLocationMarker;

  late StreamSubscription<LocationData> _locationSubscription;

  @override
  void initState() {
    super.initState();
    _loadGeoJson(); // GeoJSONデータを読み込む
    _startLocationUpdates(); // 位置情報の更新を開始
  }

  // 位置情報を継続的に取得
  void _startLocationUpdates() {
    _locationSubscription = _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
        _currentLocationMarker = Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          infoWindow: const InfoWindow(title: '現在地'),
        );
      });

      // カメラを現在地に移動
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(currentLocation.latitude!, currentLocation.longitude!),
        ),
      );
    });
  }

  // GeoJSONデータを読み込む
  Future<void> _loadGeoJson() async {
    try {
      final String geoJsonString = await rootBundle.loadString('assets/route_data.json');
      final Map<String, dynamic> geoJson = json.decode(geoJsonString);

      final markers = _extractMarkers(geoJson);
      final polylines = _extractPolylines(geoJson);

      setState(() {
        _markers = markers;
        _polylines = polylines;
      });
    } catch (e) {
      print("GeoJSON読み込みエラー: $e");
    }
  }

  // GeoJSONからマーカーを抽出
  Set<Marker> _extractMarkers(Map<String, dynamic> geoJson) {
    final Set<Marker> markers = {};
    final features = geoJson['features'] as List<dynamic>;

    for (final feature in features) {
      if (feature['geometry']['type'] == 'Point') {
        final coordinates = feature['geometry']['coordinates'] as List<dynamic>;
        markers.add(
          Marker(
            markerId: MarkerId('marker_${feature['id']}'),
            position: LatLng(coordinates[1], coordinates[0]),
            infoWindow: InfoWindow(title: '地点 ${feature['id']}'),
            zIndex: 1, // マーカーを前面に
          ),
        );
      }
    }
    return markers;
  }

  // GeoJSONからポリラインを抽出
  Set<Polyline> _extractPolylines(Map<String, dynamic> geoJson) {
  final Set<Polyline> polylines = {};
  final features = geoJson['features'] as List<dynamic>;

  for (final feature in features) {
    if (feature['geometry']['type'] == 'LineString') {
      final coordinates = feature['geometry']['coordinates'] as List<dynamic>;
      final List<LatLng> points = coordinates
          .map((coordinate) => LatLng(coordinate[1], coordinate[0]))
          .toList();

      // デバッグ用にポイントを表示
      print("Polyline Points: $points");

      if (points.isNotEmpty) {
        polylines.add(
          Polyline(
            polylineId: PolylineId('polyline_${feature['id']}'),
            points: points,
            color: Colors.blue,
            width: 5,
            zIndex: 0, // Polylineを背面に設定
          ),
        );
      }
    }
  }
    return polylines;
  }


  // 地図が作成されたとき
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // BottomNavigationBarのタップイベント
  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CampusTourHome()),
      );
    }
  }

  @override
  void dispose() {
    _locationSubscription.cancel(); // 位置情報の監視を停止
    super.dispose();
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
