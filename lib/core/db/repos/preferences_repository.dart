import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user_preferences.dart';

class PreferencesRepository {
  static const String _preferencesKey = 'user_preferences';
  static const String _lastResetDateKey = 'last_reset_date';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Get user preferences
  Future<UserPreferences> getPreferences() async {
    final prefs = await _preferences;
    final preferencesJson = prefs.getString(_preferencesKey);

    if (preferencesJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(preferencesJson);
        return UserPreferences.fromJson(json);
      } catch (e) {
        // If parsing fails, return default preferences
        return const UserPreferences();
      }
    }

    return const UserPreferences();
  }

  /// Save user preferences
  Future<void> savePreferences(UserPreferences preferences) async {
    final prefs = await _preferences;
    final preferencesJson = jsonEncode(preferences.toJson());
    await prefs.setString(_preferencesKey, preferencesJson);
  }

  /// Update daily calorie goal
  Future<void> updateDailyCalorieGoal(double goal) async {
    final currentPrefs = await getPreferences();
    final updatedPrefs = currentPrefs.copyWith(dailyCalorieGoal: goal);
    await savePreferences(updatedPrefs);
  }

  /// Update weekly calorie goal
  Future<void> updateWeeklyCalorieGoal(double goal) async {
    final currentPrefs = await getPreferences();
    final updatedPrefs = currentPrefs.copyWith(weeklyCalorieGoal: goal);
    await savePreferences(updatedPrefs);
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    final currentPrefs = await getPreferences();
    final updatedPrefs =
        currentPrefs.copyWith(isDarkMode: !currentPrefs.isDarkMode);
    await savePreferences(updatedPrefs);
  }

  /// Update protein goal
  Future<void> updateProteinGoal(double goal) async {
    final currentPrefs = await getPreferences();
    final updatedPrefs = currentPrefs.copyWith(proteinGoal: goal);
    await savePreferences(updatedPrefs);
  }

  /// Update carb goal
  Future<void> updateCarbGoal(double goal) async {
    final currentPrefs = await getPreferences();
    final updatedPrefs = currentPrefs.copyWith(carbGoal: goal);
    await savePreferences(updatedPrefs);
  }

  /// Update fat goal
  Future<void> updateFatGoal(double goal) async {
    final currentPrefs = await getPreferences();
    final updatedPrefs = currentPrefs.copyWith(fatGoal: goal);
    await savePreferences(updatedPrefs);
  }

  /// Update fiber goal
  Future<void> updateFiberGoal(double goal) async {
    final currentPrefs = await getPreferences();
    final updatedPrefs = currentPrefs.copyWith(fiberGoal: goal);
    await savePreferences(updatedPrefs);
  }

  /// Update unit system
  Future<void> updateUnitSystem(String unitSystem) async {
    final currentPrefs = await getPreferences();
    final updatedPrefs = currentPrefs.copyWith(unitSystem: unitSystem);
    await savePreferences(updatedPrefs);
  }

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    final currentPrefs = await getPreferences();
    final updatedPrefs = currentPrefs.copyWith(
      notificationsEnabled: !currentPrefs.notificationsEnabled,
    );
    await savePreferences(updatedPrefs);
  }

  /// Update reset time
  Future<void> updateResetTime(String resetTime) async {
    final currentPrefs = await getPreferences();
    final updatedPrefs = currentPrefs.copyWith(resetTime: resetTime);
    await savePreferences(updatedPrefs);
  }

  /// Update preferred categories
  Future<void> updatePreferredCategories(List<String> categories) async {
    final currentPrefs = await getPreferences();
    final updatedPrefs = currentPrefs.copyWith(preferredCategories: categories);
    await savePreferences(updatedPrefs);
  }

  /// Check if daily reset is needed
  Future<bool> shouldResetDaily() async {
    final prefs = await _preferences;
    final preferences = await getPreferences();
    final lastResetString = prefs.getString(_lastResetDateKey);

    if (lastResetString == null) {
      return true; // First time, needs reset
    }

    final lastReset = DateTime.parse(lastResetString);
    final now = DateTime.now();
    final resetTime = _parseResetTime(preferences.resetTime);

    // Calculate the last reset time for today
    final todayReset = DateTime(
        now.year, now.month, now.day, resetTime.hour, resetTime.minute);

    // If current time is after today's reset time and last reset was before today's reset time
    if (now.isAfter(todayReset) && lastReset.isBefore(todayReset)) {
      return true;
    }

    // If it's past midnight and reset time is after midnight, check if we need to reset
    if (resetTime.hour > 0 && now.hour < resetTime.hour) {
      final yesterdayReset = todayReset.subtract(const Duration(days: 1));
      if (lastReset.isBefore(yesterdayReset)) {
        return true;
      }
    }

    return false;
  }

  /// Mark daily reset as completed
  Future<void> markDailyResetCompleted() async {
    final prefs = await _preferences;
    await prefs.setString(_lastResetDateKey, DateTime.now().toIso8601String());
  }

  /// Reset all preferences to defaults
  Future<void> resetToDefaults() async {
    final prefs = await _preferences;
    await prefs.remove(_preferencesKey);
    await prefs.remove(_lastResetDateKey);
  }

  /// Parse reset time string to DateTime
  DateTime _parseResetTime(String resetTime) {
    final parts = resetTime.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  /// Get theme mode
  Future<bool> isDarkMode() async {
    final preferences = await getPreferences();
    return preferences.isDarkMode;
  }

  Future<Map<String, double>> getNutritionGoals() async {
    final preferences = await getPreferences();
    return {
      'calories': preferences.dailyCalorieGoal,
      'protein': preferences.proteinGoal,
      'carbs': preferences.carbGoal,
      'fat': preferences.fatGoal,
      'fiber': preferences.fiberGoal,
    };
  }
}
