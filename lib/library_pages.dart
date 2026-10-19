import 'package:flutter/material.dart';
import 'movie.dart';
import 'movie_card.dart';

class DiscoverPage extends StatefulWidget {
  final List<Movie> catalog;
  final Set<String> savedIds;
  final ValueChanged<Movie> onOpenMovie;
  final ValueChanged<Movie> onToggleSaved;
  final int sharedValue;
  final VoidCallback onSharedValueTap;

  const DiscoverPage({
    super.key,
    required this.catalog,
    required this.savedIds,
    required this.onOpenMovie,
    required this.onToggleSaved,
    required this.sharedValue,
    required this.onSharedValueTap,
  });

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final TextEditingController _searchController = TextEditingController();
  String query = '';
  String selectedType = 'All';

  final List<String> types = ['All', 'Movie', 'Series', 'Anime'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final normalizedQuery = query.trim().toLowerCase();

    final filteredMovies = widget.catalog.where((movie) {
      final matchesQuery =
          movie.title.toLowerCase().contains(normalizedQuery) ||
          movie.genre.toLowerCase().contains(normalizedQuery);

      final matchesType = selectedType == 'All' ||
          movie.type.toLowerCase() == selectedType.toLowerCase();

      return matchesQuery && matchesType;
    }).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Find your next favorite story.',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => query = value);
                  },
                  style: TextStyle(color: colors.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Search titles or genres...',
                    hintStyle: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.45),
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colors.secondary,
                    ),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => query = '');
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: colors.onSurface,
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: colors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: colors.onSurface.withValues(alpha: 0.08),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: colors.primary,
                        width: 1.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: types.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final type = types[index];
                      final selected = selectedType == type;

                      return ChoiceChip(
                        label: Text(type),
                        selected: selected,
                        onSelected: (_) {
                          setState(() => selectedType = type);
                        },
                        backgroundColor: colors.surface,
                        selectedColor: colors.primary,
                        side: BorderSide(
                          color: selected
                              ? colors.primary
                              : colors.onSurface.withValues(alpha: 0.12),
                        ),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : colors.onSurface,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${filteredMovies.length} titles found',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.55),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredMovies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.movie_filter_outlined,
                          color: colors.onSurface.withValues(alpha: 0.35),
                          size: 54,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No titles found',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try another search or category.',
                          style: TextStyle(
                            color: colors.onSurface.withValues(alpha: 0.55),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 280,
                    ),
                    itemCount: filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = filteredMovies[index];

                      return MovieCard(
                        movie: movie,
                        width: double.infinity,
                        isSaved: widget.savedIds.contains(movie.id),
                        onTap: () => widget.onOpenMovie(movie),
                        onToggleSaved: () => widget.onToggleSaved(movie),
                        sharedValue: widget.sharedValue,
                        onSharedValueTap: widget.onSharedValueTap,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MyListPage extends StatelessWidget {
  final List<Movie> catalog;
  final Set<String> savedIds;
  final ValueChanged<Movie> onOpenMovie;
  final ValueChanged<Movie> onToggleSaved;
  final int sharedValue;
  final VoidCallback onSharedValueTap;

  const MyListPage({
    super.key,
    required this.catalog,
    required this.savedIds,
    required this.onOpenMovie,
    required this.onToggleSaved,
    required this.sharedValue,
    required this.onSharedValueTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final savedMovies = catalog
        .where((movie) => savedIds.contains(movie.id))
        .toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My List',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${savedMovies.length} titles saved in your collection',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: savedMovies.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_border_rounded,
                            color: colors.secondary,
                            size: 58,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your vault is waiting',
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Save movies, series, and anime to find them here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.onSurface.withValues(alpha: 0.6),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 280,
                    ),
                    itemCount: savedMovies.length,
                    itemBuilder: (context, index) {
                      final movie = savedMovies[index];

                      return MovieCard(
                        movie: movie,
                        width: double.infinity,
                        isSaved: savedIds.contains(movie.id),
                        onTap: () => onOpenMovie(movie),
                        onToggleSaved: () => onToggleSaved(movie),
                        sharedValue: sharedValue,
                        onSharedValueTap: onSharedValueTap,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ProfilePage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Text(
            'Profile',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: colors.onSurface.withValues(alpha: 0.07),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF8065B0),
                        Color(0xFF4D376D),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.movie_filter_rounded,
                    color: Color(0xFFE2BD75),
                    size: 31,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CINEVAULT',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Your personal cinema collection',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8D8D9B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'PREFERENCES',
            style: TextStyle(
              color: colors.secondary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          _ProfileTile(
            icon: Icons.dark_mode_outlined,
            title: 'Appearance',
            subtitle: isDark ? 'Cinematic dark theme' : 'Clean light theme',
            trailing: Switch.adaptive(
              value: isDark,
              onChanged: (value) {
                onThemeChanged(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const _ProfileTile(
            icon: Icons.movie_outlined,
            title: 'About CINEVAULT',
            subtitle: 'Your movies, series, and anime in one place',
          ),
          const SizedBox(height: 10),
          const _ProfileTile(
            icon: Icons.offline_pin_outlined,
            title: 'Offline Library',
            subtitle: 'Browse your locally stored collection',
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              'CINEVAULT  •  YOUR STORIES, YOUR VAULT',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.4),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: colors.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: colors.secondary,
            size: 21,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.58),
              fontSize: 10,
            ),
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}