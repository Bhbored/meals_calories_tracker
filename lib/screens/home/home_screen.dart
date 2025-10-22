import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_calories_tracker/screens/home/widgets/add_meal_dialog.dart';
import 'package:meals_calories_tracker/screens/home/widgets/daily_goal_card.dart';
import 'package:meals_calories_tracker/screens/home/widgets/modern_food_categories.dart';
import 'package:meals_calories_tracker/screens/home/widgets/nutrition_row.dart';
import 'package:meals_calories_tracker/screens/home/widgets/progress_ring.dart';
import '../base/widgets/gradient_background.dart';
import 'widgets/food_search_bar.dart';
import '../../core/db/repos/preferences_repository.dart';
import '../../providers/meal_provider.dart';
import '../../models/food.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final PreferencesRepository _preferencesRepository = PreferencesRepository();
  bool _isDark = false;
  bool _isLoadingTheme = true;
  bool isDailyGoalExpanded = false;
  bool _isWeeklyGoalExpanded = false;

  late final AnimationController controller;
  late final Animation<double> _animation;
  late final AnimationController _weeklyController;
  late final Animation<double> _weeklyAnimation;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    _weeklyController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _weeklyAnimation = CurvedAnimation(
      parent: _weeklyController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _weeklyController.dispose();
    super.dispose();
  }

  Future<void> _loadTheme() async {
    try {
      final isDark = await _preferencesRepository.isDarkMode();
      if (!mounted) return;
      setState(() {
        _isDark = isDark;
        _isLoadingTheme = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isDark = false;
        _isLoadingTheme = false;
      });
    }
  }

  Future<void> _toggleTheme() async {
    try {
      await _preferencesRepository.toggleDarkMode();
      if (!mounted) return;
      setState(() => _isDark = !_isDark);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error toggling theme: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final caloriesRemainingAsync = ref.watch(caloriesRemainingProvider);
    final dailyProgressAsync = ref.watch(dailyProgressProvider);
    final nutritionGoalsAsync = ref.watch(nutritionGoalsProvider);

    if (_isLoadingTheme) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GradientBackground(
      isDark: _isDark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Meal Tracker',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: nutritionGoalsAsync.when(
                        data: (goals) {
                          final dailyGoal = goals['calories'] ?? 2000.0;
                          return caloriesRemainingAsync.when(
                            data: (calRemaining) => DailyGoalCard(
                                context,
                                calRemaining,
                                dailyProgressAsync,
                                dailyGoal,
                                isDailyGoalExpanded,
                                controller,
                                _animation),
                            loading: () => _buildLoadingCard(),
                            error: (_, __) => _buildErrorCard(),
                          );
                        },
                        loading: () => _buildLoadingCard(),
                        error: (_, __) => _buildErrorCard(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: nutritionGoalsAsync.when(
                        data: (goals) {
                          final dailyGoal = goals['calories'] ?? 2000.0;
                          final weeklyGoal = dailyGoal * 7;
                          return _buildWeeklyGoalCard(
                              context,
                              dailyProgressAsync,
                              weeklyGoal,
                              dailyGoal,
                              nutritionGoalsAsync);
                        },
                        loading: () => _buildLoadingCard(),
                        error: (_, __) => _buildErrorCard(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FoodSearchBar(
                  hintText: 'Search any food...',
                  onFoodSelected: (food) =>
                      _showAddMealDialog(context, ref, food),
                ),
                const SizedBox(height: 24),
                Text('Food Categories',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ModernFoodCategories(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyGoalCard(
    BuildContext context,
    AsyncValue<Map<String, double>> dailyProgressAsync,
    double weeklyGoal,
    double dailyGoal,
    AsyncValue<Map<String, double>> nutritionGoalsAsync,
  ) {
    return dailyProgressAsync.when(
      data: (dailyProgress) {
        final dailyCalorieProgress = dailyProgress['calories'] ?? 0.0;
        final dailyConsumedCalories = dailyCalorieProgress * dailyGoal;
        final weeklyProjectedCalories = dailyConsumedCalories * 7;
        final weeklyCalorieProgress =
            (weeklyGoal > 0 ? weeklyProjectedCalories / weeklyGoal : 0.0)
                .clamp(0.0, 1.0);

        final proteinGoal =
            nutritionGoalsAsync.valueOrNull?['protein'] ?? 150.0;
        final carbsGoal = nutritionGoalsAsync.valueOrNull?['carbs'] ?? 250.0;
        final fatGoal = nutritionGoalsAsync.valueOrNull?['fat'] ?? 67.0;

        final dailyProteinProgress = dailyProgress['protein'] ?? 0.0;
        final dailyCarbsProgress = dailyProgress['carbs'] ?? 0.0;
        final dailyFatProgress = dailyProgress['fat'] ?? 0.0;

        final weeklyProjectedProtein = (dailyProteinProgress * proteinGoal) * 7;
        final weeklyProjectedCarbs = (dailyCarbsProgress * carbsGoal) * 7;
        final weeklyProjectedFat = (dailyFatProgress * fatGoal) * 7;

        final weeklyProteinProgressRatio = (proteinGoal * 7 > 0
                ? weeklyProjectedProtein / (proteinGoal * 7)
                : 0.0)
            .clamp(0.0, 1.0);
        final weeklyCarbsProgressRatio =
            (carbsGoal * 7 > 0 ? weeklyProjectedCarbs / (carbsGoal * 7) : 0.0)
                .clamp(0.0, 1.0);
        final weeklyFatProgressRatio =
            (fatGoal * 7 > 0 ? weeklyProjectedFat / (fatGoal * 7) : 0.0)
                .clamp(0.0, 1.0);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade400, Colors.purple.shade600],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: const [
                            Icon(Icons.calendar_view_week,
                                color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text('Weekly Goal',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(height: 8),
                          Text(weeklyProjectedCalories.toInt().toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                          const Text('projected calories this week',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    ProgressRing(weeklyCalorieProgress, Colors.white),
                  ],
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isWeeklyGoalExpanded = !_isWeeklyGoalExpanded;
                      if (_isWeeklyGoalExpanded) {
                        _weeklyController.forward();
                      } else {
                        _weeklyController.reverse();
                      }
                    });
                  },
                  child: Icon(
                    _isWeeklyGoalExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Colors.white,
                  ),
                ),
                SizeTransition(
                  sizeFactor: _weeklyAnimation,
                  child: Column(
                    children: [
                      NutritionRow(
                          'Protein', weeklyProteinProgressRatio, Colors.white),
                      NutritionRow(
                          'Carbs', weeklyCarbsProgressRatio, Colors.white),
                      NutritionRow('Fat', weeklyFatProgressRatio, Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => _buildLoadingCard(),
      error: (_, __) => _buildErrorCard(),
    );
  }

  Widget _buildLoadingCard() => Container(
        height: 120,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20)),
        child: const Center(child: CircularProgressIndicator()),
      );

  Widget _buildErrorCard() => Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: const Center(
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.error_outline, color: Colors.red, size: 20),
            SizedBox(width: 8),
            Text('Error loading data', style: TextStyle(color: Colors.red)),
          ]),
        ),
      );

  void _showAddMealDialog(BuildContext context, WidgetRef ref, Food food) {
    showDialog(
        context: context, builder: (_) => AddMealDialog(food: food, ref: ref));
  }
}
