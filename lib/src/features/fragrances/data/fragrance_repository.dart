import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../domain/fragrance.dart';

class FragranceRepository {
  // Path to the JSON file in assets
  final String _dataPath = 'assets/data/fragrances.json';

  // Cache the loaded fragrances to avoid repeated file reads
  List<Fragrance>? _cachedFragrances;

  Future<List<Fragrance>> getAllFragrances() async {
    // Return cached data if available
    if (_cachedFragrances != null) {
      return _cachedFragrances!;
    }

    try {
      // Load the JSON string from the asset bundle
      final jsonString = await rootBundle.loadString(_dataPath);

      // Decode the JSON string into a List<dynamic>
      final List<dynamic> jsonList = jsonDecode(jsonString);

      // Map the JSON list to a List<Fragrance>
      final fragrances = jsonList
          .map((jsonItem) =>
              Fragrance.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

      // Cache the result
      _cachedFragrances = fragrances;
      return fragrances;
    } catch (e) {
      // Handle errors (e.g., file not found, JSON parsing error)
      print('Error loading fragrances: $e');
      // Return an empty list or rethrow the exception depending on desired behavior
      return [];
    }
  }

  // Optional: Method to get a single fragrance by ID (if needed later)
  Future<Fragrance?> getFragranceById(String id) async {
    final fragrances = await getAllFragrances();
    try {
      return fragrances.firstWhere((f) => f.id == id);
    } catch (e) {
      // Not found
      return null;
    }
  }
}
