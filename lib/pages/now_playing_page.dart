import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../widgets/error_view.dart';
import '../widgets/movie_tile.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  final _service = TmdbService();
  late Future<List<Movie>> _futureMovies;
  final Set<int> _likedIds = <int>{};
  bool _loadingLikes = true;

  static const String _prefsKey = 'liked_movie_ids';

  @override
  void initState() {
    super.initState();
    _futureMovies = _service.fetchNowPlaying(page: 1, language: 'fr-FR');
    _loadLikes();
  }

  Future<void> _loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_prefsKey) ?? <String>[];
    setState(() {
      _likedIds
        ..clear()
        ..addAll(stored.map(int.parse));
      _loadingLikes = false;
    });
  }

  Future<void> _saveLikes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      _likedIds.map((e) => e.toString()).toList(),
    );
  }

  void _toggleLike(int movieId) {
    setState(() {
      if (_likedIds.contains(movieId)) {
        _likedIds.remove(movieId);
      } else {
        _likedIds.add(movieId);
      }
    });
    _saveLikes();
  }

  @override
  Widget build(BuildContext context) {
    final likeCount = _likedIds.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Films à l\'affiche — Likés: $likeCount'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || _loadingLikes) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error.toString(), onRetry: () {
              setState(() {
                _futureMovies = _service.fetchNowPlaying(page: 1, language: 'fr-FR');
              });
            });
          }
          final movies = snapshot.data ?? const <Movie>[];
          if (movies.isEmpty) {
            return const Center(child: Text('Aucun film trouvé.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2 / 3,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final m = movies[index];
              final selected = _likedIds.contains(m.id);
              return MovieTile(
                movie: m,
                selected: selected,
                onTap: () => _toggleLike(m.id),
              );
            },
          );
        },
      ),
    );
  }
}
