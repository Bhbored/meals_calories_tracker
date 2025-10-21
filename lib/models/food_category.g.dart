// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodCategory _$FoodCategoryFromJson(Map<String, dynamic> json) => FoodCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      isVegan: json['isVegan'] as bool? ?? false,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isGlutenFree: json['isGlutenFree'] as bool? ?? false,
      isLactoseFree: json['isLactoseFree'] as bool? ?? false,
      isDairyFree: json['isDairyFree'] as bool? ?? false,
      isNutFree: json['isNutFree'] as bool? ?? false,
    );

Map<String, dynamic> _$FoodCategoryToJson(FoodCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'tags': instance.tags,
      'isVegan': instance.isVegan,
      'isVegetarian': instance.isVegetarian,
      'isGlutenFree': instance.isGlutenFree,
      'isLactoseFree': instance.isLactoseFree,
      'isDairyFree': instance.isDairyFree,
      'isNutFree': instance.isNutFree,
    };
