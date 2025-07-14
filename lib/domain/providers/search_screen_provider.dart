import 'package:movie_mania/core/utilities/imports.dart';

class SearchScreenProvider extends ChangeNotifier {
  factory SearchScreenProvider.instance() {
    return _internal;
  }

  SearchScreenProvider.internal();

  static final SearchScreenProvider _internal = SearchScreenProvider.internal();

  bool isLoading = false;
  List<Movie> searchResults = [];

  void setIsLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  void setSearchResults(List<Movie> val) {
    searchResults = val;
    notifyListeners();
  }
}
