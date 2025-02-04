import 'package:flutter/material.dart';
import 'package:kaist_map/api/node/data.dart';
import 'package:kaist_map/constant/colors.dart';

class PathETA {
  final int eta;
  final int distance;

  PathETA({
    required this.eta,
    required this.distance,
  });

  Widget toCard() {
    return Card(
      color: KMapColors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.schedule,
              color: KMapColors.darkBlue,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              "$eta분 / ",
              style: const TextStyle(
                color: KMapColors.darkBlue,
              ),
            ),
            const Icon(
              Icons.route,
              color: KMapColors.darkBlue,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              "${distance}m",
              style: const TextStyle(
                color: KMapColors.darkBlue,
              ),
            )
          ],
        ),
      ),
    );
  }
}

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

  PathETA getETA({
    required bool wantBeam,
    required bool wantFreeOfRain,
  }) {
    final int distance = _getEuclideanDistance().ceil();
    final int eta = ((wantFreeOfRain ? distance : totalDistance) / 70).ceil();
    return PathETA(eta: eta, distance: distance);
  }

  double _getEuclideanDistance() {
    double distance = 0;
    for (int i = 0; i < path.length - 1; i++) {
      distance += path[i].toLatLng().distanceToMeters(path[i + 1].toLatLng());
    }
    return distance;
  }
}
