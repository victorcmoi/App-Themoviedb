class Movie {
  final int id;
  final String title;
  final String? posterPath;

  Movie({required this.id, required this.title, required this.posterPath});

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] as int,
        title: (json['title'] as String?)?.trim().isNotEmpty == true
            ? json['title'] as String
            : (json['name'] as String?) ?? 'Sans titre',
        posterPath: json['poster_path'] as String?,
      );
}
