class NodeData {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int? buildingId;
  final String? imageUrl;

  NodeData({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.buildingId,
    this.imageUrl,
  });
}