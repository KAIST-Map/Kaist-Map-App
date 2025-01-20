// building/search.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaist_map/api/api_fetcher.dart';
import 'package:kaist_map/api/building/data.dart';

class BuildingSearchLoader extends ApiFetcher<List<BuildingData>> {
  final String name;

  BuildingSearchLoader({
    required this.name,
  });

  @override
  Future<List<BuildingData>> fetchMock() async {
    const exampleResponse = """
      {
        "buildings": [
          {
            "id": 1,
            "name": "Building 1",
            "imageUrl": [
              "https://example.com/image.jpg",
              "https://example.com/image2.jpg"
            ],
            "importance": 1,
            "latitude": 37.123456,
            "longitude": 127.123456,
            "categoryIds": [1, 2, 3],
            "alias": ["Building 1", "Building 2"]
          }
        ]
      }
    """;

    return jsonDecode(exampleResponse)['buildings']
        .map<BuildingData>((building) => BuildingData.fromJson(building))
        .toList();
  }

  @override
  Future<List<BuildingData>> fetchReal() async {
    final uri = Uri.parse('$baseUrl/building/$name');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['buildings']
            .map<BuildingData>((building) => BuildingData.fromJson(building))
            .toList();
      } else {
        throw Exception('Failed to search buildings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search buildings: $e');
    }
  }
}
