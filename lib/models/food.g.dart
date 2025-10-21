// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Food _$FoodFromJson(Map<String, dynamic> json) => Food(
      id: json['id'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      category: json['category'] as String,
      brand: json['brand'] as String,
      unit: json['unit'] as String,
      servingSize: (json['servingSize'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      imageUrl: json['imageUrl'] as String?,
      isVegan: json['isVegan'] as bool? ?? false,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isGlutenFree: json['isGlutenFree'] as bool? ?? false,
      isLactoseFree: json['isLactoseFree'] as bool? ?? false,
      isDairyFree: json['isDairyFree'] as bool? ?? false,
      isNutFree: json['isNutFree'] as bool? ?? false,
    );

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'category': instance.category,
      'brand': instance.brand,
      'unit': instance.unit,
      'servingSize': instance.servingSize,
      'tags': instance.tags,
      'imageUrl': instance.imageUrl,
      'isVegan': instance.isVegan,
      'isVegetarian': instance.isVegetarian,
      'isGlutenFree': instance.isGlutenFree,
      'isLactoseFree': instance.isLactoseFree,
      'isDairyFree': instance.isDairyFree,
      'isNutFree': instance.isNutFree,
    };
