import 'package:kaist_map/api/api_loader.dart';
import 'package:kaist_map/api/building/data.dart';

class BookmarksLoader extends ApiFetcher<List<BuildingData>> {
  @override
  Future<List<BuildingData>> fetchMock() {
    return Future.value([
      BuildingData(
        id: 1,
        name: '강의동1',
        latitude: 36.368,
        longitude: 127.363,
        category: [BuildingCategory.department],
        importance: 1,
        alias: [],
      ),
      BuildingData(
        id: 2,
        name: '강의동2',
        latitude: 36.369,
        longitude: 127.364,
        category: [BuildingCategory.department],
        importance: 2,
        alias: [],
      ),

      BuildingData(
        id: 3,
        name: '기숙사1',
        latitude: 36.365,
        longitude: 127.365,
        category: [BuildingCategory.dormitory],
        importance: 3,
        alias: [],
      ),
      BuildingData(
        id: 4,
        name: '기숙사2',
        latitude: 36.366,
        longitude: 127.366,
        category: [BuildingCategory.dormitory],
        importance: 4,
        alias: [],
      ),

      BuildingData(
        id: 5,
        name: '식당1',
        latitude: 36.367,
        longitude: 127.367,
        category: [BuildingCategory.restaurant],
        importance: 5,
        alias: [],
      ),
      BuildingData(
        id: 6,
        name: '식당2',
        latitude: 36.368,
        longitude: 127.368,
        category:[ BuildingCategory.restaurant],
        importance: 6,
        alias: [],
      ),

      BuildingData(
        id: 7,
        name: '도서관1',
        latitude: 36.364,
        longitude: 127.364,
        category: [BuildingCategory.library],
        importance: 7,
        alias: [],
      ),
      BuildingData(
        id: 8,
        name: '도서관2',
        latitude: 36.365,
        longitude: 127.365,
        category: [BuildingCategory.library],
        importance: 8,
        alias: [],
      ),
    ]);
  }

  @override
  Future<List<BuildingData>> fetchReal() {
    throw UnimplementedError();
  }
}