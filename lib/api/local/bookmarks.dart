import 'package:kaist_map/api/api_fetcher.dart';

class BookmarksLoader extends ApiFetcher<List<int>> {
  @override
  Future<List<int>> fetchMock() {
    return Future.value([
      1, 2, 3, 4, 5, 6, 7, 8
    ]);
  }

  @override
  Future<List<int>> fetchReal() {
    throw UnimplementedError();
  }
}