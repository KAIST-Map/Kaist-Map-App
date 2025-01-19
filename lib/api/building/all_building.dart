import 'package:kaist_map/api/api_fetcher.dart';
import 'package:kaist_map/api/building/data.dart';

class AllBuildingLoader extends ApiFetcher<List<BuildingData>> {
  @override
  Future<List<BuildingData>> fetchMock() async {
    return [
      BuildingData(
        id: 1,
        name: '창의학습관',
        latitude: 36.368,
        longitude: 127.363,
        categoryIds: BuildingCategory.values,
        importance: 1,
        imageUrl: [],
        alias: ["창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관"],
      ),
      BuildingData(
        id: 2,
        name: '자연과학동',
        latitude: 36.369,
        longitude: 127.364,
        categoryIds: [BuildingCategory.department],
        importance: 2,
        imageUrl: [],
        alias: ["자과동"],
      ),

      BuildingData(
        id: 3,
        name: '소망관',
        latitude: 36.365,
        longitude: 127.365,
        categoryIds: [BuildingCategory.dormitory],
        importance: 3,
        imageUrl: [],
        alias: [],
      ),
      BuildingData(
        id: 4,
        name: '사랑관',
        latitude: 36.366,
        longitude: 127.366,
        categoryIds: [BuildingCategory.dormitory],
        importance: 4,
        imageUrl: [],
        alias: [],
      ),

      BuildingData(
        id: 5,
        name: '카이마루',
        latitude: 36.367,
        longitude: 127.367,
        categoryIds: [BuildingCategory.restaurant],
        importance: 5,
        imageUrl: [],
        alias: ["카마"],
      ),
      BuildingData(
        id: 6,
        name: '태울관',
        latitude: 36.368,
        longitude: 127.368,
        categoryIds: [BuildingCategory.restaurant],
        importance: 6,
        imageUrl: [],
        alias: [],
      ),

      BuildingData(
        id: 7,
        name: '학술문화관',
        latitude: 36.364,
        longitude: 127.364,
        categoryIds: [BuildingCategory.library],
        importance: 7,
        alias: ["학술관"],
        imageUrl: [],
      ),
      BuildingData(
        id: 8,
        name: '도서관2',
        latitude: 36.365,
        longitude: 127.363,
        categoryIds: [BuildingCategory.library],
        importance: 8,
        alias: [],
        imageUrl: [],
      ),

      BuildingData(
        id: 9,
        name: '카페1',
        latitude: 36.366,
        longitude: 127.362,
        categoryIds: [BuildingCategory.cafe],
        importance: 9,
        imageUrl: [],
        alias: [],
      ),
      BuildingData(
        id: 10,
        name: '카페2',
        latitude: 36.367,
        longitude: 127.361,
        categoryIds: [BuildingCategory.cafe],
        importance: 10,
        alias: [],
        imageUrl: [],
      ),

      BuildingData(
        id: 11,
        name: '동아리1',
        latitude: 36.368,
        longitude: 127.365,
        categoryIds: [BuildingCategory.etc],
        importance: 11,
        alias: [],
        imageUrl: [],
      ),
      BuildingData(
        id: 12,
        name: '동아리2',
        latitude: 36.369,
        longitude: 127.366,
        categoryIds: [BuildingCategory.etc],
        importance: 12,
        alias: [],
        imageUrl: [],
      ),
      BuildingData(
        id: 13,
        name: '기타1',
        latitude: 36.370,
        longitude: 127.367,
        importance: 13,
        alias: [], categoryIds: [],
        imageUrl: [],
      ),
      BuildingData(
        id: 13,
        name: '기타2',
        latitude: 36.370,
        longitude: 127.367,
        importance: 14,
        alias: [], categoryIds: [],
        imageUrl: [],
      ),
    ];
  }

  @override
  Future<List<BuildingData>> fetchReal() {
    throw UnimplementedError();
  }
}
