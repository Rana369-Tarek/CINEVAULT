import 'dart:convert';

import 'package:flutter/services.dart';

class Movie {
  final String id;
  final String title;
  final String type;
  final String genre;
  final int year;
  final double rating;
  final String description;
  final String? posterAsset;
  final String? backdropAsset;
  final bool trending;
  final bool featured;

  const Movie({
    required this.id,
    required this.title,
    required this.type,
    required this.genre,
    required this.year,
    required this.rating,
    required this.description,
    this.posterAsset,
    this.backdropAsset,
    this.trending = false,
    this.featured = false,
  });

  factory Movie.fromJson(
    Map<String, dynamic> json, {
    bool featured = false,
    bool trending = false,
  }) {
    final title = (json['title'] ?? '').toString().trim();
    final genre = (json['genre'] ?? '').toString().trim();
    final rawType = (json['type'] ?? '').toString().trim().toLowerCase();
    final image = (json['image'] ?? '').toString().trim();

    final isAnime = genre
        .split(',')
        .map((value) => value.trim().toLowerCase())
        .contains('anime');

    final type = rawType == 'movie'
        ? 'Movie'
        : isAnime
            ? 'Anime'
            : 'Series';

    final yearValue = json['year'];
    final ratingValue = json['rating'];

    return Movie(
      id: title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_'),
      title: title,
      type: type,
      genre: genre,
      year: yearValue is num
          ? yearValue.toInt()
          : int.tryParse(yearValue.toString()) ?? 0,
      rating: ratingValue is num
          ? ratingValue.toDouble()
          : double.tryParse(ratingValue.toString()) ?? 0.0,
      description: 'Explore $title in your CINEVAULT library.',
      posterAsset: image.isEmpty ? null : image,
      featured: featured,
      trending: trending,
    );
  }
}

Future<List<Movie>> loadMovies() async {
  final jsonString = await rootBundle.loadString('data/movies.json');
  final decoded = jsonDecode(jsonString);

  if (decoded is! List) {
    throw const FormatException(
      'The movie catalog must contain a JSON list.',
    );
  }

  final entries = decoded.whereType<Map<String, dynamic>>().toList();

  if (entries.isEmpty) {
    throw const FormatException(
      'The movie catalog does not contain any valid entries.',
    );
  }

  final movies = <Movie>[];

  for (var index = 0; index < entries.length; index++) {
    final entry = entries[index];
    final title = (entry['title'] ?? '').toString().trim();

    if (title.isEmpty) {
      continue;
    }

    movies.add(
      Movie.fromJson(
        entry,
        featured: index == 0,
        trending: index < 10,
      ),
    );
  }

  if (movies.isEmpty) {
    throw const FormatException(
      'No catalog entries have a valid title.',
    );
  }

  return List<Movie>.unmodifiable(movies);
}
