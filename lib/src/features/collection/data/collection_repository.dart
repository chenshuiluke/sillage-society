import 'package:shared_preferences/shared_preferences.dart';

class CollectionRepository {
  static const String _collectionKey = 'fragrance_collection';

  // Get the list of fragrance IDs in the collection
  Future<List<String>> getCollectionIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_collectionKey) ?? [];
  }

  // Add a fragrance ID to the collection
  Future<void> addToCollection(String fragranceId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCollection = await getCollectionIds();
    if (!currentCollection.contains(fragranceId)) {
      currentCollection.add(fragranceId);
      await prefs.setStringList(_collectionKey, currentCollection);
    }
  }

  // Remove a fragrance ID from the collection
  Future<void> removeFromCollection(String fragranceId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCollection = await getCollectionIds();
    if (currentCollection.contains(fragranceId)) {
      currentCollection.remove(fragranceId);
      await prefs.setStringList(_collectionKey, currentCollection);
    }
  }

  // Check if a fragrance is in the collection
  Future<bool> isInCollection(String fragranceId) async {
    final currentCollection = await getCollectionIds();
    return currentCollection.contains(fragranceId);
  }
}
