abstract class ApiFetcher<T> {
  static const bool _mock = true;
  final String baseUrl = "http://localhost:3000";

  Future<T> fetch({bool mock = false}) async {
    if (mock || _mock) {
      return await fetchMock();
    } else {
      return await fetchReal();
    }
  }

  Future<T> fetchMock();
  Future<T> fetchReal();
}