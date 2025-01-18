import 'package:kaist_map/api/api_loader.dart';
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
        category: BuildingCategory.values,
        importance: 1,
        alias: ["창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관", "창학", "창의관"],
      ),
      BuildingData(
        id: 2,
        name: '자연과학동',
        latitude: 36.369,
        longitude: 127.364,
        category: [BuildingCategory.department],
        importance: 2,
        alias: ["자과동"],
      ),

      BuildingData(
        id: 3,
        name: '소망관',
        latitude: 36.365,
        longitude: 127.365,
        category: [BuildingCategory.dormitory],
        importance: 3,
        alias: [],
      ),
      BuildingData(
        id: 4,
        name: '사랑관',
        latitude: 36.366,
        longitude: 127.366,
        category: [BuildingCategory.dormitory],
        importance: 4,
        alias: [],
      ),

      BuildingData(
        id: 5,
        name: '카이마루',
        latitude: 36.367,
        longitude: 127.367,
        category: [BuildingCategory.restaurant],
        importance: 5,
        alias: ["카마"],
      ),
      BuildingData(
        id: 6,
        name: '태울관',
        latitude: 36.368,
        longitude: 127.368,
        category: [BuildingCategory.restaurant],
        importance: 6,
        alias: [],
      ),

      BuildingData(
        id: 7,
        name: '학술문화관',
        latitude: 36.364,
        longitude: 127.364,
        category: [BuildingCategory.library],
        importance: 7,
        alias: ["학술관"],
      ),
      BuildingData(
        id: 8,
        name: '도서관2',
        latitude: 36.365,
        longitude: 127.363,
        category: [BuildingCategory.library],
        importance: 8,
        alias: [],
      ),

      BuildingData(
        id: 9,
        name: '카페1',
        latitude: 36.366,
        longitude: 127.362,
        category: [BuildingCategory.cafe],
        importance: 9,
        alias: [],
      ),
      BuildingData(
        id: 10,
        name: '카페2',
        latitude: 36.367,
        longitude: 127.361,
        category: [BuildingCategory.cafe],
        importance: 10,
        alias: [],
      ),

      BuildingData(
        id: 11,
        name: '동아리1',
        latitude: 36.368,
        longitude: 127.365,
        category: [BuildingCategory.etc],
        importance: 11,
        alias: [],
      ),
      BuildingData(
        id: 12,
        name: '동아리2',
        latitude: 36.369,
        longitude: 127.366,
        category: [BuildingCategory.etc],
        importance: 12,
        alias: [],
      ),
      BuildingData(
        id: 13,
        name: '기타1',
        latitude: 36.370,
        longitude: 127.367,
        importance: 13,
        alias: [], category: [],
      ),
      BuildingData(
        id: 13,
        name: '기타2',
        latitude: 36.370,
        longitude: 127.367,
        importance: 14,
        alias: [], category: [],
      ),
    ];
  }

  @override
  Future<List<BuildingData>> fetchReal() {
    throw UnimplementedError();
  }
}
