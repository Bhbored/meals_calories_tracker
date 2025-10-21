import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/consumed_meal.dart';
import '../models/food.dart';

class DatabaseHelper {
  static const _databaseName = "meals_tracker.db";
  static const _databaseVersion = 2;

  static const String tableConsumedMeals = 'consumed_meals';
  static const String tableFoods = 'foods';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $tableConsumedMeals');
    await db.execute('DROP TABLE IF EXISTS $tableFoods');
    await _onCreate(db, newVersion);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create consumed meals table
    await db.execute('''
      CREATE TABLE $tableConsumedMeals (
        id TEXT PRIMARY KEY,
        food_data TEXT NOT NULL,
        quantity REAL NOT NULL,
        consumed_at INTEGER NOT NULL,
        total_calories REAL NOT NULL,
        total_protein REAL NOT NULL,
        total_carbs REAL NOT NULL,
        total_fat REAL NOT NULL,
        total_fiber REAL NOT NULL
      )
    ''');

    // Create foods table for local cache
    await db.execute('''
      CREATE TABLE $tableFoods (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        calories REAL NOT NULL,
        protein REAL NOT NULL,
        carbs REAL NOT NULL,
        fat REAL NOT NULL,
        fiber REAL NOT NULL,
        category TEXT NOT NULL,
        brand TEXT NOT NULL,
        unit TEXT NOT NULL,
        serving_size REAL NOT NULL,
        tags TEXT NOT NULL,
        image_url TEXT,
        is_vegan INTEGER DEFAULT 0,
        is_vegetarian INTEGER DEFAULT 0,
        is_gluten_free INTEGER DEFAULT 0,
        is_lactose_free INTEGER DEFAULT 0,
        is_dairy_free INTEGER DEFAULT 0,
        is_nut_free INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Create indexes for better performance
    await db.execute(
        'CREATE INDEX idx_consumed_at ON $tableConsumedMeals(consumed_at)');
    await db.execute('CREATE INDEX idx_food_category ON $tableFoods(category)');
    await db.execute('CREATE INDEX idx_food_name ON $tableFoods(name)');
  }

  // Consumed Meals operations
  Future<int> insertConsumedMeal(ConsumedMeal meal) async {
    final db = await database;
    final foodData = jsonEncode(meal.food.toJson());

    final result = await db.insert(
      tableConsumedMeals,
      {
        'id': meal.id,
        'food_data': foodData,
        'quantity': meal.quantity,
        'consumed_at': meal.consumedAt.millisecondsSinceEpoch,
        'total_calories': meal.totalCalories,
        'total_protein': meal.totalProtein,
        'total_carbs': meal.totalCarbs,
        'total_fat': meal.totalFat,
        'total_fiber': meal.totalFiber,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<ConsumedMeal>> getConsumedMealsForDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      tableConsumedMeals,
      where: 'consumed_at >= ? AND consumed_at < ?',
      whereArgs: [
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch
      ],
      orderBy: 'consumed_at DESC',
    );

    return List.generate(maps.length, (i) {
      return _mapToConsumedMeal(maps[i]);
    });
  }

  Future<List<ConsumedMeal>> getConsumedMealsForDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableConsumedMeals,
      where: 'consumed_at >= ? AND consumed_at < ?',
      whereArgs: [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch
      ],
      orderBy: 'consumed_at DESC',
    );

    return List.generate(maps.length, (i) {
      return _mapToConsumedMeal(maps[i]);
    });
  }

  Future<int> deleteConsumedMeal(String id) async {
    final db = await database;
    return await db.delete(
      tableConsumedMeals,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateMealQuantity(String id, double quantity) async {
    final db = await database;

    // First get the meal to recalculate totals
    final meal = await db.query(
      tableConsumedMeals,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (meal.isEmpty) return 0;

    final mealData = meal.first;
    final originalQuantity = mealData['quantity'] as double;
    final multiplier = quantity / originalQuantity;

    return await db.update(
      tableConsumedMeals,
      {
        'quantity': quantity,
        'total_calories': (mealData['total_calories'] as double) * multiplier,
        'total_protein': (mealData['total_protein'] as double) * multiplier,
        'total_carbs': (mealData['total_carbs'] as double) * multiplier,
        'total_fat': (mealData['total_fat'] as double) * multiplier,
        'total_fiber': (mealData['total_fiber'] as double) * multiplier,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearDailyMeals() async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    await db.delete(
      tableConsumedMeals,
      where: 'consumed_at >= ?',
      whereArgs: [startOfDay.millisecondsSinceEpoch],
    );
  }

  // Food operations
  Future<int> insertFood(Food food) async {
    final db = await database;
    return await db.insert(
      tableFoods,
      _foodToMap(food),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Food>> searchFoods(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableFoods,
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
      limit: 50,
    );

    return List.generate(maps.length, (i) {
      return _mapToFood(maps[i]);
    });
  }

  Future<List<Food>> getFoodsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableFoods,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return _mapToFood(maps[i]);
    });
  }

  // Helper methods
  ConsumedMeal _mapToConsumedMeal(Map<String, dynamic> map) {
    final foodData = map['food_data'] as String;
    final food = Food.fromJson(jsonDecode(foodData));

    return ConsumedMeal(
      id: map['id'],
      food: food,
      quantity: map['quantity'],
      consumedAt: DateTime.fromMillisecondsSinceEpoch(map['consumed_at']),
      totalCalories: map['total_calories'],
      totalProtein: map['total_protein'],
      totalCarbs: map['total_carbs'],
      totalFat: map['total_fat'],
      totalFiber: map['total_fiber'],
    );
  }

  Map<String, dynamic> _foodToMap(Food food) {
    return {
      'id': food.id,
      'name': food.name,
      'calories': food.calories,
      'protein': food.protein,
      'carbs': food.carbs,
      'fat': food.fat,
      'fiber': food.fiber,
      'category': food.category,
      'brand': food.brand,
      'unit': food.unit,
      'serving_size': food.servingSize,
      'tags': food.tags.join(','),
      'image_url': food.imageUrl,
      'is_vegan': food.isVegan ? 1 : 0,
      'is_vegetarian': food.isVegetarian ? 1 : 0,
      'is_gluten_free': food.isGlutenFree ? 1 : 0,
      'is_lactose_free': food.isLactoseFree ? 1 : 0,
      'is_dairy_free': food.isDairyFree ? 1 : 0,
      'is_nut_free': food.isNutFree ? 1 : 0,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    };
  }

  Food _mapToFood(Map<String, dynamic> map) {
    return Food(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
      protein: map['protein'],
      carbs: map['carbs'],
      fat: map['fat'],
      fiber: map['fiber'],
      category: map['category'],
      brand: map['brand'],
      unit: map['unit'],
      servingSize: map['serving_size'],
      tags: map['tags'].toString().split(','),
      imageUrl: map['image_url'],
      isVegan: map['is_vegan'] == 1,
      isVegetarian: map['is_vegetarian'] == 1,
      isGlutenFree: map['is_gluten_free'] == 1,
      isLactoseFree: map['is_lactose_free'] == 1,
      isDairyFree: map['is_dairy_free'] == 1,
      isNutFree: map['is_nut_free'] == 1,
    );
  }
}
