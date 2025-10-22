import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/consumed_meal.dart';
import '../models/food.dart';
import '../core/db/repos/meal_repository.dart';
import '../core/db/repos/preferences_repository.dart';

part 'meal_provider.g.dart';

// Repository providers
@riverpod
MealRepository mealRepository(MealRepositoryRef ref) {
  return MealRepository();
}

@riverpod
PreferencesRepository preferencesRepository(PreferencesRepositoryRef ref) {
  return PreferencesRepository();
}

// Consumed meals for today
@riverpod
class TodayMeals extends _$TodayMeals {
  @override
  Future<List<ConsumedMeal>> build() async {
    final repository = ref.read(mealRepositoryProvider);
    final today = DateTime.now();
    return await repository.getConsumedMealsForDate(today);
  }

  Future<void> addMeal(Food food, double quantity) async {
    final repository = ref.read(mealRepositoryProvider);
    final meal = ConsumedMeal.fromFood(food, quantity);
    await repository.addConsumedMeal(meal);
    // Trigger rebuild
    ref.invalidateSelf();
  }

  Future<void> removeMeal(String mealId) async {
    final repository = ref.read(mealRepositoryProvider);
    await repository.deleteConsumedMeal(mealId);
    // Trigger rebuild
    ref.invalidateSelf();
  }

  Future<void> clearTodaysMeals() async {
    final repository = ref.read(mealRepositoryProvider);
    await repository.clearTodaysMeals();
    // Trigger rebuild
    ref.invalidateSelf();
  }

  Future<void> updateMealConsumedStatus(String mealId, bool isConsumed) async {
    final repository = ref.read(mealRepositoryProvider);
    await repository.updateMealConsumedStatus(mealId, isConsumed);
    ref.invalidateSelf();
  }

  Future<void> updateMealQuantity(String mealId, double quantity) async {
    final repository = ref.read(mealRepositoryProvider);
    await repository.updateMealQuantity(mealId, quantity);
    // Trigger rebuild
    ref.invalidateSelf();
  }

  Future<void> resetTodaysMeals() async {}
}

// Daily nutrition summary
@riverpod
class DailyNutrition extends _$DailyNutrition {
  @override
  Future<Map<String, double>> build(DateTime date) async {
    final repository = ref.read(mealRepositoryProvider);
    return await repository.getDailyNutritionSummary(date);
  }
}

// Weekly nutrition summary
@riverpod
class WeeklyNutrition extends _$WeeklyNutrition {
  @override
  Future<Map<String, double>> build(DateTime weekStart) async {
    final repository = ref.read(mealRepositoryProvider);
    return await repository.getWeeklyNutritionSummary(weekStart);
  }
}

// Food search provider
@riverpod
class FoodSearch extends _$FoodSearch {
  @override
  Future<List<Food>> build(String query, {String? category}) async {
    if (query.isEmpty) return [];

    final repository = ref.read(mealRepositoryProvider);
    return await repository.searchFoods(query, category: category);
  }

  Future<void> search(String query, {String? category}) async {
    // This will trigger a rebuild with new parameters
    ref.invalidateSelf();
  }
}

// Foods by category
@riverpod
class FoodsByCategory extends _$FoodsByCategory {
  @override
  Future<List<Food>> build(String category) async {
    final repository = ref.read(mealRepositoryProvider);
    return await repository.getFoodsByCategory(category);
  }
}

// Nutrition goals
@riverpod
class NutritionGoals extends _$NutritionGoals {
  @override
  Future<Map<String, double>> build() async {
    final prefsRepo = ref.read(preferencesRepositoryProvider);
    return await prefsRepo.getNutritionGoals();
  }

  Future<void> updateDailyCalorieGoal(double goal) async {
    final prefsRepo = ref.read(preferencesRepositoryProvider);
    await prefsRepo.updateDailyCalorieGoal(goal);
    ref.invalidateSelf();
  }

  Future<void> updateProteinGoal(double goal) async {
    final prefsRepo = ref.read(preferencesRepositoryProvider);
    await prefsRepo.updateProteinGoal(goal);
    ref.invalidateSelf();
  }

  Future<void> updateCarbGoal(double goal) async {
    final prefsRepo = ref.read(preferencesRepositoryProvider);
    await prefsRepo.updateCarbGoal(goal);
    ref.invalidateSelf();
  }

  Future<void> updateFatGoal(double goal) async {
    final prefsRepo = ref.read(preferencesRepositoryProvider);
    await prefsRepo.updateFatGoal(goal);
    ref.invalidateSelf();
  }

  Future<void> updateFiberGoal(double goal) async {
    final prefsRepo = ref.read(preferencesRepositoryProvider);
    await prefsRepo.updateFiberGoal(goal);
    ref.invalidateSelf();
  }
}

// Daily calorie progress
@riverpod
Future<Map<String, double>> dailyProgress(DailyProgressRef ref) async {
  final today = DateTime.now();
  final nutrition = await ref.watch(dailyNutritionProvider(today).future);
  final goals = await ref.watch(nutritionGoalsProvider.future);

  return {
    'calories': (nutrition['calories'] ?? 0.0) / (goals['calories'] ?? 2000.0),
    'protein': (nutrition['protein'] ?? 0.0) / (goals['protein'] ?? 150.0),
    'carbs': (nutrition['carbs'] ?? 0.0) / (goals['carbs'] ?? 250.0),
    'fat': (nutrition['fat'] ?? 0.0) / (goals['fat'] ?? 67.0),
    'fiber': (nutrition['fiber'] ?? 0.0) / (goals['fiber'] ?? 25.0),
  };
}

// Calories remaining for today
@riverpod
Future<double> caloriesRemaining(CaloriesRemainingRef ref) async {
  final today = DateTime.now();
  final nutrition = await ref.watch(dailyNutritionProvider(today).future);
  final goals = await ref.watch(nutritionGoalsProvider.future);

  final consumed = nutrition['calories'] ?? 0.0;
  final goal = goals['calories'] ?? 2000.0;

  return goal - consumed;
}

// Weekly nutrition summary
@riverpod
Future<Map<String, double>> weeklyNutrition(
    WeeklyNutritionRef ref, DateTime weekStart) async {
  final repository = ref.read(mealRepositoryProvider);
  return await repository.getWeeklyNutritionSummary(weekStart);
}

// Check if daily reset is needed
@riverpod
Future<bool> shouldResetDaily(ShouldResetDailyRef ref) async {
  final prefsRepo = ref.read(preferencesRepositoryProvider);
  return await prefsRepo.shouldResetDaily();
}
