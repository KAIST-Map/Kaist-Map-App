import 'package:kaist_map/api/node/data.dart';

class PathData {
  final List<NodeData> path;
  final double totalDistance;

  PathData({
    required this.path,
    required this.totalDistance,
  });

  PathData.fromJson(Map<String, dynamic> json)
      : path = (json['path'] as List)
            .map((node) => NodeData.fromJson(node))
            .toList(),
        totalDistance = json['totalDistance'] * 1.0;
}
