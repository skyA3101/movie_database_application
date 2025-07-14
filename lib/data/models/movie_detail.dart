import 'dart:convert';

class MovieDetail {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;
  final int? runtime;
  final int? numberOfSeasons;
  final List<String> genres;
  final List<int> genreIds;

  MovieDetail({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.genres,
    this.runtime,
    this.numberOfSeasons,
    this.genreIds = const [35, 28, 12, 16, 80, 36, 18, 53],
  });

  String get year => releaseDate.split('-').first;

  String get runtimeText => runtime != null ? '${runtime! ~/ 60}h ${runtime! % 60}m' : '';

  int get seasons => numberOfSeasons ?? 0;

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      // ✅ Make sure the API response has this
      title: json['title'] ?? json['name'] ?? '',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
      runtime: json['runtime'],
      numberOfSeasons: json['number_of_seasons'],
      genres: json['genres'] is String
          ? List<String>.from(jsonDecode(json['genres']))
          : List.from(json['genres'] ?? []).map((g) => g['name'] as String).toList(),
      genreIds: json['genre_ids'] is String
          ? List<int>.from(jsonDecode(json['genre_ids']))
          : List.from(json['genres'] ?? []).map((g) => g['id'] as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'overview': overview,
      'release_date': releaseDate,
      'runtime': runtime,
      'number_of_seasons': numberOfSeasons,
      'genres': jsonEncode(genres),
      'genre_ids': jsonEncode(genreIds),
    };
  }
}
