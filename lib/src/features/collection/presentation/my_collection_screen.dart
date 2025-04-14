import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import flutter_animate
import '../../fragrances/data/fragrance_repository.dart';
import '../../fragrances/domain/fragrance.dart';
import '../data/collection_repository.dart';

class MyCollectionScreen extends StatefulWidget {
  const MyCollectionScreen({super.key});

  @override
  State<MyCollectionScreen> createState() => _MyCollectionScreenState();
}

class _MyCollectionScreenState extends State<MyCollectionScreen> {
  final FragranceRepository _fragranceRepository = FragranceRepository();
  final CollectionRepository _collectionRepository = CollectionRepository();
  late Future<List<Fragrance>> _collectionFragrancesFuture;
  List<Fragrance> _fullCollection =
      []; // Store the full collection for recommendation

  @override
  void initState() {
    super.initState();
    _loadCollection();
  }

  Future<void> _loadCollection() async {
    // Use a Completer to manage the Future for the FutureBuilder
    // This allows us to update the list based on shared_prefs
    setState(() {
      _collectionFragrancesFuture = _fetchFilteredFragrances();
    });
  }

  Future<List<Fragrance>> _fetchFilteredFragrances() async {
    try {
      final allFragrances = await _fragranceRepository.getAllFragrances();
      final collectionIds =
          (await _collectionRepository.getCollectionIds()).toSet();

      _fullCollection = allFragrances
          .where((fragrance) => collectionIds.contains(fragrance.id))
          .toList();
      return _fullCollection;
    } catch (e) {
      print('Error loading collection fragrances: $e');
      return []; // Return empty list on error
    }
  }

  void _showRecommendation() {
    if (_fullCollection.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Your collection is empty! Add some fragrances first.')),
      );
      return;
    }

    final random = Random();
    final recommendedFragrance =
        _fullCollection[random.nextInt(_fullCollection.length)];
    // Removed imageBytes decoding

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)), // Rounded corners
        backgroundColor:
            Theme.of(context).colorScheme.surface, // Use theme surface color
        title: Center(
            child: Text('Today\'s Recommendation',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall)), // Centered title
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              // Clip image corners
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                recommendedFragrance.picture,
                width: 120, // Slightly larger image
                height: 120,
                fit:
                    BoxFit.cover, // Use cover for potentially non-square images
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 120),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              recommendedFragrance.name,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold), // Bolder title
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              recommendedFragrance.house,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary), // Use accent color
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center, // Center the button
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor:
                  Theme.of(context).colorScheme.primary, // Use theme color
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
        ],
      ).animate().fadeIn(duration: 200.ms).scale(
          begin: const Offset(0.9, 0.9),
          curve: Curves.easeOutBack), // Add dialog animation
    );
  }

  // Function to handle removal and refresh the list
  Future<void> _removeFromCollectionAndRefresh(String fragranceId) async {
    await _collectionRepository.removeFromCollection(fragranceId);
    // Reload the collection data to reflect the change
    _loadCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.recommend),
            tooltip: 'Recommend Fragrance',
            onPressed: _showRecommendation,
          ),
        ],
      ),
      body: FutureBuilder<List<Fragrance>>(
        future: _collectionFragrancesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your collection is empty.'));
          }

          final collectionFragrances = snapshot.data!;

          // Use ListView.separated for padding/spacing
          return ListView.separated(
            padding: const EdgeInsets.all(8.0), // Add padding around the list
            itemCount: collectionFragrances.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 8), // Space between cards
            itemBuilder: (context, index) {
              final fragrance = collectionFragrances[index];

              // Use Card for better visual separation
              return Card(
                // Use theme's cardTheme automatically
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0), // Padding inside ListTile
                  leading: ClipRRect(
                    // Clip image corners
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      fragrance.picture,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                  title: Text(fragrance.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium), // Use theme text style
                  subtitle: Text(fragrance.house,
                      style: Theme.of(context).textTheme.bodySmall),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline,
                        color: Colors.redAccent[100]),
                    tooltip: 'Remove from Collection',
                    onPressed: () =>
                        _removeFromCollectionAndRefresh(fragrance.id),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(
                    // Add slide effect
                    begin: 0.1, // Start slightly below
                    duration: 300.ms,
                    delay: (index * 50).ms, // Stagger the animation
                    curve: Curves.easeInOut,
                  );
            },
          );
        },
      ),
    );
  }
}
