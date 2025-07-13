import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import 'package:movie_mania/core/utilities/imports.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  final bool isSeries;

  const MovieDetailsPage({
    super.key,
    required this.movie,
    this.isSeries = false,
  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Future<MovieDetail> _detailFuture;
  late Future<List<Video>> _videosFuture;
  late Future<List<CastMember>> _castFuture;
  late Future<List<Movie>> _moreLikeThisFuture;

  @override
  void initState() {
    super.initState();
    final service = MovieApiService();
    final id = widget.movie.id;
    _detailFuture = service.fetchDetail(id);
    _videosFuture = service.fetchVideos(id);
    _castFuture = service.fetchCast(id);

    _detailFuture.then((detail) {
      setState(() {
        _moreLikeThisFuture = service.fetchMoreLikeThis(detail.genreIds);
      });
    });
  }

  void _showCastSheet(List<CastMember> cast) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: cast
              .map(
                (c) => ListTile(
                  title: Text(c.name),
                  subtitle: Text(c.role),
                ),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<MovieDetail>(
        future: _detailFuture,
        builder: (c, ds) {
          if (ds.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (ds.hasError) {
            return Center(child: Text('Error: ${ds.error}'));
          }
          final detail = ds.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<List<Video>>(
                  future: _videosFuture,
                  builder: (c2, vs) {
                    if (vs.connectionState != ConnectionState.done) {
                      return CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${detail.posterPath}',
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image, color: Colors.white),
                      );
                    }
                    final trailer = vs.data!.firstWhere(
                        (v) => v.type == 'Trailer' && v.site == 'YouTube',
                        orElse: () => Video(key: '', type: '', site: ''));
                    return SizedBox(
                      height: 220,
                      child: YouTubePlayerWidget(videoKey: trailer.key),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(detail.title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                    '${detail.year} • ${widget.isSeries ? "${detail.seasons} seasons" : detail.runtimeText}',
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.people),
                        color: Colors.white,
                        onPressed: () {
                          _castFuture.then((cast) => _showCastSheet(cast));
                        }),
                    IconButton(
                        icon: const Icon(Icons.star),
                        color: Colors.amber,
                        onPressed: () {
                          // Bookmark or rating action
                        }),
                    IconButton(
                        icon: const Icon(Icons.share),
                        color: Colors.white,
                        onPressed: () {
                          Share.share('Check out ${detail.title}!');
                        }),
                    IconButton(
                        icon: const Icon(Icons.download),
                        color: Colors.white,
                        onPressed: () {
                          // Download logic
                        }),
                    IconButton(
                        icon: const Icon(Icons.info_outline),
                        color: Colors.white,
                        onPressed: () {
                          final genresText = detail.genres.join(', ');
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text('Genres'),
                                  content: Text(genresText),
                                );
                              });
                        }),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(detail.overview,
                      style: const TextStyle(color: Colors.white70)),
                ),
                const SizedBox(height: 24),

                /// More like this section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'More Like This',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                FutureBuilder<List<Movie>>(
                  future: _moreLikeThisFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final similarMovies = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: similarMovies.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          final movie = similarMovies[index];
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
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image,
                                        color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
