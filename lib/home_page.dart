import 'package:flutter/material.dart';
import 'movie.dart';
import 'movie_card.dart';

class HomePage extends StatelessWidget {
  final List<Movie> catalog;
  final Set<String> savedIds;
  final ValueChanged<Movie> onOpenMovie;
  final ValueChanged<Movie> onToggleSaved;
  final ValueChanged<int> onNavigate;
  final int sharedValue;
  final VoidCallback onSharedValueTap;

  const HomePage({
    super.key,
    required this.catalog,
    required this.savedIds,
    required this.onOpenMovie,
    required this.onToggleSaved,
    required this.onNavigate,
    required this.sharedValue,
    required this.onSharedValueTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final trending = catalog.where((movie) => movie.trending).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));

    final topRated = [...catalog]
      ..sort((a, b) => b.rating.compareTo(a.rating));

    final series = catalog
        .where((movie) => movie.type.toLowerCase() == 'series')
        .toList();

    final anime = catalog
        .where((movie) => movie.type.toLowerCase() == 'anime')
        .toList();

    final featuredMovies =
        catalog.where((movie) => movie.featured).toList();

    final featured = featuredMovies.isNotEmpty
        ? featuredMovies.first
        : catalog.isNotEmpty
            ? catalog.first
            : null;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _TopBar(
            onSearchTap: () => onNavigate(1),
            onListTap: () => onNavigate(2),
          ),
        ),
        if (featured != null)
          SliverToBoxAdapter(
            child: _FeaturedHero(
              movie: featured,
              onTap: () => onOpenMovie(featured),
            ),
          ),
        if (trending.isNotEmpty)
          SliverToBoxAdapter(
            child: _MovieRow(
              title: 'Trending Now',
              subtitle: 'The titles everyone is talking about',
              items: trending,
              savedIds: savedIds,
              onOpenMovie: onOpenMovie,
              onToggleSaved: onToggleSaved,
              sharedValue: sharedValue,
              onSharedValueTap: onSharedValueTap,
            ),
          ),
        if (topRated.isNotEmpty)
          SliverToBoxAdapter(
            child: _MovieRow(
              title: 'Top Rated',
              subtitle: 'Highest-rated picks in your vault',
              items: topRated,
              savedIds: savedIds,
              onOpenMovie: onOpenMovie,
              onToggleSaved: onToggleSaved,
              sharedValue: sharedValue,
              onSharedValueTap: onSharedValueTap,
            ),
          ),
        if (series.isNotEmpty)
          SliverToBoxAdapter(
            child: _MovieRow(
              title: 'Series Worth Binging',
              subtitle: 'Stories that keep you watching',
              items: series,
              savedIds: savedIds,
              onOpenMovie: onOpenMovie,
              onToggleSaved: onToggleSaved,
              sharedValue: sharedValue,
              onSharedValueTap: onSharedValueTap,
            ),
          ),
        if (anime.isNotEmpty)
          SliverToBoxAdapter(
            child: _MovieRow(
              title: 'Anime Universe',
              subtitle: 'Explore worlds beyond imagination',
              items: anime,
              savedIds: savedIds,
              onOpenMovie: onOpenMovie,
              onToggleSaved: onToggleSaved,
              sharedValue: sharedValue,
              onSharedValueTap: onSharedValueTap,
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Text(
              'YOUR STORIES. YOUR VAULT.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.45),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onListTap;

  const _TopBar({
    required this.onSearchTap,
    required this.onListTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8065B0),
                  Color(0xFF4D376D),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.movie_filter_rounded,
              color: Color(0xFFE2BD75),
              size: 22,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CINEVAULT',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'YOUR PERSONAL CINEMA',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.55),
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          _TopAction(
            icon: Icons.search_rounded,
            onTap: onSearchTap,
          ),
          const SizedBox(width: 8),
          _TopAction(
            icon: Icons.bookmark_border_rounded,
            onTap: onListTap,
          ),
        ],
      ),
    );
  }
}

class _TopAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopAction({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            color: colors.onSurface,
            size: 21,
          ),
        ),
      ),
    );
  }
}

class _FeaturedHero extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const _FeaturedHero({
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final heroAsset =
        (movie.backdropAsset?.isNotEmpty == true)
            ? movie.backdropAsset!
            : movie.posterAsset;

    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 22),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: colors.surface,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 390,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (heroAsset != null && heroAsset.isNotEmpty)
                    Image.asset(
                      heroAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _heroPlaceholder();
                      },
                    )
                  else
                    _heroPlaceholder(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.08),
                          Colors.black.withValues(alpha: 0.18),
                          Colors.black.withValues(alpha: 0.92),
                        ],
                        stops: const [0.0, 0.38, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2BD75),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'EDITOR\'S PICK',
                        style: TextStyle(
                          color: Color(0xFF151019),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFE2BD75),
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              movie.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${movie.year}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                movie.type,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 29,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          movie.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2BD75),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF151019),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Explore Title',
                                style: TextStyle(
                                  color: Color(0xFF151019),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heroPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF48335E),
            Color(0xFF21172F),
            Color(0xFF08090D),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.white24,
          size: 90,
        ),
      ),
    );
  }
}

class _MovieRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Movie> items;
  final Set<String> savedIds;
  final ValueChanged<Movie> onOpenMovie;
  final ValueChanged<Movie> onToggleSaved;
  final int sharedValue;
  final VoidCallback onSharedValueTap;

  const _MovieRow({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.savedIds,
    required this.onOpenMovie,
    required this.onToggleSaved,
    required this.sharedValue,
    required this.onSharedValueTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: 0.58),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 275,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final movie = items[index];

              return MovieCard(
                movie: movie,
                width: 142,
                isSaved: savedIds.contains(movie.id),
                onTap: () => onOpenMovie(movie),
                onToggleSaved: () => onToggleSaved(movie),
                sharedValue: sharedValue,
                onSharedValueTap: onSharedValueTap,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}