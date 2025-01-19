import 'package:kaist_map/api/api_fetcher.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SearchHistoryBase<T> extends ApiFetcher<T> {
  static const String _historyKey = 'search_history';
  final int maxHistorySize = 20;
  
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<List<int>> loadHistory() async {
    final prefs = await _getPrefs();
    final String? historyJson = prefs.getString(_historyKey);
    if (historyJson == null || historyJson.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.map((e) => e as int).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveHistory(List<int> history) async {
    final prefs = await _getPrefs();
    final String historyJson = jsonEncode(history);
    await prefs.setString(_historyKey, historyJson);
  }
}

class SearchHistoryFetcher extends SearchHistoryBase<List<int>> {
  @override
  Future<List<int>> fetchMock() {
    return Future.value([1, 2, 3, 4, 5]);
  }

  @override
  Future<List<int>> fetchReal() async {
    return await loadHistory();
  }
}

class SearchHistoryAdder extends SearchHistoryBase<bool> {
  final int searchId;

  SearchHistoryAdder(this.searchId);

  @override
  Future<bool> fetchMock() {
    return Future.value(true);
  }

  @override
  Future<bool> fetchReal() async {
    final history = await loadHistory();
    
    final existingIndex = history.indexOf(searchId);
    if (existingIndex != -1) {
      history.removeAt(existingIndex);
    }
    
    history.insert(0, searchId);
    
    if (history.length > maxHistorySize) {
      history.removeRange(maxHistorySize, history.length);
    }
    
    await saveHistory(history);
    return true;
  }
}

class SearchHistoryRemover extends SearchHistoryBase<bool> {
  final int searchId;

  SearchHistoryRemover(this.searchId);

  @override
  Future<bool> fetchMock() {
    return Future.value(true);
  }

  @override
  Future<bool> fetchReal() async {
    final history = await loadHistory();
    final existingIndex = history.indexOf(searchId);
    if (existingIndex != -1) {
      history.removeAt(existingIndex);
      await saveHistory(history);
      return true;
    }
    return false;
  }
}

class SearchHistoryClearer extends SearchHistoryBase<bool> {
  @override
  Future<bool> fetchMock() {
    return Future.value(true);
  }

  @override
  Future<bool> fetchReal() async {
    await saveHistory([]);
    return true;
  }
}