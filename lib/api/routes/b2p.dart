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
    const exampleResponse = """
      {
        "path": [
          {
            "id": 1,
            "name": "Node 1",
            "latitude": 37.4123,
            "longitude": 127.1234,
            "buildingId": 1
          }
        ],
        "totalDistance": 0
      }
    """;

    return PathData.fromJson(jsonDecode(exampleResponse));
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