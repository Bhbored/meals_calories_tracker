import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'meal_provider.dart';

part 'analytics_provider.g.dart';

// Daily calorie history for charts
@riverpod
class CalorieHistory extends _$CalorieHistory {
  @override
  Future<List<Map<String, dynamic>>> build(int days) async {
    final repository = ref.read(mealRepositoryProvider);
    return await repository.getDailyCalorieHistory(days);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// Weekly comparison data
@riverpod
Future<Map<String, dynamic>> weeklyComparison(WeeklyComparisonRef ref) async {
  final repository = ref.read(mealRepositoryProvider);
  final now = DateTime.now();
  
  // Current week (starting from Monday)
  final currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
  final currentWeekData = await repository.getWeeklyNutritionSummary(currentWeekStart);
  
  // Previous week
  final previousWeekStart = currentWeekStart.subtract(const Duration(days: 7));
  final previousWeekData = await repository.getWeeklyNutritionSummary(previousWeekStart);
  
  // Calculate percentage changes
  final calorieChange = _calculatePercentageChange(
    previousWeekData['calories'] ?? 0.0,
    currentWeekData['calories'] ?? 0.0,
  );
  
  final proteinChange = _calculatePercentageChange(
    previousWeekData['protein'] ?? 0.0,
    currentWeekData['protein'] ?? 0.0,
  );
  
  return {
    'current': currentWeekData,
    'previous': previousWeekData,
    'changes': {
      'calories': calorieChange,
      'protein': proteinChange,
      'carbs': _calculatePercentageChange(
        previousWeekData['carbs'] ?? 0.0,
        currentWeekData['carbs'] ?? 0.0,
      ),
      'fat': _calculatePercentageChange(
        previousWeekData['fat'] ?? 0.0,
        currentWeekData['fat'] ?? 0.0,
      ),
      'fiber': _calculatePercentageChange(
        previousWeekData['fiber'] ?? 0.0,
        currentWeekData['fiber'] ?? 0.0,
      ),
    },
  };
}

// Monthly category breakdown
@riverpod
class CategoryBreakdown extends _$CategoryBreakdown {
  @override
  Future<Map<String, int>> build() async {
    final repository = ref.read(mealRepositoryProvider);
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return await repository.getCategoryBreakdown(startOfMonth, endOfMonth);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// Macro distribution for today
@riverpod
Future<Map<String, double>> todayMacros(TodayMacrosRef ref) async {
  final today = DateTime.now();
  final nutrition = await ref.watch(dailyNutritionProvider(today).future);
  
  final totalCalories = nutrition['calories'] ?? 0.0;
  if (totalCalories == 0) return {'protein': 0, 'carbs': 0, 'fat': 0};
  
  final proteinCalories = (nutrition['protein'] ?? 0.0) * 4; // 4 cal/g
  final carbCalories = (nutrition['carbs'] ?? 0.0) * 4; // 4 cal/g
  final fatCalories = (nutrition['fat'] ?? 0.0) * 9; // 9 cal/g
  
  return {
    'protein': (proteinCalories / totalCalories) * 100,
    'carbs': (carbCalories / totalCalories) * 100,
    'fat': (fatCalories / totalCalories) * 100,
  };
}

// Average daily intake over the past week
@riverpod
Future<Map<String, double>> weeklyAverage(WeeklyAverageRef ref) async {
  final history = await ref.watch(calorieHistoryProvider(7).future);
  
  if (history.isEmpty) return {};
  
  double totalCalories = 0;
  double totalProtein = 0;
  double totalCarbs = 0;
  double totalFat = 0;
  double totalFiber = 0;
  
  for (final day in history) {
    totalCalories += day['calories'] as double;
    totalProtein += day['protein'] as double;
    totalCarbs += day['carbs'] as double;
    totalFat += day['fat'] as double;
    totalFiber += day['fiber'] as double;
  }
  
  final days = history.length;
  
  return {
    'calories': totalCalories / days,
    'protein': totalProtein / days,
    'carbs': totalCarbs / days,
    'fat': totalFat / days,
    'fiber': totalFiber / days,
  };
}

// Streak tracking - consecutive days meeting calorie goal
@riverpod
Future<int> calorieGoalStreak(CalorieGoalStreakRef ref) async {
  final repository = ref.read(mealRepositoryProvider);
  final prefsRepo = ref.read(preferencesRepositoryProvider);
  
  final goals = await prefsRepo.getNutritionGoals();
  final dailyGoal = goals['calories'] ?? 2000.0;
  
  final history = await repository.getDailyCalorieHistory(30); // Last 30 days
  
  int streak = 0;
  
  // Count from most recent day backwards
  for (final day in history.reversed) {
    final calories = day['calories'] as double;
    final goalRange = dailyGoal * 0.1; // 10% tolerance
    
    // Check if within goal range (±10%)
    if (calories >= (dailyGoal - goalRange) && calories <= (dailyGoal + goalRange)) {
      streak++;
    } else {
      break; // Streak broken
    }
  }
  
  return streak;
}

// Best and worst days in the past month
@riverpod
Future<Map<String, dynamic>> monthlyHighlights(MonthlyHighlightsRef ref) async {
  final history = await ref.watch(calorieHistoryProvider(30).future);
  
  if (history.isEmpty) return {};
  
  Map<String, dynamic>? bestDay;
  Map<String, dynamic>? worstDay;
  double? highestCalories;
  double? lowestCalories;
  
  for (final day in history) {
    final calories = day['calories'] as double;
    
    if (highestCalories == null || calories > highestCalories) {
      highestCalories = calories;
      bestDay = day;
    }
    
    if (lowestCalories == null || calories < lowestCalories) {
      lowestCalories = calories;
      worstDay = day;
    }
  }
  
  return {
    'best': bestDay,
    'worst': worstDay,
    'totalDays': history.length,
    'averageCalories': history.fold<double>(0, (sum, day) => sum + (day['calories'] as double)) / history.length,
  };
}

// Helper function to calculate percentage change
double _calculatePercentageChange(double oldValue, double newValue) {
  if (oldValue == 0) return newValue > 0 ? 100.0 : 0.0;
  return ((newValue - oldValue) / oldValue) * 100;
}