import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/food.dart';

class FoodApiService {
  static const String _baseUrl = 'https://world.openfoodfacts.org';

  // Singleton pattern
  static final FoodApiService _instance = FoodApiService._internal();
  factory FoodApiService() => _instance;
  FoodApiService._internal();

  /// Search for foods using OpenFoodFacts API
  Future<List<Food>> searchFoods(String query, {String? category}) async {
    try {
      final uri =
          Uri.parse('$_baseUrl/cgi/search.pl').replace(queryParameters: {
        'search_terms': query,
        'page_size': '20',
        'json': '1',
        'fields': 'code,product_name,nutriments,brands,categories,image_url',
        if (category != null) 'categories_tags': category,
      }); // CORRECTED LINE

      print('FoodApiService: Searching for URI: $uri'); // ADDED LOG

      final response = await http.get(uri).timeout(const Duration(seconds: 20));

      print(
          'FoodApiService: Received response with status: ${response.statusCode}'); // ADDED LOG

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print('FoodApiService: Raw response data: $data'); // Optional: for very detailed debugging
        final products = data['products'] as List<dynamic>? ?? [];

        return products
            .where((product) => product['product_name'] != null)
            .map((product) => _parseFood(product))
            .where((food) => food != null)
            .cast<Food>()
            .toList();
      }
      print(
          'FoodApiService: API returned non-200 status: ${response.statusCode}'); // ADDED LOG
      return [];
    } catch (e) {
      print('Error in searchFoods: $e');
      rethrow;
    }
  }

  /// Get food by barcode
  Future<Food?> getFoodByBarcode(String barcode) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/v0/product/$barcode.json');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return _parseFood(data['product']);
        }
      }
      return null;
    } catch (e) {
      print('Error parsing food product: $e, product: ');
      return null;
    }
  }

  /// Parse OpenFoodFacts product to Food model
  Food? _parseFood(Map<String, dynamic> product) {
    try {
      final name = product['product_name']?.toString().trim();
      if (name == null || name.isEmpty) return null;

      final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};
      final categories = product['categories']?.toString() ?? '';
      final brands = product['brands']?.toString() ?? 'Unknown';

      // Extract nutritional information per 100g
      final calories = _parseDouble(nutriments['energy-kcal_100g']) ??
          _parseDouble(nutriments['energy_100g'])
              ?.let((energy) => energy * 0.239) ??
          0.0;
      final protein = _parseDouble(nutriments['proteins_100g']) ?? 0.0;
      final carbs = _parseDouble(nutriments['carbohydrates_100g']) ?? 0.0;
      final fat = _parseDouble(nutriments['fat_100g']) ?? 0.0;
      final fiber = _parseDouble(nutriments['fiber_100g']) ?? 0.0;

      // Determine category and dietary properties
      final categoryLower = categories.toLowerCase();
      final category = _determineCategory(categoryLower);
      final tags = categories.split(',').map((e) => e.trim()).toList();

      return Food(
        id: product['code']?.toString() ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        fiber: fiber,
        category: category,
        brand: brands,
        unit: 'g',
        servingSize: 100.0,
        tags: tags,
        imageUrl: product['image_url']?.toString(),
        isVegan: _isVegan(categoryLower, tags),
        isVegetarian: _isVegetarian(categoryLower, tags),
        isGlutenFree: _isGlutenFree(categoryLower, tags),
        isLactoseFree: _isLactoseFree(categoryLower, tags),
        isDairyFree: _isDairyFree(categoryLower, tags),
        isNutFree: _isNutFree(categoryLower, tags),
      );
    } catch (e) {
      print('Error parsing food product: $e, product: $product');
      return null;
    }
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  String _determineCategory(String categories) {
    if (categories.contains('fruit')) return 'fruits';
    if (categories.contains('vegetable')) return 'vegetables';
    if (categories.contains('meat') || categories.contains('poultry'))
      return 'protein';
    if (categories.contains('dairy') || categories.contains('milk'))
      return 'dairy';
    if (categories.contains('cereal') || categories.contains('bread'))
      return 'grains';
    if (categories.contains('snack') || categories.contains('cookie'))
      return 'snacks';
    if (categories.contains('beverage') || categories.contains('drink'))
      return 'beverages';
    return 'general';
  }

  bool _isVegan(String categories, List<String> tags) {
    return categories.contains('vegan') ||
        tags.any((tag) => tag.toLowerCase().contains('vegan'));
  }

  bool _isVegetarian(String categories, List<String> tags) {
    return categories.contains('vegetarian') ||
        tags.any((tag) => tag.toLowerCase().contains('vegetarian')) ||
        _isVegan(categories, tags);
  }

  bool _isGlutenFree(String categories, List<String> tags) {
    return categories.contains('gluten-free') ||
        tags.any((tag) => tag.toLowerCase().contains('gluten-free'));
  }

  bool _isLactoseFree(String categories, List<String> tags) {
    return categories.contains('lactose-free') ||
        tags.any((tag) => tag.toLowerCase().contains('lactose-free'));
  }

  bool _isDairyFree(String categories, List<String> tags) {
    return categories.contains('dairy-free') ||
        tags.any((tag) => tag.toLowerCase().contains('dairy-free')) ||
        _isVegan(categories, tags);
  }

  bool _isNutFree(String categories, List<String> tags) {
    return categories.contains('nut-free') ||
        tags.any((tag) => tag.toLowerCase().contains('nut-free'));
  }
}

// Extension to make code more readable
extension NullableExtension<T> on T? {
  R? let<R>(R Function(T) fn) {
    if (this != null) {
      return fn(this!);
    }
    return null;
  }
}
