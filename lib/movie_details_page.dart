import 'package:flutter/material.dart';
import 'movie.dart';
import 'movie_card.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;
  final List<Movie> catalog;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  final ValueChanged<Movie>? onOpenMovie;
  final ValueChanged<Movie>? onToggleMovieSaved;
  final Set<String> savedIds;
  final int sharedValue;
  final VoidCallback? onSharedValueTap;

  const MovieDetailsPage({
    super.key,
    required this.movie,
    required this.catalog,
    required this.isSaved,
    required this.onToggleSaved,
    this.onOpenMovie,
    this.onToggleMovieSaved,
    this.savedIds = const <String>{},
    this.sharedValue = 0,
    this.onSharedValueTap,
  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final similarMovies = widget.catalog
        .where(
          (movie) =>
              movie.id != widget.movie.id &&
              (movie.genre == widget.movie.genre ||
                  movie.type == widget.movie.type),
        )
        .take(10)
        .toList();

    final pageBackground = isDark
        ? const Color(0xFF08090D)
        : const Color(0xFFF5F3F8);

    return Scaffold(
      backgroundColor: pageBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 430,
            pinned: true,
            backgroundColor: pageBackground,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(7),
              child: Material(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => Navigator.of(context).maybePop(),
                  borderRadius: BorderRadius.circular(12),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(7),
                child: Material(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: widget.onToggleSaved,
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 42,
                      height: 42,
                      child: Icon(
                        widget.isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: widget.isSaved
                            ? const Color(0xFFE2BD75)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildPoster(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.12),
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.8),
                          pageBackground,
                        ],
                        stops: const [0, 0.38, 0.65, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2BD75),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            widget.movie.type.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF151019),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
                        Text(
                          widget.movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFE2BD75),
                              size: 19,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.movie.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              '${widget.movie.year}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                widget.movie.genre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: widget.onToggleSaved,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE2BD75),
                        foregroundColor: const Color(0xFF151019),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Icon(
                        widget.isSaved
                            ? Icons.bookmark_remove_rounded
                            : Icons.bookmark_add_rounded,
                      ),
                      label: Text(
                        widget.isSaved
                            ? 'Remove from My List'
                            : 'Add to My List',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Synopsis',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie.description,
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.75),
                      fontSize: 13,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (similarMovies.isNotEmpty) ...[
                    Text(
                      'More Like This',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Discover more titles for your next watch.',
                      style: TextStyle(
                        color: colors.onSurface.withValues(alpha: 0.58),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 275,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: similarMovies.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final movie = similarMovies[index];
                          final isSaved =
                              widget.savedIds.contains(movie.id);

                          return MovieCard(
                            movie: movie,
                            width: 142,
                            isSaved: isSaved,
                            sharedValue: widget.sharedValue,
                            onSharedValueTap: widget.onSharedValueTap,
                            onTap: () {
                              if (widget.onOpenMovie != null) {
                                widget.onOpenMovie!(movie);
                                return;
                              }

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (context) => MovieDetailsPage(
                                    movie: movie,
                                    catalog: widget.catalog,
                                    isSaved:
                                        widget.savedIds.contains(movie.id),
                                    savedIds: widget.savedIds,
                                    onToggleSaved: () {
                                      widget.onToggleMovieSaved?.call(movie);
                                    },
                                    onOpenMovie: widget.onOpenMovie,
                                    onToggleMovieSaved:
                                        widget.onToggleMovieSaved,
                                    sharedValue: widget.sharedValue,
                                    onSharedValueTap:
                                        widget.onSharedValueTap,
                                  ),
                                ),
                              );
                            },
                            onToggleSaved: () {
                              widget.onToggleMovieSaved?.call(movie);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoster() {
    final posterPath = widget.movie.posterAsset;

    if (posterPath == null || posterPath.trim().isEmpty) {
      return _posterError();
    }

    return Image.asset(
      posterPath,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      errorBuilder: (context, error, stackTrace) {
        return _posterError();
      },
    );
  }

  Widget _posterError() {
    return Container(
      color: const Color(0xFF08090D),
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image_outlined,
        color: Colors.white70,
        size: 60,
      ),
    );
  }
}
