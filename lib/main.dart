import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// Removed google_fonts import

import 'src/navigation/main_shell.dart';
import 'src/features/fragrances/presentation/fragrance_list_screen.dart';
import 'src/features/collection/presentation/my_collection_screen.dart'; // Added

final _router = GoRouter(
  initialLocation: '/fragrances', // Changed initial location
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        // Updated routes to use new screens
        GoRoute(
          path: '/fragrances',
          builder: (context, state) => const FragranceListScreen(),
        ),
        GoRoute(
          path: '/collection',
          builder: (context, state) => const MyCollectionScreen(),
        ),
        // Removed old placeholder routes (/feed, /browse, /schedule, /profile)
      ],
    ),
    // Removed standalone /login route
  ],
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Define base theme data for a vibrant light theme
    final baseTheme = ThemeData(
      brightness: Brightness.light, // Switch to light theme
      // Using Material 3 color scheme generation with blue/yellow focus
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue, // Use light blue as seed
        brightness: Brightness.light,
        primary: Colors.lightBlue[600]!, // Stronger blue for primary elements
        secondary: Colors.yellow[700]!, // Vibrant yellow accent
        background: Colors.grey[50]!, // Very light grey background
        surface: Colors.white, // White surface for cards etc.
        onPrimary: Colors.white, // Text on primary
        onSecondary: Colors.black, // Text on secondary (yellow)
        onBackground: Colors.black, // Text on background
        onSurface: Colors.black, // Text on surface
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.lightBlue[600], // Match primary color
        foregroundColor: Colors.white, // White title on blue app bar
        elevation: 2, // Add slight elevation
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white, // White cards
        surfaceTintColor: Colors.transparent, // Avoid M3 tinting on cards
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: Colors.yellow[700], // Yellow icons
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: Colors.yellow[700], // Yellow icon buttons
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white, // White nav bar background
        selectedItemColor:
            Colors.lightBlue[700], // Darker blue for selected item
        unselectedItemColor:
            Colors.grey[600], // Clearly visible grey for unselected
        type: BottomNavigationBarType.fixed,
      ),
    );

    return MaterialApp.router(
      title: 'Sillage Society',
      theme: baseTheme, // Use the defined theme
      routerConfig: _router,
    );
  }
}
