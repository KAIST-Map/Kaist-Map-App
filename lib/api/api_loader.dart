abstract class ApiLoader<T> {
  static const bool mock = true;

  Future<T> load() async {
    if (mock) {
      return await _loadMock();
    } else {
      return await _loadReal();
    }
  }

  Future<T> _loadMock();
  Future<T> _loadReal();
}