class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String? overview;
  final List<String>? genres;
  final String? releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.overview,
    this.genres,
    this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'],
      releaseDate: json['release_date'],
      genres: (json['genre_ids'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      overview: map['overview'],
      genres: (map['genres'] as String?)?.split(','),
      releaseDate: map['releaseDate'],
    );
  }
}
