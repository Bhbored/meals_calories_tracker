import 'package:json_annotation/json_annotation.dart';

part 'food_category.g.dart';

@JsonSerializable()
class FoodCategory {
  final String id;
  final String name;
  final String icon;
  final String color;
  final List<String> tags;
  final bool isVegan;
  final bool isVegetarian;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isDairyFree;
  final bool isNutFree;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.tags,
    this.isVegan = false,
    this.isVegetarian = false,
    this.isGlutenFree = false,
    this.isLactoseFree = false,
    this.isDairyFree = false,
    this.isNutFree = false,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) => _$FoodCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$FoodCategoryToJson(this);

  static List<FoodCategory> getDefaultCategories() {
    return [
      const FoodCategory(
        id: 'vegan',
        name: 'Vegan',
        icon: '🌱',
        color: '4CAF50',
        tags: ['plant-based', 'no-animal-products'],
        isVegan: true,
      ),
      const FoodCategory(
        id: 'vegetarian',
        name: 'Vegetarian',
        icon: '🥗',
        color: '8BC34A',
        tags: ['no-meat', 'plant-based'],
        isVegetarian: true,
      ),
      const FoodCategory(
        id: 'lactose-free',
        name: 'Lactose Free',
        icon: '🥛',
        color: '2196F3',
        tags: ['no-lactose', 'dairy-alternative'],
        isLactoseFree: true,
      ),
      const FoodCategory(
        id: 'gluten-free',
        name: 'Gluten Free',
        icon: '🌾',
        color: 'FF9800',
        tags: ['no-gluten', 'celiac-friendly'],
        isGlutenFree: true,
      ),
      const FoodCategory(
        id: 'dairy-free',
        name: 'Dairy Free',
        icon: '🧀',
        color: '9C27B0',
        tags: ['no-dairy', 'plant-milk'],
        isDairyFree: true,
      ),
      const FoodCategory(
        id: 'nut-free',
        name: 'Nut Free',
        icon: '🥜',
        color: 'F44336',
        tags: ['no-nuts', 'allergy-friendly'],
        isNutFree: true,
      ),
      const FoodCategory(
        id: 'protein',
        name: 'High Protein',
        icon: '🥩',
        color: 'E91E63',
        tags: ['protein-rich', 'muscle-building'],
      ),
      const FoodCategory(
        id: 'low-carb',
        name: 'Low Carb',
        icon: '🥑',
        color: '607D8B',
        tags: ['keto', 'low-carbohydrate'],
      ),
      const FoodCategory(
        id: 'fruits',
        name: 'Fruits',
        icon: '🍎',
        color: 'FF5722',
        tags: ['fresh', 'natural', 'vitamins'],
      ),
      const FoodCategory(
        id: 'vegetables',
        name: 'Vegetables',
        icon: '🥕',
        color: '4CAF50',
        tags: ['fresh', 'natural', 'fiber'],
      ),
      const FoodCategory(
        id: 'grains',
        name: 'Grains',
        icon: '🌾',
        color: 'FFC107',
        tags: ['carbs', 'energy', 'fiber'],
      ),
      const FoodCategory(
        id: 'snacks',
        name: 'Snacks',
        icon: '🍪',
        color: '795548',
        tags: ['quick', 'convenient'],
      ),
    ];
  }
}