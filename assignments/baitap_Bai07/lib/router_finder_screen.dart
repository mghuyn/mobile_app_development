import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'database_helper.dart';
import 'favorite_route.dart';
import 'favorite_routes_screen.dart';

class RouteFinderScreen extends StatefulWidget {
  const RouteFinderScreen({super.key});

  @override
  State<RouteFinderScreen> createState() => _RouteFinderScreenState();
}

class _RouteFinderScreenState extends State<RouteFinderScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  LatLng? _startLatLng;
  LatLng? _endLatLng;

  // Giữ nguyên các API key đang có trong bài của bạn.
  final String geocodingApiKey = 'AIzaSyDQ1uaEgLGEcV3fIUieBLD0KIZ-Ytb7A2k';
  final String placesApiKey = 'AIzaSyDQ1uaEgLGEcV3fIUieBLD0KIZ-Ytb7A2k';
  final String routesApiKey = 'AIzaSyDQ1uaEgLGEcV3fIUieBLD0KIZ-Ytb7A2k';

  String _distance = '';
  String _duration = '';
  String _placeSearch = '';

  // Bổ sung theo Bai07: chọn phương tiện.
  String _selectedTravelMode = 'DRIVE';

  // Polyline gần nhất để lưu vào SQLite.
  String _lastEncodedPolyline = '';

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _travelModeLabel(String mode) {
    switch (mode) {
      case 'WALK':
        return 'Đi bộ';
      case 'TWO_WHEELER':
        return 'Xe máy';
      case 'DRIVE':
      default:
        return 'Ô tô';
    }
  }

  IconData _travelModeIcon(String mode) {
    switch (mode) {
      case 'WALK':
        return Icons.directions_walk;
      case 'TWO_WHEELER':
        return Icons.two_wheeler;
      case 'DRIVE':
      default:
        return Icons.directions_car;
    }
  }

  // Lấy vị trí hiện tại làm điểm xuất phát.
  Future<void> _getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Vui lòng bật dịch vụ vị trí!');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _showMessage('Bạn chưa cấp quyền truy cập vị trí.');
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      _showMessage(
        'Quyền vị trí đã bị từ chối vĩnh viễn. Hãy bật lại trong Cài đặt.',
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!mounted) return;

    final current = LatLng(position.latitude, position.longitude);
    setState(() {
      _startLatLng = current;
      _startController.text = '${position.latitude}, ${position.longitude}';
      _markers.removeWhere((marker) => marker.markerId.value == 'Xuất phát');
      _markers.add(
        Marker(
          markerId: const MarkerId('Xuất phát'),
          position: current,
          infoWindow: const InfoWindow(title: 'Xuất phát'),
        ),
      );
    });

    await _moveCamera(current);
  }

  // Lấy vị trí hiện tại làm điểm đích.
  Future<void> _setCurrentLocationAsDestination() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Vui lòng bật dịch vụ vị trí!');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showMessage('Không thể lấy vị trí hiện tại do chưa có quyền vị trí.');
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!mounted) return;

    final current = LatLng(position.latitude, position.longitude);
    setState(() {
      _endLatLng = current;
      _endController.text = '${position.latitude}, ${position.longitude}';
      _markers.removeWhere((marker) => marker.markerId.value == 'Đích đến');
      _markers.add(
        Marker(
          markerId: const MarkerId('Đích đến'),
          position: current,
          infoWindow: const InfoWindow(title: 'Đích đến'),
        ),
      );
    });

    await _moveCamera(current);
  }

  // Chọn điểm đích bằng cách chạm vào bản đồ.
  void _selectDestinationOnMap(LatLng position) {
    setState(() {
      _endLatLng = position;
      _endController.text = '${position.latitude}, ${position.longitude}';
      _markers.removeWhere((marker) => marker.markerId.value == 'Đích đến');
      _markers.add(
        Marker(
          markerId: const MarkerId('Đích đến'),
          position: position,
          infoWindow: const InfoWindow(title: 'Đích đến'),
        ),
      );
    });
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  Future<void> _fitRoute(LatLng start, LatLng end) async {
    final controller = await _controller.future;

    if (start.latitude == end.latitude && start.longitude == end.longitude) {
      await controller.animateCamera(CameraUpdate.newLatLngZoom(start, 16));
      return;
    }

    final southWest = LatLng(
      start.latitude < end.latitude ? start.latitude : end.latitude,
      start.longitude < end.longitude ? start.longitude : end.longitude,
    );
    final northEast = LatLng(
      start.latitude > end.latitude ? start.latitude : end.latitude,
      start.longitude > end.longitude ? start.longitude : end.longitude,
    );

    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: southWest, northeast: northEast),
        70,
      ),
    );
  }

  LatLng? _parseLatLng(String value) {
    final parts = value.split(',');
    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());

    if (lat == null || lng == null) return null;
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;

    return LatLng(lat, lng);
  }

  // Tìm đường đi. Travel mode được lấy từ DropdownButton bên dưới.
  Future<void> _findRoute() async {
    if (_startController.text.trim().isEmpty ||
        _endController.text.trim().isEmpty) {
      _showMessage('Vui lòng nhập cả hai điểm!');
      return;
    }

    final start = _parseLatLng(_startController.text);
    final end = _parseLatLng(_endController.text);

    if (start == null || end == null) {
      _showMessage('Tọa độ không hợp lệ. Định dạng đúng: latitude, longitude');
      return;
    }

    _startLatLng = start;
    _endLatLng = end;

    const url = 'https://routes.googleapis.com/directions/v2:computeRoutes';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': routesApiKey,
          'X-Goog-FieldMask': 'routes.polyline.encodedPolyline,routes.distanceMeters,routes.duration',
        },
        body: jsonEncode({
          'origin': {
            'location': {
              'latLng': {
                'latitude': start.latitude,
                'longitude': start.longitude,
              },
            },
          },
          'destination': {
            'location': {
              'latLng': {'latitude': end.latitude, 'longitude': end.longitude},
            },
          },
          // DRIVE = ô tô, WALK = đi bộ, TWO_WHEELER = xe máy.
          'travelMode': _selectedTravelMode,
          'computeAlternativeRoutes': false,
          'languageCode': 'vi-VN',
          'units': 'METRIC',
        }),
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        _showMessage(
          'Lỗi Routes API: ${response.statusCode}. ${response.body}',
        );
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final routes = data['routes'] as List<dynamic>?;

      if (routes == null || routes.isEmpty) {
        _showMessage('Không tìm thấy tuyến đường nào!');
        return;
      }

      // Tuyến đầu tiên là tuyến Google Routes API đánh giá phù hợp/tối ưu nhất.
      final route = routes.first as Map<String, dynamic>;
      final polyline = route['polyline'] as Map<String, dynamic>?;
      final polylinePoints = polyline?['encodedPolyline'] as String? ?? '';

      if (polylinePoints.isEmpty) {
        _showMessage('Không lấy được dữ liệu đường đi.');
        return;
      }

      final distanceMeters = (route['distanceMeters'] as num?)?.toDouble() ?? 0;
      final durationText = route['duration'] as String? ?? '0s';
      final durationSeconds =
          double.tryParse(durationText.replaceAll('s', '')) ?? 0;

      final distanceKm = distanceMeters / 1000;
      final minutes = (durationSeconds / 60).round();
      final points = _decodePolyline(polylinePoints);

      setState(() {
        _distance = '${distanceKm.toStringAsFixed(2)} km';
        _duration = '$minutes phút';
        _lastEncodedPolyline = polylinePoints;

        _markers.removeWhere(
          (marker) =>
              marker.markerId.value == 'Xuất phát' ||
              marker.markerId.value == 'Đích đến',
        );
        _markers.add(
          Marker(
            markerId: const MarkerId('Xuất phát'),
            position: start,
            infoWindow: const InfoWindow(title: 'Xuất phát'),
          ),
        );
        _markers.add(
          Marker(
            markerId: const MarkerId('Đích đến'),
            position: end,
            infoWindow: const InfoWindow(title: 'Đích đến'),
          ),
        );

        _polylines
          ..clear()
          ..add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: Colors.blue,
              width: 5,
            ),
          );
      });

      await _fitRoute(start, end);
    } catch (e) {
      _showMessage('Không thể tìm đường: $e');
    }
  }

  // Tìm kiếm địa điểm bằng Places API (New) - giữ nguyên chức năng cũ.
  Future<void> _searchPlaces() async {
    if (_placeSearch.trim().isEmpty) {
      _showMessage('Vui lòng nhập địa điểm cần tìm!');
      return;
    }

    if (_startLatLng == null) {
      _showMessage('Chưa lấy được vị trí hiện tại!');
      return;
    }

    const url = 'https://places.googleapis.com/v1/places:searchText';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': placesApiKey,
          'X-Goog-FieldMask':
              'places.displayName,places.formattedAddress,places.location',
        },
        body: jsonEncode({
          'textQuery': _placeSearch,
          'languageCode': 'vi',
          'maxResultCount': 10,
          'locationBias': {
            'circle': {
              'center': {
                'latitude': _startLatLng!.latitude,
                'longitude': _startLatLng!.longitude,
              },
              'radius': 5000.0,
            },
          },
        }),
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        _showMessage('Lỗi Places API: ${response.statusCode}');
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final places = data['places'] as List<dynamic>?;

      if (places == null || places.isEmpty) {
        _showMessage('Không tìm thấy địa điểm nào!');
        return;
      }

      final placeMarkers = <Marker>{};
      for (int i = 0; i < places.length; i++) {
        final place = places[i] as Map<String, dynamic>;
        final location = place['location'] as Map<String, dynamic>?;
        if (location == null) continue;

        final latitude = (location['latitude'] as num).toDouble();
        final longitude = (location['longitude'] as num).toDouble();
        final displayName = place['displayName'] as Map<String, dynamic>?;
        final name = displayName?['text'] as String? ?? 'Địa điểm';
        final address = place['formattedAddress'] as String? ?? '';

        placeMarkers.add(
          Marker(
            markerId: MarkerId('place_$i'),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: name, snippet: address),
          ),
        );
      }

      setState(() {
        _markers.removeWhere(
          (marker) => marker.markerId.value.startsWith('place_'),
        );
        _markers.addAll(placeMarkers);
      });
    } catch (e) {
      _showMessage('Không thể tìm địa điểm: $e');
    }
  }

  // Chuyển địa chỉ thành tọa độ bằng Geocoding API - giữ nguyên chức năng cũ.
  Future<void> _geocodeAddress() async {
    if (_addressController.text.trim().isEmpty) {
      _showMessage('Vui lòng nhập địa chỉ!');
      return;
    }

    final address = Uri.encodeComponent(_addressController.text.trim());
    final url = 'https://geocode.googleapis.com/v4/geocode/address/$address';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'X-Goog-Api-Key': geocodingApiKey},
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        _showMessage('Lỗi Geocoding API: ${response.statusCode}');
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>?;

      if (results == null || results.isEmpty) {
        _showMessage('Không tìm thấy địa chỉ!');
        return;
      }

      final result = results.first as Map<String, dynamic>;
      final location = result['location'] as Map<String, dynamic>;
      final latitude = (location['latitude'] as num).toDouble();
      final longitude = (location['longitude'] as num).toDouble();
      final destination = LatLng(latitude, longitude);

      setState(() {
        _endLatLng = destination;
        _endController.text = '$latitude, $longitude';
        _markers.removeWhere((marker) => marker.markerId.value == 'Đích đến');
        _markers.add(
          Marker(
            markerId: const MarkerId('Đích đến'),
            position: destination,
            infoWindow: const InfoWindow(title: 'Đích đến'),
          ),
        );
      });

      await _moveCamera(destination);
    } catch (e) {
      _showMessage('Không thể chuyển địa chỉ thành tọa độ: $e');
    }
  }

  // Bổ sung Bai07: lưu tuyến hiện tại vào SQLite.
  Future<void> _saveFavoriteRoute() async {
    if (_startLatLng == null ||
        _endLatLng == null ||
        _lastEncodedPolyline.isEmpty ||
        _distance.isEmpty ||
        _duration.isEmpty) {
      _showMessage('Hãy tìm đường trước khi lưu tuyến yêu thích.');
      return;
    }

    final route = FavoriteRoute(
      startLat: _startLatLng!.latitude,
      startLng: _startLatLng!.longitude,
      endLat: _endLatLng!.latitude,
      endLng: _endLatLng!.longitude,
      travelMode: _selectedTravelMode,
      distance: _distance,
      duration: _duration,
      encodedPolyline: _lastEncodedPolyline,
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      await DatabaseHelper.instance.insertFavorite(route);
      _showMessage('Đã lưu tuyến vào danh sách yêu thích.');
    } catch (e) {
      _showMessage('Không thể lưu tuyến: $e');
    }
  }

  // Mở danh sách SQLite và nhận lại tuyến người dùng muốn xem.
  Future<void> _openFavoriteRoutes() async {
    final favorite = await Navigator.push<FavoriteRoute>(
      context,
      MaterialPageRoute(builder: (_) => const FavoriteRoutesScreen()),
    );

    if (favorite == null || !mounted) return;
    await _showFavoriteRoute(favorite);
  }

  // Hiển thị lại tuyến đã lưu mà không cần gọi Routes API lần nữa.
  Future<void> _showFavoriteRoute(FavoriteRoute favorite) async {
    final start = LatLng(favorite.startLat, favorite.startLng);
    final end = LatLng(favorite.endLat, favorite.endLng);
    final points = _decodePolyline(favorite.encodedPolyline);

    setState(() {
      _startLatLng = start;
      _endLatLng = end;
      _selectedTravelMode = favorite.travelMode;
      _distance = favorite.distance;
      _duration = favorite.duration;
      _lastEncodedPolyline = favorite.encodedPolyline;

      _startController.text = '${favorite.startLat}, ${favorite.startLng}';
      _endController.text = '${favorite.endLat}, ${favorite.endLng}';

      _markers.removeWhere(
        (marker) =>
            marker.markerId.value == 'Xuất phát' ||
            marker.markerId.value == 'Đích đến',
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('Xuất phát'),
          position: start,
          infoWindow: const InfoWindow(title: 'Xuất phát'),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('Đích đến'),
          position: end,
          infoWindow: const InfoWindow(title: 'Đích đến'),
        ),
      );

      _polylines
        ..clear()
        ..add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        );
    });

    await _fitRoute(start, end);
  }

  // Giải mã polyline.
  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    final len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Finder'),
        actions: [
          IconButton(
            tooltip: 'Tuyến yêu thích',
            onPressed: _openFavoriteRoutes,
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: Column(
        children: [
          // Cho cuộn phần nhập liệu để không bị tràn màn hình trên điện thoại nhỏ.
          Flexible(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Nhập địa chỉ',
                      hintText: 'Ví dụ: 227 Nguyễn Văn Cừ, TP.HCM',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _geocodeAddress,
                    icon: const Icon(Icons.pin_drop),
                    label: const Text('Chuyển địa chỉ thành tọa độ'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Tìm địa điểm',
                      hintText: 'Ví dụ: quán ăn, bệnh viện, trường học...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      _placeSearch = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _searchPlaces,
                    icon: const Icon(Icons.place),
                    label: const Text('Tìm địa điểm'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _startController,
                    decoration: const InputDecoration(
                      labelText: 'Điểm xuất phát (lat, lng)',
                    ),
                  ),
                  TextField(
                    controller: _endController,
                    decoration: const InputDecoration(
                      labelText: 'Điểm đích (lat, lng)',
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _setCurrentLocationAsDestination,
                      icon: const Icon(Icons.my_location),
                      label: const Text('Lấy vị trí hiện tại làm điểm đích'),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Bổ sung Bai07: chọn loại phương tiện.
                  DropdownButtonFormField<String>(
                    value: _selectedTravelMode,
                    decoration: const InputDecoration(
                      labelText: 'Phương tiện',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'DRIVE',
                        child: Row(
                          children: [
                            Icon(Icons.directions_car),
                            SizedBox(width: 8),
                            Text('Ô tô'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'WALK',
                        child: Row(
                          children: [
                            Icon(Icons.directions_walk),
                            SizedBox(width: 8),
                            Text('Đi bộ'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'TWO_WHEELER',
                        child: Row(
                          children: [
                            Icon(Icons.two_wheeler),
                            SizedBox(width: 8),
                            Text('Xe máy'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedTravelMode = value;
                        // Bắt người dùng tìm lại để thông tin phù hợp phương tiện mới.
                        _distance = '';
                        _duration = '';
                        _lastEncodedPolyline = '';
                        _polylines.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _findRoute,
                        icon: Icon(_travelModeIcon(_selectedTravelMode)),
                        label: Text(
                          'Tìm đường (${_travelModeLabel(_selectedTravelMode)})',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _saveFavoriteRoute,
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Lưu tuyến'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _openFavoriteRoutes,
                        icon: const Icon(Icons.list),
                        label: const Text('Tuyến yêu thích'),
                      ),
                    ],
                  ),
                  if (_distance.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Khoảng cách: $_distance',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                  if (_duration.isNotEmpty)
                    Text(
                      'Thời gian: $_duration',
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
              onTap: _selectDestinationOnMap,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
