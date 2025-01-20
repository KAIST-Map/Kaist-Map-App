abstract class ApiFetcher<T> {
  static const bool _mock = true;
  final String baseUrl = "http://localhost:3000";

  Future<T> fetch({bool mock = _mock}) async {
    if (mock) {
      return await fetchMock();
    } else {
      return await fetchReal();
    }
  }

  Future<T> fetchMock();
  Future<T> fetchReal();
}

List<LT> toList<LT>(List data) {
  return data.map((e) => e as LT).toList();
}
