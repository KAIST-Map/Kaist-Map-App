import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum BuildingCategory {
  lecture,
  dormitory,
  restaurant,
  library,
  cafe,
  club,
}

extension BuildingCategoryExtension on BuildingCategory {
  String get name {
    switch (this) {
      case BuildingCategory.lecture:
        return '강의동';
      case BuildingCategory.dormitory:
        return '기숙사';
      case BuildingCategory.restaurant:
        return '식당';
      case BuildingCategory.library:
        return '도서관';
      case BuildingCategory.cafe:
        return '카페';
      case BuildingCategory.club:
        return '동아리';
      default:
        return '';
    }
  }
}

class BuildingData {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  BuildingCategory? category;

  BuildingData(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      this.category});
      
  Marker toMarker({required VoidCallback onTap}) {
    return Marker(
      markerId: MarkerId(id.toString()),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: name),
      onTap: onTap,
    );
  }

  @override
  String toString() {
    return 'BuildingData{id: $id, name: $name, latitude: $latitude, longitude: $longitude, category: $category}';
  }
}
