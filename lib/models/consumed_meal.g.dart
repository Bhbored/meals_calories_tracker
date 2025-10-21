// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumed_meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsumedMeal _$ConsumedMealFromJson(Map<String, dynamic> json) => ConsumedMeal(
      id: json['id'] as String,
      food: Food.fromJson(json['food'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      consumedAt: DateTime.parse(json['consumedAt'] as String),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      totalProtein: (json['totalProtein'] as num).toDouble(),
      totalCarbs: (json['totalCarbs'] as num).toDouble(),
      totalFat: (json['totalFat'] as num).toDouble(),
      totalFiber: (json['totalFiber'] as num).toDouble(),
    );

Map<String, dynamic> _$ConsumedMealToJson(ConsumedMeal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'food': instance.food,
      'quantity': instance.quantity,
      'consumedAt': instance.consumedAt.toIso8601String(),
      'totalCalories': instance.totalCalories,
      'totalProtein': instance.totalProtein,
      'totalCarbs': instance.totalCarbs,
      'totalFat': instance.totalFat,
      'totalFiber': instance.totalFiber,
    };
