import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert'; // JSONデコード用
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart'; // アセット読み込み用
import 'package:location/location.dart'; // 位置情報取得用
import 'package:my_app/app_home.dart';
import 'util.dart';
import 'root_maker.dart';

class TourMaker extends StatefulWidget {
  final String title;
  final int id;
  final List<String> courseList;

  const TourMaker({required this.title,required this.id, required this.courseList, Key? key}) : super(key: key);
  @override
  _TourMaker createState() => _TourMaker();
}

//キャンパスツアーの順番表示するページの親（仮）
class _TourMaker extends State<TourMaker> {

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.66216793880571, 139.63427019724344);

  final List<String> jsonPath = ["assets/highschool.json","assets/info.json"];
  List<LatLng> tourPosition = [];
  int tourNum = 0;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  int _selectedIndex = 1; // BottomNavigationBarの選択状態
  bool _isListVisible = false; // リストの表示状態

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
      final String geoJsonString = await rootBundle.loadString(jsonPath[widget.id]);
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
        tourPosition.add(LatLng(coordinates[1], coordinates[0]));
        final properties = feature['properties'];

        // ここでjsonファイルに格納されている施設情報を取得するよ
        final title = properties['title'] ?? '施設名なし';
        final hours = properties['hours'] ?? '営業時間情報なし';
        final description = properties['description'] ?? '詳細情報なし';

        // infoSnippetにdescriptionとhoursを結合するよ
        final infoSnippet = '${hours.replaceAll(RegExp(r'\r?\n'), '<br>')}<br>${description.replaceAll(RegExp(r'\r?\n'), '<br>')}';


        // マーカーを作成してInfoWindowにぶち込むよ
        markers.add(
          Marker(
            markerId: MarkerId('marker_${feature['id']}'),
            position: LatLng(coordinates[1], coordinates[0]),
            infoWindow: InfoWindow(
              title: title,
              snippet: infoSnippet,
            ),
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

    for (int i = 0; i < features.length; i++) {
      final feature = features[i];
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
              polylineId: PolylineId('polyline_$i'), // 一意のIDを使用
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
    if (index == 1) {
      setState(() {
        _selectedIndex = index;
      });
    } else if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _locationSubscription.cancel(); // 位置情報の監視を停止
    super.dispose();
  }
  void _onNextButtonPressed() {
    setState(() {
      tourNum = (tourNum + 1) % widget.courseList.length; // 次の目的地に移動
    });
    mapController.animateCamera(CameraUpdate.newLatLng(
      tourPosition.elementAt(tourNum)
    ));
    print(widget.courseList[tourNum]);
  }

  void _toggleListVisibility() {
    setState(() {
      _isListVisible = !_isListVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: _toggleListVisibility, // メニューアイコンタップでリスト表示
          ),
        ],
      ),
      body: Stack(
        children: [
          // 少し下に移動させるための余白を追加
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
          
          Column(
            children: [
              Expanded(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.hybrid,
                  markers: _markers..addAll(_currentLocationMarker != null ? {_currentLocationMarker!} : {}),
                  polylines: _polylines..addAll(_polylines),
                  initialCameraPosition: CameraPosition(
                    target: _markers.first.position,
                    zoom: 19.0,
                    bearing: 180,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
                color: Colors.white,
                child: Row(
                  children: [
                    if (tourNum != 0)
                    SizedBox(
                      width: 70, // ボタンの横幅を固定
                      child: Text(
                        '${tourNum == 0 ? "" : "目的地:"}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${widget.courseList[tourNum]}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100, // ボタンの横幅を固定
                      child: RoundedButton(
                        label: '次へ',
                        onPressed: _onNextButtonPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 半透明の背景
        if (_isListVisible)
          GestureDetector(
            onTap: _toggleListVisibility, // 背景タップでリストを閉じる
            child: Container(
              color: Colors.black54, // 半透明の背景
            ),
          ),
        // 右からスライドするリスト
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300), // アニメーションの速度
          top: 0,
          bottom: 0,
          right: _isListVisible ? 0 : -MediaQuery.of(context).size.width * 0.9, // 表示/非表示の位置
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // 幅を画面の80%に設定
            color: Colors.white,
            child: Column(
              children: [
                // ヘッダー部分（閉じるボタン）
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        '案内順',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _toggleListVisibility, // リストを閉じる
                    ),
                  ],
                ),
                // リスト部分
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.courseList.length,
                    itemBuilder: (context, index) {
                      final isCurrent = index == tourNum;
                      return Container(
                        color: isCurrent
                            ? const Color.fromRGBO(166, 202, 236, 1) // 現在の地点の背景色
                            : Colors.transparent, // デフォルトの背景色
                        child: ListTile(
                          title: Text(
                            '${index + 1}. ${widget.courseList[index]}',
                            style: TextStyle(
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              color: isCurrent ? Colors.black : Colors.grey[800],
                            ),
                          ),
                          //onTap: () => _onListItemTap(index), // タップ処理
                        ),
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

