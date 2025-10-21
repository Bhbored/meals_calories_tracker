import 'package:json_annotation/json_annotation.dart';
import 'food.dart';

part 'consumed_meal.g.dart';

@JsonSerializable()
class ConsumedMeal {
  final String id;
  final Food food;
  final double quantity;
  final DateTime consumedAt;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double totalFiber;
  final bool isConsumed;

  const ConsumedMeal({
    required this.id,
    required this.food,
    required this.quantity,
    required this.consumedAt,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.totalFiber,
    this.isConsumed = false,
  });

  factory ConsumedMeal.fromFood(Food food, double quantity) {
    final multiplier = quantity;
    return ConsumedMeal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      food: food,
      quantity: quantity,
      consumedAt: DateTime.now(),
      totalCalories: food.calories * multiplier,
      totalProtein: food.protein * multiplier,
      totalCarbs: food.carbs * multiplier,
      totalFat: food.fat * multiplier,
      totalFiber: food.fiber * multiplier,
    );
  }

  factory ConsumedMeal.fromJson(Map<String, dynamic> json) => _$ConsumedMealFromJson(json);
  Map<String, dynamic> toJson() => _$ConsumedMealToJson(this);

  ConsumedMeal copyWith({
    String? id,
    Food? food,
    double? quantity,
    DateTime? consumedAt,
    double? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    double? totalFiber,
    bool? isConsumed,
  }) {
    return ConsumedMeal(
      id: id ?? this.id,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      consumedAt: consumedAt ?? this.consumedAt,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      totalFiber: totalFiber ?? this.totalFiber,
      isConsumed: isConsumed ?? this.isConsumed,
    );
  }
}