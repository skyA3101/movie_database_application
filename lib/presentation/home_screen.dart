import 'package:movie_mania/core/utilities/imports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _trendingMovies;
  late Future<List<Movie>> _nowPlayingMovies;
  late PageController _carouselController;

  final _pages = <Widget>[];

  @override
  void initState() {
    super.initState();
    final service = MovieApiService();
    _trendingMovies = service.fetchTrendingMovies();
    _nowPlayingMovies = service.fetchNowPlayingMovies();
    _carouselController = PageController(viewportFraction: 0.85);

    // Auto-scroll carousel
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_carouselController.hasClients) {
        int nextPage = _carouselController.page!.round() + 1;
        if (nextPage >= 5) nextPage = 0;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _pages.clear();
    _pages.addAll([
      _buildMovieHome(),
      const SearchScreen(),
      const BookmarksPage(),
      const ProfileScreen(),
    ]);

    return Consumer<HomeScreenProvider>(
      builder: (context, homeScreenProvider, child) => Scaffold(
        body: _pages[homeScreenProvider.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.white60,
          currentIndex: homeScreenProvider.currentIndex,
          onTap: (index) {
            homeScreenProvider.incrementIndex(index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmarks_outlined), label: 'Bookmark'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieHome() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          AppStrings.appName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<List<Movie>>>(
        future: Future.wait([_trendingMovies, _nowPlayingMovies]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final trending = snapshot.data![0];
          final nowPlaying = snapshot.data![1];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarousel(trending),
                _buildHorizontalSection('Trending Now', trending),
                _buildHorizontalSection('Now Playing', nowPlaying),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarousel(List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Top 10 in India Today',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _carouselController,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      width: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalSection(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailsPage(movie: movie),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    width: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
