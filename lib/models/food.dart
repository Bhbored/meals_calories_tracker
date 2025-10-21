import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

@JsonSerializable()
class Food {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final String category;
  final String brand;
  final String unit;
  final double servingSize;
  final List<String> tags;
  final String? imageUrl;
  final bool isVegan;
  final bool isVegetarian;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isDairyFree;
  final bool isNutFree;

  const Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.category,
    required this.brand,
    required this.unit,
    required this.servingSize,
    required this.tags,
    this.imageUrl,
    this.isVegan = false,
    this.isVegetarian = false,
    this.isGlutenFree = false,
    this.isLactoseFree = false,
    this.isDairyFree = false,
    this.isNutFree = false,
  });

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);

  Food copyWith({
    String? id,
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    String? category,
    String? brand,
    String? unit,
    double? servingSize,
    List<String>? tags,
    String? imageUrl,
    bool? isVegan,
    bool? isVegetarian,
    bool? isGlutenFree,
    bool? isLactoseFree,
    bool? isDairyFree,
    bool? isNutFree,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      unit: unit ?? this.unit,
      servingSize: servingSize ?? this.servingSize,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      isVegan: isVegan ?? this.isVegan,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isLactoseFree: isLactoseFree ?? this.isLactoseFree,
      isDairyFree: isDairyFree ?? this.isDairyFree,
      isNutFree: isNutFree ?? this.isNutFree,
    );
  }
}