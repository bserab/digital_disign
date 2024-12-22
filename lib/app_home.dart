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
  _initializeLocation(); // 初期化
  _loadGeoJson(); // GeoJSONデータを読み込む
  _startLocationUpdates(); // 位置情報の更新を開始
  }

  void _initializeLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // ロケーションサービスの有効化確認
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        print('ロケーションサービスが有効化されていません。');
        return;
      }
    }

    // 位置情報権限の確認
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('位置情報権限が許可されていません。');
        return;
      }
    }

    // 初期位置情報を取得
    _currentLocation = await _location.getLocation();
    setState(() {
      _currentLocationMarker = Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        infoWindow: const InfoWindow(title: '現在地'),
      );
    });

    print('初期位置: ${_currentLocation.latitude}, ${_currentLocation.longitude}');
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
  return Scaffold(
    body: Column(
      children: [
        // Google Map 表示
        Expanded(
          child:
          GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.hybrid,
            myLocationEnabled: true, // デフォルトの青い丸を有効化
            markers: _markers, // カスタムマーカーには現在地を含めない
            polylines: _polylines,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 18.0,
            ),
          ),
        ),
        // 検索バーを下部に配置
        Container(
          color: Colors.white, // 背景を白に設定
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: '検索', // ラベル
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: const Color.fromRGBO(0, 98, 83, 1),
      unselectedItemColor: const Color.fromRGBO(75, 75, 75, 1),
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
  );
}
}