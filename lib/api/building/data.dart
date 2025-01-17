enum BuildingCategory {
  lecture,
  dormitory,
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
}
