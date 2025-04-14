import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/fragrances/presentation/fragrance_list_screen.dart'; // Added
import '../features/collection/presentation/my_collection_screen.dart'; // Added

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/fragrances'); // Changed route
        break;
      case 1:
        context.go('/collection'); // Changed route
        break;
      // Removed other cases
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/fragrances')) {
      // Changed route
      return 0;
    }
    if (location.startsWith('/collection')) {
      // Changed route
      return 1;
    }
    // Removed other checks
    return 0; // Default to first tab
  }

  @override
  Widget build(BuildContext context) {
    // Removed AppBar from Shell, screens have their own
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list), // Changed icon
            label: 'Fragrances', // Changed label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), // Changed icon
            label: 'My Collection', // Changed label
          ),
          // Removed other items
        ],
        currentIndex: _calculateSelectedIndex(context),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
