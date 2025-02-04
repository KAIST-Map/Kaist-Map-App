import 'package:kaist_map/navigation/kakao_map/core.dart';

class NodeData {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int? buildingId;

  NodeData({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.buildingId,
  });

  NodeData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        buildingId = json['buildingId'];

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
