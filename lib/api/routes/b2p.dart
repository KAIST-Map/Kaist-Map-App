import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaist_map/api/api_fetcher.dart';
import 'package:kaist_map/api/routes/data.dart';

class B2PLoader extends ApiFetcher<PathData> {
  final int startBuildingId;
  final double endLatitude;
  final double endLongitude;
  final bool wantFreeOfRain;
  final bool wantBeam;

  B2PLoader({
    required this.startBuildingId,
    required this.endLatitude,
    required this.endLongitude,
    required this.wantFreeOfRain,
    required this.wantBeam,
  });

  @override
  Future<PathData> fetchMock() async {
    final mockPath = [
      {
        "id": 1,
        "name": "Start Node",
        "latitude": 36.372,
        "longitude": 127.360,
        "buildingId": startBuildingId
      },
      {
        "id": 2,
        "name": "End Node",
        "latitude": endLatitude,
        "longitude": endLongitude,
        "buildingId": 1
      }
    ];

    final mockResponse = jsonEncode({"path": mockPath, "totalDistance": 0});

    return PathData.fromJson(jsonDecode(mockResponse));
  }

  @override
  Future<PathData> fetchReal() async {
    final queryParameters = {
      'startBuildingId': startBuildingId.toString(),
      'endLatitude': endLatitude.toStringAsFixed(14),
      'endLongitude': endLongitude.toStringAsFixed(14),
      'wantFreeOfRain': wantFreeOfRain.toString(),
      'wantBeam': wantBeam.toString(),
    };

    final uri = Uri.parse('$baseUrl/node/routes/building-to-point').replace(
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
