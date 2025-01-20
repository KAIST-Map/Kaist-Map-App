import 'package:kaist_map/api/api_fetcher.dart';
import 'package:kaist_map/api/node/data.dart';

class AllNodesLoader extends ApiFetcher<List<NodeData>> {
  @override
  Future<List<NodeData>> fetchMock() async {
    throw UnimplementedError();
  }

  @override
  Future<List<NodeData>> fetchReal() {
    throw UnimplementedError();
  }
}
