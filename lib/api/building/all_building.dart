import 'dart:convert';

import 'package:kaist_map/api/api_fetcher.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:http/http.dart' as http;

class AllBuildingLoader extends ApiFetcher<List<BuildingData>> {
  @override
  Future<List<BuildingData>> fetchMock() async {
    return [
      BuildingData(
        id: 1,
        name: '창의학습관',
        latitude: 36.368,
        longitude: 127.363,
        categories: BuildingCategory.values,
        importance: 1,
        imageUrls: [],
        alias: [
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관",
          "창학",
          "창의관"
        ],
      ),
      BuildingData(
        id: 2,
        name: '자연과학동',
        latitude: 36.369,
        longitude: 127.364,
        categories: [BuildingCategory.department],
        importance: 2,
        imageUrls: [],
        alias: ["자과동"],
      ),
      BuildingData(
        id: 3,
        name: '소망관',
        latitude: 36.365,
        longitude: 127.365,
        categories: [BuildingCategory.dormitory],
        importance: 3,
        imageUrls: [],
        alias: [],
      ),
      BuildingData(
        id: 4,
        name: '사랑관',
        latitude: 36.366,
        longitude: 127.366,
        categories: [BuildingCategory.dormitory],
        importance: 4,
        imageUrls: [],
        alias: [],
      ),
      BuildingData(
        id: 5,
        name: '카이마루',
        latitude: 36.367,
        longitude: 127.367,
        categories: [BuildingCategory.restaurant],
        importance: 5,
        imageUrls: [],
        alias: ["카마"],
      ),
      BuildingData(
        id: 6,
        name: '태울관',
        latitude: 36.368,
        longitude: 127.368,
        categories: [BuildingCategory.restaurant],
        importance: 6,
        imageUrls: [],
        alias: [],
      ),
      BuildingData(
        id: 7,
        name: '학술문화관',
        latitude: 36.364,
        longitude: 127.364,
        categories: [BuildingCategory.library],
        importance: 7,
        alias: ["학술관"],
        imageUrls: [],
      ),
      BuildingData(
        id: 8,
        name: '도서관2',
        latitude: 36.365,
        longitude: 127.363,
        categories: [BuildingCategory.library],
        importance: 8,
        alias: [],
        imageUrls: [],
      ),
      BuildingData(
        id: 9,
        name: '카페1',
        latitude: 36.366,
        longitude: 127.362,
        categories: [BuildingCategory.cafe],
        importance: 9,
        imageUrls: [],
        alias: [],
      ),
      BuildingData(
        id: 10,
        name: '카페2',
        latitude: 36.367,
        longitude: 127.361,
        categories: [BuildingCategory.cafe],
        importance: 10,
        alias: [],
        imageUrls: [],
      ),
      BuildingData(
        id: 11,
        name: '동아리1',
        latitude: 36.368,
        longitude: 127.365,
        categories: [BuildingCategory.etc],
        importance: 11,
        alias: [],
        imageUrls: [],
      ),
      BuildingData(
        id: 12,
        name: '동아리2',
        latitude: 36.369,
        longitude: 127.366,
        categories: [BuildingCategory.etc],
        importance: 12,
        alias: [],
        imageUrls: [],
      ),
      BuildingData(
        id: 13,
        name: '기타1',
        latitude: 36.370,
        longitude: 127.367,
        importance: 13,
        alias: [],
        categories: [],
        imageUrls: [],
      ),
      BuildingData(
        id: 13,
        name: '기타2',
        latitude: 36.370,
        longitude: 127.367,
        importance: 14,
        alias: [],
        categories: [],
        imageUrls: [],
      ),
    ];
  }

  @override
  Future<List<BuildingData>> fetchReal() async {
    final uri = Uri.parse('$baseUrl/building');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },).timeout(const Duration(seconds: 5));

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
