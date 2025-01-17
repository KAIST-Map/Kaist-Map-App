import 'package:kaist_map/api/api_loader.dart';
import 'package:kaist_map/api/node/data.dart';

class AllNodesLoader extends ApiLoader<List<NodeData>> {
  Future<List<NodeData>> _loadMock() async {
    return [NodeData(
      id: 1,
      name: '테스트 노드',
      latitude: 36.372,
      longitude: 127.360,
      buildingId: 1,
      imageUrl: 'https://via.placeholder.com/150',
    )];
  }

  Future<List<NodeData>> _loadReal() {
    throw UnimplementedError();
  }
}