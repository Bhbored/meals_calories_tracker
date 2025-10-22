import '../database_helper.dart';
import '../../../models/consumed_meal.dart';
import '../../../models/food.dart';
import '../../network/food_api_service.dart';

class MealRepository {
  final DatabaseHelper _databaseHelper;
  final FoodApiService _foodApiService;

  MealRepository({
    DatabaseHelper? databaseHelper,
    FoodApiService? foodApiService,
  })  : _databaseHelper = databaseHelper ?? DatabaseHelper.instance,
        _foodApiService = foodApiService ?? FoodApiService();

  // Consumed Meals
  Future<void> addConsumedMeal(ConsumedMeal meal) async {
    await _databaseHelper.insertConsumedMeal(meal);
    // Cache the food for offline access
    await _databaseHelper.insertFood(meal.food);
  }

  Future<List<ConsumedMeal>> getConsumedMealsForDate(DateTime date) async {
    return await _databaseHelper.getConsumedMealsForDate(date);
  }

  Future<List<ConsumedMeal>> getConsumedMealsForDateRange(
      DateTime startDate, DateTime endDate) async {
    return await _databaseHelper.getConsumedMealsForDateRange(
        startDate, endDate);
  }

  Future<void> deleteConsumedMeal(String id) async {
    await _databaseHelper.deleteConsumedMeal(id);
  }

  Future<void> updateMealQuantity(String id, double quantity) async {
    await _databaseHelper.updateMealQuantity(id, quantity);
  }

  Future<void> updateMealConsumedStatus(String id, bool isConsumed) async {
    await _databaseHelper.updateMealConsumedStatus(id, isConsumed);
  }

  Future<void> clearTodaysMeals() async {
    await _databaseHelper.clearDailyMeals();
  }

  // Food search and management
  Future<List<Food>> searchFoods(String query, {String? category}) async {
    // First search local database
    final localFoods = await _databaseHelper.searchFoods(query);

    // Then search online
    final onlineFoods =
        await _foodApiService.searchFoods(query, category: category);

    // Cache online results
    for (final food in onlineFoods) {
      await _databaseHelper.insertFood(food);
    }

    // Combine and remove duplicates (prioritize online results)
    final allFoods = <String, Food>{};

    // Add local foods first
    for (final food in localFoods) {
      allFoods[food.name.toLowerCase()] = food;
    }

    // Add online foods (will override local duplicates)
    for (final food in onlineFoods) {
      allFoods[food.name.toLowerCase()] = food;
    }

    return allFoods.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<List<Food>> getFoodsByCategory(String category) async {
    // Get local foods for category
    final localFoods = await _databaseHelper.getFoodsByCategory(category);

    // For popular categories, also fetch some online results
    if (_isPopularCategory(category)) {
      final onlineFoods =
          await _foodApiService.searchFoods('', category: category);

      // Cache online results
      for (final food in onlineFoods.take(10)) {
        await _databaseHelper.insertFood(food);
      }

      // Combine results
      final allFoods = <String, Food>{};

      for (final food in localFoods) {
        allFoods[food.id] = food;
      }

      for (final food in onlineFoods) {
        allFoods[food.id] = food;
      }

      return allFoods.values.toList();
    }

    return localFoods;
  }

  Future<Food?> getFoodByBarcode(String barcode) async {
    final food = await _foodApiService.getFoodByBarcode(barcode);
    if (food != null) {
      await _databaseHelper.insertFood(food);
    }
    return food;
  }

  // Analytics and statistics
  Future<Map<String, double>> getDailyNutritionSummary(DateTime date) async {
    final meals = await getConsumedMealsForDate(date);

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;

    for (final meal in meals) {
      totalCalories += meal.totalCalories;
      totalProtein += meal.totalProtein;
      totalCarbs += meal.totalCarbs;
      totalFat += meal.totalFat;
      totalFiber += meal.totalFiber;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
      'fiber': totalFiber,
    };
  }

  Future<Map<String, double>> getWeeklyNutritionSummary(
      DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final meals = await getConsumedMealsForDateRange(weekStart, weekEnd);

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;

    for (final meal in meals) {
      totalCalories += meal.totalCalories;
      totalProtein += meal.totalProtein;
      totalCarbs += meal.totalCarbs;
      totalFat += meal.totalFat;
      totalFiber += meal.totalFiber;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
      'fiber': totalFiber,
    };
  }

  Future<List<Map<String, dynamic>>> getDailyCalorieHistory(int days) async {
    final history = <Map<String, dynamic>>[];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final summary = await getDailyNutritionSummary(date);

      history.add({
        'date': date,
        'calories': summary['calories'] ?? 0.0,
        'protein': summary['protein'] ?? 0.0,
        'carbs': summary['carbs'] ?? 0.0,
        'fat': summary['fat'] ?? 0.0,
        'fiber': summary['fiber'] ?? 0.0,
      });
    }

    return history;
  }

  Future<Map<String, int>> getCategoryBreakdown(
      DateTime startDate, DateTime endDate) async {
    final meals = await getConsumedMealsForDateRange(startDate, endDate);
    final categoryCount = <String, int>{};

    for (final meal in meals) {
      final category = meal.food.category;
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }

    return categoryCount;
  }

  bool _isPopularCategory(String category) {
    const popularCategories = [
      'fruits',
      'vegetables',
      'protein',
      'grains',
      'dairy',
      'snacks'
    ];
    return popularCategories.contains(category);
  }
}
