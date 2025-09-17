import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final bool selected;
  final VoidCallback onTap;

  const MovieTile({super.key, required this.movie, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imgUrl = TmdbService.imageUrl(movie.posterPath, size: 'w342');
    final borderColor = selected ? Colors.redAccent : Colors.transparent;

    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Column(
            children: [
              Expanded(
                child: imgUrl.isEmpty
                    ? Container(
                        color: Colors.grey.shade300,
                        child: const Center(child: Icon(Icons.image_not_supported)),
                      )
                    : Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                        },
                        errorBuilder: (context, error, stack) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
              ),
              Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.05),
                padding: const EdgeInsets.all(8),
                child: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
