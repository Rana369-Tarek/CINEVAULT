import 'package:flutter/material.dart';

import 'home_page.dart' show HomePage;
import 'library_pages.dart' show DiscoverPage, MyListPage, ProfilePage;
import 'movie.dart';
import 'movie_details_page.dart';

class AppShell extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const AppShell({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;
  int sharedValue = 0;

  final Set<String> savedIds = <String>{};

  late final Future<List<Movie>> moviesFuture = loadMovies();

  void changeSharedValue() {
    setState(() {
      sharedValue++;
    });
  }

  void toggleSaved(Movie movie) {
    setState(() {
      if (savedIds.contains(movie.id)) {
        savedIds.remove(movie.id);
      } else {
        savedIds.add(movie.id);
      }
    });
  }

  void openMovie(Movie movie, List<Movie> catalog) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovieDetailsPage(
          movie: movie,
          catalog: catalog,
          isSaved: savedIds.contains(movie.id),
          onToggleSaved: () => toggleSaved(movie),
          onOpenMovie: (selectedMovie) => openMovie(selectedMovie, catalog),
          onToggleMovieSaved: toggleSaved,
          savedIds: savedIds,
          sharedValue: sharedValue,
          onSharedValueTap: changeSharedValue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to load the CINEVAULT library.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final catalog = snapshot.data!;

        final pages = [
          HomePage(
            catalog: catalog,
            savedIds: savedIds,
            onOpenMovie: (movie) => openMovie(movie, catalog),
            onToggleSaved: toggleSaved,
            onNavigate: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            sharedValue: sharedValue,
            onSharedValueTap: changeSharedValue,
          ),
          DiscoverPage(
            catalog: catalog,
            savedIds: savedIds,
            onOpenMovie: (movie) => openMovie(movie, catalog),
            onToggleSaved: toggleSaved,
            sharedValue: sharedValue,
            onSharedValueTap: changeSharedValue,
          ),
          MyListPage(
            catalog: catalog,
            savedIds: savedIds,
            onOpenMovie: (movie) => openMovie(movie, catalog),
            onToggleSaved: toggleSaved,
            sharedValue: sharedValue,
            onSharedValueTap: changeSharedValue,
          ),
          ProfilePage(
            themeMode: widget.themeMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ];

        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: selectedIndex,
              children: pages,
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore_rounded),
                label: 'Discover',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border_rounded),
                selectedIcon: Icon(Icons.bookmark_rounded),
                label: 'My List',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}