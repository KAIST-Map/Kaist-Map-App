import 'package:flutter/foundation.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/constant/network_assets.dart';

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude.toStringAsFixed(14),
      'lng': longitude.toStringAsFixed(14),
    };
  }

  LatLng.fromJson(Map<String, dynamic> json)
      : latitude = double.parse(json['lat']),
        longitude = double.parse(json['lng']);

  @override
  String toString() {
    return 'LatLng{latitude: $latitude, longitude: $longitude}';
  }
}

class Marker {
  final String name;
  final double lat;
  final double lng;
  final String image;
  final double width;
  final double height;
  final double offsetY;
  final bool draggable;
  final int importance;
  final VoidCallback onTap;

  Marker({
    required this.name,
    required this.lat,
    required this.lng,
    required this.image,
    this.width = 30,
    this.height = 35,
    this.offsetY = 35,
    required this.draggable,
    required this.importance,
    required this.onTap,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat.toStringAsFixed(14),
      'lng': lng.toStringAsFixed(14),
      'image': image,
      'width': width,
      'height': height,
      'offsetY': offsetY,
      'draggable': draggable,
      'importance': importance,
    };
  }

  Marker.fromBuildingData(BuildingData buildingData, this.onTap)
      : name = "building-${buildingData.id}",
        lat = buildingData.latitude,
        lng = buildingData.longitude,
        image = PinImages.defaultPin,
        width = 26,
        height = 32,
        offsetY = 32,
        draggable = false,
        importance = buildingData.importance;

  Marker copyWith(
      {String? name,
      double? lat,
      double? lng,
      String? image,
      double? width,
      double? height,
      double? offsetY,
      bool? draggable,
      int? importance,
      VoidCallback? onTap}) {
    return Marker(
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      image: image ?? this.image,
      width: width ?? this.width,
      height: height ?? this.height,
      offsetY: offsetY ?? this.offsetY,
      draggable: draggable ?? this.draggable,
      importance: importance ?? this.importance,
      onTap: onTap ?? this.onTap,
    );
  }
}

class Polyline {
  final List<LatLng> path;
  final double strokeWeight;
  final String strokeColor;

  /// "#{hex color}"
  final double strokeOpacity;

  /// 0 ~ 1
  final String strokeStyle;

  /// 'solid' | 'shortdot' | 'dot'

  Polyline({
    required this.path,
    required this.strokeWeight,
    required this.strokeColor,
    required this.strokeOpacity,
    required this.strokeStyle,
  });

  Map<String, dynamic> toJson() {
    return {
      'path': path
          .map((latLng) => {'lat': latLng.latitude, 'lng': latLng.longitude})
          .toList(),
      'strokeWeight': strokeWeight,
      'strokeColor': strokeColor,
      'strokeOpacity': strokeOpacity,
      'strokeStyle': strokeStyle,
    };
  }
}
