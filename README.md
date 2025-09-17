# Movies App — Liker des films (TMDB)

Une application Flutter simple qui affiche la liste des films "À l'affiche" depuis The Movie Database (TMDB) et permet de liker/désélectionner des films.

Fonctionnalités:
- Affiche les films actuellement à l'affiche (API TMDB /movie/now_playing) en français.
- Chaque vignette montre l'affiche et le titre du film.
- Tap sur une vignette: le contour devient rouge pour indiquer qu'elle est likée (tap à nouveau pour désélectionner).
- Un compteur dans l'AppBar montre le nombre de films likés.
- Persistance locale: les likes sont conservés via SharedPreferences.

## Prérequis
- Un compte TMDB et une clé API v3 ou un Bearer token v4.
- Flutter 3.9+ installé.

## Lancer l'application
Deux méthodes d'authentification sont supportées. Passez les identifiants via `--dart-define` (recommandé):

1) En utilisant une clé API (v3):
```
flutter run --dart-define=TMDB_API_KEY=VOTRE_CLE_API_V3
```

2) En utilisant un Bearer token (v4):
```
flutter run --dart-define=TMDB_BEARER=VOTRE_BEARER_TOKEN_V4
```

Vous pouvez aussi les utiliser avec `flutter build` de la même manière.

> Note: Si vous fournissez les deux, le Bearer sera utilisé pour l'en-tête `Authorization`, et la clé API sera aussi ajoutée en paramètre si définie.

## API TMDB
- Doc: https://developer.themoviedb.org/reference/intro/getting-started
- Endpoint utilisé (page 1, FR):
  https://api.themoviedb.org/3/movie/now_playing?language=fr-FR&page=1
- Images: https://image.tmdb.org/t/p/{taille}/{chemin}
  - Tailles disponibles: w92, w154, w185, w342, w500, w780, original
  - Exemple: https://image.tmdb.org/t/p/w500/xOMo8BRK7PfcJv9JCnx7s5hj0PX.jpg

## Persistance locale
- Les IDs des films likés sont stockés dans SharedPreferences sous la clé `liked_movie_ids`.
- À la réouverture de l'app, les likes sont restaurés automatiquement.

## Dépannage
- 401 Unauthorized: vérifiez votre clé API / Bearer.
- CORS (web): l'appli mobile/desktop n'est pas concernée; en web, utilisez un proxy autorisé si nécessaire.
- Aucune image: certains films n'ont pas d'affiche, un placeholder est affiché.

## Scripts utiles
- Mettre à jour les dépendances: `flutter pub get`
- Lancer les tests: `flutter test`
