import 'package:movie_mania/core/utilities/imports.dart';
import 'package:movie_mania/data/local_db/movie_local_db.dart';

class MovieApiService {
  final Dio _dio = Dio();
  final String _apiKey = 'fc0f7d7d960da37a3ff3cd7222c71964';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchTrendingMovies() async {
    try {
      final response =
          await _dio.get('$_baseUrl/trending/movie/day', queryParameters: {'api_key': _apiKey});
      final movies =
          List<Map<String, dynamic>>.from(response.data['results']).map(Movie.fromJson).toList();
      await MovieLocalDb.insertMovies(movies, isTrending: true);
      return movies;
    } catch (_) {
      // fallback to cached DB
      return await MovieLocalDb.fetchMovies(trending: true);
    }
  }

  Future<List<Movie>> fetchNowPlayingMovies() async {
    try {
      final response =
          await _dio.get('$_baseUrl/movie/now_playing', queryParameters: {'api_key': _apiKey});
      final movies =
          List<Map<String, dynamic>>.from(response.data['results']).map(Movie.fromJson).toList();
      await MovieLocalDb.insertMovies(movies, isNowPlaying: true);
      return movies;
    } catch (_) {
      // fallback to cached DB
      return await MovieLocalDb.fetchMovies(trending: true);
    }
  }

  Future<MovieDetail> fetchDetail(int id) async {
    // final path = isSeries ? '/tv/$id' : '/movie/$id';
    final path = '/movie/$id';
    final response = await _dio.get('https://api.themoviedb.org/3$path', queryParameters: {
      'api_key': _apiKey,
    });
    return MovieDetail.fromJson(response.data);
  }

  // Future<MovieDetail> fetchDetail(int id) async {
  //   try {
  //     final response = await _dio.get('$_baseUrl/movie/$id', queryParameters: {
  //       'api_key': _apiKey,
  //     });
  //
  //     final detail = MovieDetail.fromJson(response.data);
  //
  //     // Insert to DB
  //     await MovieLocalDb.insertMovieDetail(detail);
  //
  //     return detail;
  //   } catch (_) {
  //     // Fetch from local DB
  //     final cachedDetail = await MovieLocalDb.fetchMovieDetail(id);
  //     if (cachedDetail != null) {
  //       return cachedDetail;
  //     } else {
  //       throw Exception('Movie detail not available offline.');
  //     }
  //   }
  // }

  Future<List<Video>> fetchVideos(int id) async {
    // final path = isSeries ? '/tv/$id/videos' : '/movie/$id/videos';
    final path = '/movie/$id/videos';
    final response = await _dio.get('https://api.themoviedb.org/3$path', queryParameters: {
      'api_key': _apiKey,
    });

    return List<Map<String, dynamic>>.from(response.data['results'])
        .map((json) => Video.fromJson(json))
        .toList();
  }

  Future<List<CastMember>> fetchCast(int id) async {
    // final path = isSeries ? '/tv/$id/credits' : '/movie/$id/credits';
    final path = '/movie/$id/credits';
    final response = await _dio.get('https://api.themoviedb.org/3$path', queryParameters: {
      'api_key': _apiKey,
    });

    return List<Map<String, dynamic>>.from(response.data['cast'])
        .map((json) => CastMember.fromJson(json))
        .toList();
  }

  Future<List<Movie>> fetchMoreLikeThis(List<int> genreIds) async {
    final genreParam = genreIds.join(',');
    final response = await _dio.get(
      'https://api.themoviedb.org/3/discover/movie',
      queryParameters: {
        'api_key': _apiKey,
        'with_genres': genreParam,
        'sort_by': 'popularity.desc',
      },
    );

    final results = List<Map<String, dynamic>>.from(response.data['results']);
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/search/movie',
      queryParameters: {
        'query': query,
        'api_key': _apiKey,
        'language': 'en-US',
        'include_adult': false,
      },
    );

    final List results = response.data['results'];
    return results.map((json) => Movie.fromJson(json)).toList();
  }
}
