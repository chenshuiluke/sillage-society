import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import flutter_animate
import '../data/fragrance_repository.dart';
import '../domain/fragrance.dart';
import '../../collection/data/collection_repository.dart';

class FragranceListScreen extends StatefulWidget {
  const FragranceListScreen({super.key});

  @override
  State<FragranceListScreen> createState() => _FragranceListScreenState();
}

class _FragranceListScreenState extends State<FragranceListScreen> {
  final FragranceRepository _fragranceRepository = FragranceRepository();
  final CollectionRepository _collectionRepository =
      CollectionRepository(); // Instantiate collection repo
  late Future<List<Fragrance>> _fragrancesFuture;
  Set<String> _collectionIds = {}; // Keep track of collection locally

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _fragrancesFuture = _fragranceRepository.getAllFragrances();
    // Load initial collection state
    _collectionIds = (await _collectionRepository.getCollectionIds()).toSet();
    // Trigger a rebuild if data loading finishes after initial build
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _toggleCollectionStatus(String fragranceId) async {
    final isInCollection = _collectionIds.contains(fragranceId);
    if (isInCollection) {
      await _collectionRepository.removeFromCollection(fragranceId);
      _collectionIds.remove(fragranceId);
    } else {
      await _collectionRepository.addToCollection(fragranceId);
      _collectionIds.add(fragranceId);
    }
    // Update UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Fragrances'),
      ),
      body: FutureBuilder<List<Fragrance>>(
        future: _fragrancesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No fragrances found.'));
          }

          final fragrances = snapshot.data!;

          // Use ListView.separated for padding/spacing
          return ListView.separated(
            padding: const EdgeInsets.all(8.0), // Add padding around the list
            itemCount: fragrances.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 8), // Space between cards
            itemBuilder: (context, index) {
              final fragrance = fragrances[index];
              final bool isInCollection = _collectionIds.contains(fragrance.id);

              // Use Card for better visual separation and animate it
              return Card(
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
                      style: Theme.of(context).textTheme.titleMedium),
                  subtitle: Text(fragrance.house,
                      style: Theme.of(context).textTheme.bodySmall),
                  trailing: IconButton(
                    // Rewriting this whole widget
                    icon: Icon(
                      isInCollection ? Icons.favorite : Icons.favorite_border,
                    ),
                    color: isInCollection
                        ? Colors.redAccent[100]
                        : Theme.of(context)
                            .listTileTheme
                            .iconColor, // Moved color outside Icon
                    tooltip: isInCollection
                        ? 'Remove from Collection'
                        : 'Add to Collection',
                    onPressed: () => _toggleCollectionStatus(fragrance.id),
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
