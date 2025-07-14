import 'package:movie_mania/core/utilities/imports.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarksProvider>().bookmarks;

    if (bookmarks.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('No bookmarks yet.', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          final movie = bookmarks[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(movie.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              movie.releaseDate,
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark_remove, color: Colors.amber),
              onPressed: () {
                context.read<BookmarksProvider>().toggleBookmark(movie);
              },
            ),
            onTap: () => () {},
          );
        },
      ),
    );
  }
}
