import 'package:kaist_map/api/api_fetcher.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class BookmarksBase<T> extends ApiFetcher<T> {
  static const String _bookmarksKey = 'user_bookmarks';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<List<int>> loadBookmarks() async {
    final prefs = await _getPrefs();
    final String? bookmarksJson = prefs.getString(_bookmarksKey);
    if (bookmarksJson == null || bookmarksJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(bookmarksJson);
      return decoded.map((e) => e as int).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveBookmarks(List<int> bookmarks) async {
    final prefs = await _getPrefs();
    final String bookmarksJson = jsonEncode(bookmarks);
    await prefs.setString(_bookmarksKey, bookmarksJson);
  }
}

class BookmarksFetcher extends BookmarksBase<List<int>> {
  @override
  Future<List<int>> fetchMock() {
    return Future.value([1, 2, 3, 4, 5, 6, 7, 8]);
  }

  @override
  Future<List<int>> fetchReal() async {
    return await loadBookmarks();
  }
}

class BookmarkAdder extends BookmarksBase<bool> {
  final int bookmarkId;

  BookmarkAdder(this.bookmarkId);

  @override
  Future<bool> fetchMock() {
    return Future.value(true);
  }

  @override
  Future<bool> fetchReal() async {
    final bookmarks = await loadBookmarks();
    if (!bookmarks.contains(bookmarkId)) {
      bookmarks.add(bookmarkId);
      await saveBookmarks(bookmarks);
      return true;
    }
    return false;
  }
}

class BookmarkRemover extends BookmarksBase<bool> {
  final int bookmarkId;

  BookmarkRemover(this.bookmarkId);

  @override
  Future<bool> fetchMock() {
    return Future.value(true);
  }

  @override
  Future<bool> fetchReal() async {
    final bookmarks = await loadBookmarks();
    if (bookmarks.contains(bookmarkId)) {
      bookmarks.remove(bookmarkId);
      await saveBookmarks(bookmarks);
      return true;
    }
    return false;
  }
}

class BookmarkChecker extends BookmarksBase<bool> {
  final int bookmarkId;

  BookmarkChecker(this.bookmarkId);

  @override
  Future<bool> fetchMock() {
    return Future.value(true);
  }

  @override
  Future<bool> fetchReal() async {
    final bookmarks = await loadBookmarks();
    return bookmarks.contains(bookmarkId);
  }
}

class BookmarksClearer extends BookmarksBase<bool> {
  @override
  Future<bool> fetchMock() {
    return Future.value(true);
  }

  @override
  Future<bool> fetchReal() async {
    await saveBookmarks([]);
    return true;
  }
}
