abstract class ApiFetcher<T> {
  static const bool mock = true;

  Future<T> fetch() async {
    if (mock) {
      return await fetchMock();
    } else {
      return await fetchReal();
    }
  }

  Future<T> fetchMock();
  Future<T> fetchReal();
}