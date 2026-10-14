class FavoriteRoute {
  final int? id;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final String travelMode;
  final String distance;
  final String duration;
  final String encodedPolyline;
  final String createdAt;

  const FavoriteRoute({
    this.id,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.travelMode,
    required this.distance,
    required this.duration,
    required this.encodedPolyline,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'start_lat': startLat,
      'start_lng': startLng,
      'end_lat': endLat,
      'end_lng': endLng,
      'travel_mode': travelMode,
      'distance': distance,
      'duration': duration,
      'encoded_polyline': encodedPolyline,
      'created_at': createdAt,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory FavoriteRoute.fromMap(Map<String, dynamic> map) {
    return FavoriteRoute(
      id: map['id'] as int?,
      startLat: (map['start_lat'] as num).toDouble(),
      startLng: (map['start_lng'] as num).toDouble(),
      endLat: (map['end_lat'] as num).toDouble(),
      endLng: (map['end_lng'] as num).toDouble(),
      travelMode: map['travel_mode'] as String,
      distance: map['distance'] as String,
      duration: map['duration'] as String,
      encodedPolyline: map['encoded_polyline'] as String,
      createdAt: map['created_at'] as String,
    );
  }
}
