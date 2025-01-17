import 'package:kaist_map/api/api_loader.dart';
import 'package:kaist_map/api/building/data.dart';

class AllBuildingLoader extends ApiFetcher<List<BuildingData>> {
  @override
  Future<List<BuildingData>> fetchMock() async {
    return [
      BuildingData(
        id: 1,
        name: '테스트 건물',
        latitude: 36.372,
        longitude: 127.360,
        category: BuildingCategory.lecture,
      ),
      BuildingData(
        id: 2,
        name: '테스트 건물 2',
        latitude: 36.360,
        longitude: 127.372,
        category: BuildingCategory.dormitory,),
    ];
  }

  @override
  Future<List<BuildingData>> fetchReal() {
    throw UnimplementedError();
  }
}