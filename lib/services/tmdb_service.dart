import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

class TmdbService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Read credentials from --dart-define (preferred). Support both methods.
  static const String _apiKey = String.fromEnvironment('TMDB_API_KEY');
  static const String _bearer = String.fromEnvironment('TMDB_BEARER');

  Future<List<Movie>> fetchNowPlaying({int page = 1, String language = 'fr-FR'}) async {
    final uri = Uri.parse('$_baseUrl/movie/now_playing').replace(queryParameters: {
      'language': language,
      'page': page.toString(),
      if (_apiKey.isNotEmpty) 'api_key': _apiKey,
    });

    final headers = <String, String>{
      'Accept': 'application/json',
      if (_bearer.isNotEmpty) 'Authorization': 'Bearer $_bearer',
    };

    final res = await http.get(uri, headers: headers);
    if (res.statusCode != 200) {
      throw Exception('TMDB error ${res.statusCode}: ${res.body}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List?) ?? const [];
    return results.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String imageUrl(String? path, {String size = 'w342'}) {
    if (path == null || path.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/$size$path';
  }
}
