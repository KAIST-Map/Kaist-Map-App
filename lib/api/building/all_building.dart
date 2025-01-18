import 'package:kaist_map/api/api_loader.dart';
import 'package:kaist_map/api/building/data.dart';

class AllBuildingLoader extends ApiFetcher<List<BuildingData>> {
  @override
  Future<List<BuildingData>> fetchMock() async {
    return [
      BuildingData(
        id: 1,
        name: '강의동1',
        latitude: 36.368,
        longitude: 127.363,
        category: BuildingCategory.lecture,
      ),
      BuildingData(
        id: 2,
        name: '강의동2',
        latitude: 36.369,
        longitude: 127.364,
        category: BuildingCategory.lecture,
      ),

      BuildingData(
        id: 3,
        name: '기숙사1',
        latitude: 36.365,
        longitude: 127.365,
        category: BuildingCategory.dormitory,
      ),
      BuildingData(
        id: 4,
        name: '기숙사2',
        latitude: 36.366,
        longitude: 127.366,
        category: BuildingCategory.dormitory,
      ),

      BuildingData(
        id: 5,
        name: '식당1',
        latitude: 36.367,
        longitude: 127.367,
        category: BuildingCategory.restaurant,
      ),
      BuildingData(
        id: 6,
        name: '식당2',
        latitude: 36.368,
        longitude: 127.368,
        category: BuildingCategory.restaurant,
      ),

      BuildingData(
        id: 7,
        name: '도서관1',
        latitude: 36.364,
        longitude: 127.364,
        category: BuildingCategory.library,
      ),
      BuildingData(
        id: 8,
        name: '도서관2',
        latitude: 36.365,
        longitude: 127.363,
        category: BuildingCategory.library,
      ),

      BuildingData(
        id: 9,
        name: '카페1',
        latitude: 36.366,
        longitude: 127.362,
        category: BuildingCategory.cafe,
      ),
      BuildingData(
        id: 10,
        name: '카페2',
        latitude: 36.367,
        longitude: 127.361,
        category: BuildingCategory.cafe,
      ),

      BuildingData(
        id: 11,
        name: '동아리1',
        latitude: 36.368,
        longitude: 127.365,
        category: BuildingCategory.club,
      ),
      BuildingData(
        id: 12,
        name: '동아리2',
        latitude: 36.369,
        longitude: 127.366,
        category: BuildingCategory.club,
      ),
      BuildingData(
        id: 13,
        name: '기타1',
        latitude: 36.370,
        longitude: 127.367,
      ),
      BuildingData(
        id: 13,
        name: '기타2',
        latitude: 36.370,
        longitude: 127.367,
      ),
    ];
  }

  @override
  Future<List<BuildingData>> fetchReal() {
    throw UnimplementedError();
  }
}
