import 'package:flutter/material.dart';
import 'package:kaist_map/api/api_fetcher.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:kaist_map/navigation/kakao_map/core.dart';

enum BuildingCategory {
  department, // 1
  dormitory, // 2
  restaurant, // 3
  cafe, // 4
  bank, // 5
  atm, // 6
  convenience, // 7
  gym, // 8
  laundry, // 9
  printer, // 10
  building, // 11
  library, // 12
}

extension BuildingCategoryExtension on BuildingCategory {
  String get name {
    switch (this) {
      case BuildingCategory.department:
        return '학과';
      case BuildingCategory.dormitory:
        return '생활관';
      case BuildingCategory.restaurant:
        return '식당';
      case BuildingCategory.cafe:
        return '카페/편의점';
      case BuildingCategory.bank:
        return '은행';
      case BuildingCategory.atm:
        return 'ATM';
      case BuildingCategory.convenience:
        return '매점';
      case BuildingCategory.gym:
        return '체육시설';
      case BuildingCategory.laundry:
        return '세탁소';
      case BuildingCategory.printer:
        return '인쇄';
      case BuildingCategory.building:
        return '건물';
      case BuildingCategory.library:
        return '도서관';
    }
  }

  Icon getIcon({MaterialColor color = KMapColors.darkGray, double size = 24}) {
    switch (this) {
      case BuildingCategory.department:
        return Icon(Icons.school, color: color, size: size);
      case BuildingCategory.dormitory:
        return Icon(Icons.home, color: color, size: size);
      case BuildingCategory.restaurant:
        return Icon(Icons.restaurant, color: color, size: size);
      case BuildingCategory.cafe:
        return Icon(Icons.local_cafe, color: color, size: size);
      case BuildingCategory.bank:
        return Icon(Icons.account_balance, color: color, size: size);
      case BuildingCategory.atm:
        return Icon(Icons.local_atm, color: color, size: size);
      case BuildingCategory.convenience:
        return Icon(Icons.storefront_rounded, color: color, size: size);
      case BuildingCategory.gym:
        return Icon(Icons.sports_basketball_rounded, color: color, size: size);
      case BuildingCategory.laundry:
        return Icon(Icons.local_laundry_service, color: color, size: size);
      case BuildingCategory.printer:
        return Icon(Icons.print, color: color, size: size);
      case BuildingCategory.building:
        return Icon(Icons.apartment, color: color, size: size);
      case BuildingCategory.library:
        return Icon(Icons.menu_book, color: color, size: size);
    }
  }
}

class BuildingData {
  final int id;
  final String name;
  final List<BuildingCategory> categories;
  final List<String> imageUrls;
  final int importance;
  final double latitude;
  final double longitude;
  final List<String> alias;

  BuildingData(
      {required this.id,
      required this.name,
      required this.categories,
      required this.imageUrls,
      required this.latitude,
      required this.longitude,
      required this.importance,
      required this.alias});

  BuildingData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categories = (json['categoryIds'] as List)
            .map((value) => BuildingCategory.values[value - 1])
            .toList(),
        imageUrls = json['imageUrls']
            .toString()
            .trim()
            .replaceAll(RegExp(r'^\[|\]$'), '')
            .split(","),
        importance = json['importance'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        alias = toList<String>(json['alias']);

  Marker toMarker({required VoidCallback onTap}) {
    return Marker.fromBuildingData(this, onTap);
  }

  @override
  String toString() {
    return 'BuildingData{id: $id, name: $name, latitude: $latitude, longitude: $longitude, category: $categories}';
  }
}
