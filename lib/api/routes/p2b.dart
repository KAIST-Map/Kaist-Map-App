import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaist_map/api/api_fetcher.dart';
import 'package:kaist_map/api/routes/data.dart';

class P2BLoader extends ApiFetcher<PathData> {
  final double startLatitude;
  final double startLongitude;
  final int endBuildingId;
  final bool wantFreeOfRain;
  final bool wantBeam;

  P2BLoader({
    required this.startLatitude,
    required this.startLongitude,
    required this.endBuildingId,
    required this.wantFreeOfRain,
    required this.wantBeam,
  });

  @override
  Future<PathData> fetchMock() async {
    final mockPath = [
      {
        "id": 1,
        "name": "Start Node",
        "latitude": startLatitude,
        "longitude": startLongitude,
        "buildingId": 1
      },
      {
        "id": 2,
        "name": "End Node",
        "latitude": 36.372,
        "longitude": 127.360,
        "buildingId": endBuildingId
      }
    ];

    final mockResponse = jsonEncode({
      "path": mockPath,
      "totalDistance": 0
    });

    return PathData.fromJson(jsonDecode(mockResponse));
  }

  @override
  Future<PathData> fetchReal() async {
    final queryParameters = {
      'startLatitude': startLatitude.toStringAsFixed(14),
      'startLongitude': startLongitude.toStringAsFixed(14),
      'endBuildingId': endBuildingId.toString(),
      'wantFreeOfRain': wantFreeOfRain.toString(),
      'wantBeam': wantBeam.toString(),
    };

    final uri = Uri.parse('$baseUrl/node/routes/point-to-building').replace(
      queryParameters: queryParameters,
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return PathData.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch route: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch route: $e');
    }
  }
}