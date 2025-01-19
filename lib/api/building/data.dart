import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  Icon get icon {
    switch (this) {
      case BuildingCategory.department:
      return const Icon(Icons.school, color: KMapColors.darkGray);
      case BuildingCategory.dormitory:
      return const Icon(Icons.home, color: KMapColors.darkGray);
      case BuildingCategory.restaurant:
      return const Icon(Icons.restaurant, color: KMapColors.darkGray);
      case BuildingCategory.cafe:
      return const Icon(Icons.local_cafe, color: KMapColors.darkGray);
      case BuildingCategory.bank:
      return const Icon(Icons.account_balance, color: KMapColors.darkGray);
      case BuildingCategory.atm:
      return const Icon(Icons.atm, color: KMapColors.darkGray);
      case BuildingCategory.convenience:
      return const Icon(Icons.local_grocery_store, color: KMapColors.darkGray);
      case BuildingCategory.gym:
      return const Icon(Icons.fitness_center, color: KMapColors.darkGray);
      case BuildingCategory.laundry:
      return const Icon(Icons.local_laundry_service, color: KMapColors.darkGray);
      case BuildingCategory.printer:
      return const Icon(Icons.print, color: KMapColors.darkGray);
      case BuildingCategory.building:
      return const Icon(Icons.apartment, color: KMapColors.darkGray);
      case BuildingCategory.library:
      return const Icon(Icons.menu_book, color: KMapColors.darkGray);
      case BuildingCategory.etc:
      return const Icon(Icons.more_horiz, color: KMapColors.darkGray);
      default:
      return const Icon(Icons.more_horiz, color: KMapColors.darkGray);
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
        categoryIds = (json['category'] as List<int>).map((value) => BuildingCategory.values[value]).toList(),
        imageUrl = json['imageUrl'],
        importance = json['importance'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        alias = json['alias'];
      
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
