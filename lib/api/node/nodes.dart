import 'package:kaist_map/api/api_fetcher.dart';
import 'package:kaist_map/api/node/data.dart';

class NodesLoader extends ApiFetcher<List<NodeData>> {
  final List<int> ids;

  NodesLoader(this.ids);

  @override
  Future<List<NodeData>> fetchMock() async {
    throw UnimplementedError();
  }
  
  @override
  Future<List<NodeData>> fetchReal() {
    throw UnimplementedError();
  }
}
