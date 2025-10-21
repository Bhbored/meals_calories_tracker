// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      dailyCalorieGoal:
          (json['dailyCalorieGoal'] as num?)?.toDouble() ?? 2000.0,
      weeklyCalorieGoal:
          (json['weeklyCalorieGoal'] as num?)?.toDouble() ?? 14000.0,
      proteinGoal: (json['proteinGoal'] as num?)?.toDouble() ?? 150.0,
      carbGoal: (json['carbGoal'] as num?)?.toDouble() ?? 250.0,
      fatGoal: (json['fatGoal'] as num?)?.toDouble() ?? 67.0,
      fiberGoal: (json['fiberGoal'] as num?)?.toDouble() ?? 25.0,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      unitSystem: json['unitSystem'] as String? ?? 'metric',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      resetTime: json['resetTime'] as String? ?? '00:00',
      preferredCategories: (json['preferredCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'dailyCalorieGoal': instance.dailyCalorieGoal,
      'weeklyCalorieGoal': instance.weeklyCalorieGoal,
      'proteinGoal': instance.proteinGoal,
      'carbGoal': instance.carbGoal,
      'fatGoal': instance.fatGoal,
      'fiberGoal': instance.fiberGoal,
      'isDarkMode': instance.isDarkMode,
      'unitSystem': instance.unitSystem,
      'notificationsEnabled': instance.notificationsEnabled,
      'resetTime': instance.resetTime,
      'preferredCategories': instance.preferredCategories,
    };
