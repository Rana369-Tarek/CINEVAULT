import 'package:flutter/material.dart';
import 'movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;
  final double width;
  final int sharedValue;
  final VoidCallback? onSharedValueTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isSaved,
    required this.onTap,
    required this.onToggleSaved,
    this.width = 142,
    this.sharedValue = 0,
    this.onSharedValueTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _PosterArt(movie: movie),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onToggleSaved,
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Icon(
                            isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            size: 18,
                            color: isSaved
                                ? const Color(0xFFE2BD75)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFE2BD75),
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            movie.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(7),
                child: InkWell(
                  onTap: onSharedValueTap,
                  borderRadius: BorderRadius.circular(7),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          size: 13,
                          color: colors.secondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Vault $sharedValue',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${movie.year}  •  ${movie.type}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterArt extends StatelessWidget {
  final Movie movie;

  const _PosterArt({required this.movie});

  @override
  Widget build(BuildContext context) {
    if (movie.posterAsset != null) {
      return Image.asset(
        movie.posterAsset!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    final colors = _colorsFor(movie.type);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -22,
            right: -18,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 18,
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 32,
            child: Text(
              movie.title.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                height: 1.1,
                letterSpacing: 0.8,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Icon(
              Icons.local_movies_rounded,
              size: 28,
              color: Colors.white54,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Text(
              movie.year.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                letterSpacing: 3,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _colorsFor(String type) {
    if (type == 'Anime') {
      return const [Color(0xFF4D284D), Color(0xFF11121D)];
    }

    if (type == 'Series') {
      return const [Color(0xFF244653), Color(0xFF10131B)];
    }

    return const [Color(0xFF59422E), Color(0xFF11121A)];
  }
}