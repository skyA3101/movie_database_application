import 'package:movie_mania/core/utilities/imports.dart';

class MovieDetailsPageProvider extends ChangeNotifier {
  factory MovieDetailsPageProvider.instance() {
    return _internal;
  }

  MovieDetailsPageProvider.internal();

  static final MovieDetailsPageProvider _internal = MovieDetailsPageProvider.internal();

  List<MovieDetail> bookmarks = [];

  void bookMarkMovie(MovieDetail movie) {
    bookmarks.add(movie);
    notifyListeners();
  }
}
