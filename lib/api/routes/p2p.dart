import 'dart:convert';
import 'package:kaist_map/api/api_fetcher.dart';
import 'package:kaist_map/api/routes/data.dart';
import 'package:http/http.dart' as http;

class P2PLoader extends ApiFetcher<PathData> {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;
  final bool wantFreeOfRain;
  final bool wantBeam;

  P2PLoader({
    required this.startLatitude,
    required this.startLongitude,
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
        "latitude": startLatitude,
        "longitude": startLongitude,
        "buildingId": 1
      },
      {
        "id": 2,
        "name": "Midpoint Node",
        "latitude": (startLatitude + endLatitude) / 2 + 0.002,
        "longitude": (startLongitude + endLongitude) / 2 + 0.002,
        "buildingId": 2
      },
      {
        "id": 3,
        "name": "End Node",
        "latitude": endLatitude,
        "longitude": endLongitude,
        "buildingId": 3
      }
    ];

    final mockResponse = jsonEncode({"path": mockPath, "totalDistance": 0});

    return PathData.fromJson(jsonDecode(mockResponse));
  }

  @override
  Future<PathData> fetchReal() async {
    final queryParameters = {
      'startLatitude': startLatitude.toStringAsFixed(14),
      'startLongitude': startLongitude.toStringAsFixed(14),
      'endLatitude': endLatitude.toStringAsFixed(14),
      'endLongitude': endLongitude.toStringAsFixed(14),
      'wantFreeOfRain': wantFreeOfRain.toString(),
      'wantBeam': wantBeam.toString(),
    };

    final uri = Uri.parse('$baseUrl/node/routes/point-to-point').replace(
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
