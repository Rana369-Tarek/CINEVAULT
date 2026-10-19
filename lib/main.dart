import 'package:flutter/material.dart';
import 'app_shell.dart';

void main() {
  runApp(const CineVaultApp());
}

class CineVaultApp extends StatefulWidget {
  const CineVaultApp({super.key});

  @override
  State<CineVaultApp> createState() => _CineVaultAppState();
}

class _CineVaultAppState extends State<CineVaultApp> {
  ThemeMode themeMode = ThemeMode.dark;

  void changeTheme(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }

  ThemeData buildDarkTheme() {
    const background = Color(0xFF08090D);
    const surface = Color(0xFF15161D);
    const purple = Color(0xFF8065B0);
    const gold = Color(0xFFE2BD75);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: purple,
        secondary: gold,
        surface: surface,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: purple.withValues(alpha: 0.25),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  ThemeData buildLightTheme() {
    const background = Color(0xFFF5F3F8);
    const surface = Color(0xFFFFFFFF);
    const purple = Color(0xFF705294);
    const gold = Color(0xFF9A7027);
    const text = Color(0xFF211B2B);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: purple,
        secondary: gold,
        surface: surface,
        onSurface: text,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: text,
        displayColor: text,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: Color(0xFFE9DFF4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: Color(0xFF77717E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CINEVAULT',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      home: CineVaultSplash(
        themeMode: themeMode,
        onThemeChanged: changeTheme,
      ),
    );
  }
}

class CineVaultSplash extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const CineVaultSplash({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<CineVaultSplash> createState() => _CineVaultSplashState();
}

class _CineVaultSplashState extends State<CineVaultSplash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 6000), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => AppShell(
            themeMode: widget.themeMode,
            onThemeChanged: widget.onThemeChanged,
          ),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE2BD75);
    final isDark = widget.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.9,
            colors: isDark
                ? const [
                    Color(0xFF21172F),
                    Color(0xFF08090D),
                  ]
                : const [
                    Color(0xFFE9DFF4),
                    Color(0xFFF5F3F8),
                  ],
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.92 + (0.08 * value),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: gold,
                      width: 1.2,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? const [
                              Color(0xFF4B326C),
                              Color(0xFF111018),
                            ]
                          : const [
                              Color(0xFFDCCBEF),
                              Color(0xFFFFFFFF),
                            ],
                    ),
                  ),
                  child: const Icon(
                    Icons.local_movies_rounded,
                    size: 38,
                    color: gold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'CINEVAULT',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                    color: isDark ? Colors.white : const Color(0xFF211B2B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'YOUR NEXT STORY STARTS HERE',
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 2.1,
                    color: isDark
                        ? Colors.white54
                        : const Color(0xFF77717E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}