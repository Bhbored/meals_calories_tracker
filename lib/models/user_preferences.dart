import 'package:json_annotation/json_annotation.dart';

part 'user_preferences.g.dart';

@JsonSerializable()
class UserPreferences {
  final double dailyCalorieGoal;
  final double weeklyCalorieGoal;
  final double proteinGoal;
  final double carbGoal;
  final double fatGoal;
  final double fiberGoal;
  final bool isDarkMode;
  final String unitSystem; // 'metric' or 'imperial'
  final bool notificationsEnabled;
  final String resetTime; // Daily reset time in HH:mm format
  final List<String> preferredCategories;

  const UserPreferences({
    this.dailyCalorieGoal = 2000.0,
    this.weeklyCalorieGoal = 14000.0,
    this.proteinGoal = 150.0,
    this.carbGoal = 250.0,
    this.fatGoal = 67.0,
    this.fiberGoal = 25.0,
    this.isDarkMode = false,
    this.unitSystem = 'metric',
    this.notificationsEnabled = true,
    this.resetTime = '00:00',
    this.preferredCategories = const [],
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    double? dailyCalorieGoal,
    double? weeklyCalorieGoal,
    double? proteinGoal,
    double? carbGoal,
    double? fatGoal,
    double? fiberGoal,
    bool? isDarkMode,
    String? unitSystem,
    bool? notificationsEnabled,
    String? resetTime,
    List<String>? preferredCategories,
  }) {
    return UserPreferences(
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      weeklyCalorieGoal: weeklyCalorieGoal ?? this.weeklyCalorieGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      carbGoal: carbGoal ?? this.carbGoal,
      fatGoal: fatGoal ?? this.fatGoal,
      fiberGoal: fiberGoal ?? this.fiberGoal,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      unitSystem: unitSystem ?? this.unitSystem,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      resetTime: resetTime ?? this.resetTime,
      preferredCategories: preferredCategories ?? this.preferredCategories,
    );
  }
}