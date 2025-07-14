import 'package:movie_mania/core/utilities/imports.dart';
import 'package:movie_mania/data/local_db/bookmarks_local_db.dart';

class BookmarksProvider extends ChangeNotifier {
  factory BookmarksProvider.instance() {
    return _internal;
  }

  BookmarksProvider.internal();

  static final BookmarksProvider _internal = BookmarksProvider.internal();

  final List<MovieDetail> _bookmarks = [];

  List<MovieDetail> get bookmarks => _bookmarks;

  bool isBookmarked(int id) {
    return _bookmarks.any((movie) => movie.id == id);
  }

  void bookMarkedTheMovie(MovieDetail movie){
    _bookmarks.add(movie);
    notifyListeners();
  }

  void toggleBookmark(MovieDetail movie) {
    final existing = _bookmarks.indexWhere((m) => m.id == movie.id);
    if (existing != -1) {
      _bookmarks.removeAt(existing);
    } else {
      _bookmarks.add(movie);
    }
    notifyListeners();
  }

  final BookmarkLocalDb _dbHelper = BookmarkLocalDb();

  Future<void> loadBookmarks() async {
    _bookmarks.clear();
    _bookmarks.addAll(await _dbHelper.fetchAll());
    notifyListeners();
  }
}
