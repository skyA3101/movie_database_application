import 'package:movie_mania/core/utilities/imports.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final MovieApiService _apiService = MovieApiService();
  Timer? _debounce;
  SearchScreenProvider provider = SearchScreenProvider.instance();

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isNotEmpty) {
        provider.setIsLoading(true);
        try {
          final results = await _apiService.searchMovies(query.trim());
          provider.setIsLoading(false);
          provider.setSearchResults(results);
        } catch (e) {
          provider.setIsLoading(false);
          debugPrint('Search error: $e');
        }
      } else {
        SearchScreenProvider.instance().setSearchResults([]);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Search Movies'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Consumer<SearchScreenProvider>(
          builder: (context, searchScreenProvider, child) => Column(
            children: [
              TextField(
                controller: _controller,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for a movie...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              if (searchScreenProvider.isLoading) const LinearProgressIndicator(),
              const SizedBox(height: 8),
              Expanded(
                child: searchScreenProvider.searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          "Search for movies",
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : GridView.builder(
                        itemCount: searchScreenProvider.searchResults.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          final movie = searchScreenProvider.searchResults[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
