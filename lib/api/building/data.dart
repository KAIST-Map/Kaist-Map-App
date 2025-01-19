import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaist_map/api/api_fetcher.dart';
import 'package:kaist_map/constant/colors.dart';

enum BuildingCategory {
  department,
  dormitory,
  restaurant,
  cafe,
  bank,
  atm,
  convenience,
  gym,
  laundry,
  printer,
  building,
  library,
  etc,
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
      case BuildingCategory.etc:
        return '기타';
      default:
        return '';
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
        return Icon(Icons.atm, color: color, size: size);
      case BuildingCategory.convenience:
        return Icon(Icons.local_grocery_store, color: color, size: size);
      case BuildingCategory.gym:
        return Icon(Icons.fitness_center, color: color, size: size);
      case BuildingCategory.laundry:
        return Icon(Icons.local_laundry_service, color: color, size: size);
      case BuildingCategory.printer:
        return Icon(Icons.print, color: color, size: size);
      case BuildingCategory.building:
        return Icon(Icons.apartment, color: color, size: size);
      case BuildingCategory.library:
        return Icon(Icons.menu_book, color: color, size: size);
      case BuildingCategory.etc:
        return Icon(Icons.more_horiz, color: color, size: size);
      default:
        return Icon(Icons.more_horiz, color: color, size: size);
    }
  }
}

class BuildingData {
  final int id;
  final String name;
  final List<BuildingCategory> categoryIds;
  final List<String> imageUrl;
  final int importance;
  final double latitude;
  final double longitude;
  final List<String> alias;

  BuildingData(
      {required this.id,
      required this.name,
      required this.categoryIds,
      required this.imageUrl,
      required this.latitude,
      required this.longitude,
      required this.importance,
      required this.alias});

  BuildingData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categoryIds = (json['categoryIds'] as List).map((value) => BuildingCategory.values[value]).toList(),
        imageUrl = toList<String>(json['imageUrl']),
        importance = json['importance'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        alias = toList<String>(json['alias']);
      
  Marker toMarker({required String pageName, required VoidCallback onTap}) {
    return Marker(
      markerId: MarkerId("$pageName-$id"),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: name),
      onTap: onTap,
    );
  }

  @override
  String toString() {
    return 'BuildingData{id: $id, name: $name, latitude: $latitude, longitude: $longitude, category: $categoryIds}';
  }
}
