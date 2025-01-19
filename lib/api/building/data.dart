import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
        return const Icon(Icons.school);
      case BuildingCategory.dormitory:
        return const Icon(Icons.home);
      case BuildingCategory.restaurant:
        return const Icon(Icons.restaurant);
      case BuildingCategory.cafe:
        return const Icon(Icons.local_cafe);
      case BuildingCategory.bank:
        return const Icon(Icons.account_balance);
      case BuildingCategory.atm:
        return const Icon(Icons.atm);
      case BuildingCategory.convenience:
        return const Icon(Icons.local_grocery_store);
      case BuildingCategory.gym:
        return const Icon(Icons.fitness_center);
      case BuildingCategory.laundry:
        return const Icon(Icons.local_laundry_service);
      case BuildingCategory.printer:
        return const Icon(Icons.print);
      case BuildingCategory.building:
        return const Icon(Icons.apartment);
      case BuildingCategory.library:
        return const Icon(Icons.menu_book);
      case BuildingCategory.etc:
        return const Icon(Icons.more_horiz);
      default:
        return const Icon(Icons.more_horiz);
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
    return 'BuildingData{id: $id, name: $name, latitude: $latitude, longitude: $longitude, category: $categoryIds}';
  }
}
