import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/gradient_background.dart';
import '../widgets/food_search_bar.dart';
import '../repos/preferences_repository.dart';
import '../providers/meal_provider.dart';
import '../models/food_category.dart';
import '../models/food.dart';
import 'category_meals_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  final PreferencesRepository _preferencesRepository = PreferencesRepository();
  bool _isDark = false;
  bool _isLoadingTheme = true;
  bool _isDailyGoalExpanded = false;

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
                            data: (calRemaining) => _buildDailyGoalCard(context,
                                calRemaining, dailyProgressAsync, dailyGoal),
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
                          return dailyProgressAsync.when(
                            data: (daily) => _buildWeeklyGoalCard(
                                context, daily, weeklyGoal),
                            loading: () => _buildLoadingCard(),
                            error: (_, __) => _buildErrorCard(),
                          );
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
                _buildModernFoodCategories(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Cards ---
  Widget _buildDailyGoalCard(
    BuildContext context,
    double caloriesRemaining,
    AsyncValue<Map<String, double>> dailyProgressAsync,
    double dailyGoalKcal,
  ) {
    final isOver = caloriesRemaining < 0;
    final displayValue = caloriesRemaining.abs();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isOver
              ? [Colors.red.shade400, Colors.red.shade600]
              : [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isOver ? Colors.red : Colors.blue).withOpacity(0.3),
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
                      Row(children: [
                        Icon(isOver ? Icons.trending_up : Icons.trending_down,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(isOver ? 'Over Goal' : 'Daily Goal',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ]),
                      const SizedBox(height: 8),
                      Text('${displayValue.toInt()}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      const Text('calories remaining',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                dailyProgressAsync.when(
                  data: (progress) {
                    final kcal =
                        (progress['calories'] ?? 0.0).clamp(0.0, double.infinity);
                    final pct = (kcal / dailyGoalKcal).clamp(0.0, 1.0);
                    return _buildProgressRing(pct, Colors.white);
                  },
                  loading: () => const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(color: Colors.white)),
                  error: (_, __) => _buildProgressRing(0.0, Colors.white),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _isDailyGoalExpanded = !_isDailyGoalExpanded;
                  if (_isDailyGoalExpanded) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                });
              },
              child: Icon(
                _isDailyGoalExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
              ),
            ),
            SizeTransition(
              sizeFactor: _animation,
              child: dailyProgressAsync.when(
                data: (progress) => Column(
                  children: [
                    _buildNutritionRow('Protein', progress['protein'] ?? 0, Colors.white),
                    _buildNutritionRow('Carbs', progress['carbs'] ?? 0, Colors.white),
                    _buildNutritionRow('Fat', progress['fat'] ?? 0, Colors.white),
                  ],
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: color, fontSize: 12)),
              Text('${(value * 100).toInt()}%', style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoalCard(
    BuildContext context,
    Map<String, double> dailyData,
    double weeklyGoal,
  ) {
    final dailyCalories = dailyData['calories'] ?? 0.0;
    final weeklyCalories = (dailyCalories * 7).clamp(0.0, double.infinity);
    final progress = (weeklyCalories / weeklyGoal).clamp(0.0, 1.0);

    return Container(
      height: 120,
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
        child: Row(
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
                  Text(weeklyCalories.toInt().toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const Text('calories this week',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            _buildProgressRing(progress, Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRing(double progress, Color color) {
    final p = progress.clamp(0.0, 1.0);
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(children: [
        CircularProgressIndicator(
          value: p,
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: color.withOpacity(0.2),
        ),
        Center(
          child: Text('${(p * 100).toInt()}%',
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }

  // --- Categories grid ---
  Widget _buildModernFoodCategories(BuildContext context) {
    final categories = FoodCategory.getDefaultCategories();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (_, i) => _buildModernCategoryCard(context, categories[i]),
    );
  }

  Widget _buildModernCategoryCard(BuildContext context, FoodCategory category) {
    final hex = category.color.toString().replaceAll('#', '');
    final color = Color(int.parse('FF$hex', radix: 16));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToCategory(context, category),
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle),
                child:
                    Text(category.icon, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 8),
              Text(category.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text('${category.tags.length} items',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
            ]),
          ),
        ),
      ),
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

  // --- Nav & dialogs ---
  void _navigateToCategory(BuildContext context, FoodCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => CategoryMealsScreen(category: category)),
    );
  }

  void _showAddMealDialog(BuildContext context, WidgetRef ref, Food food) {
    showDialog(
        context: context, builder: (_) => _AddMealDialog(food: food, ref: ref));
  }
}

class _AddMealDialog extends StatefulWidget {
  final Food food;
  final WidgetRef ref;
  const _AddMealDialog({required this.food, required this.ref});

  @override
  State<_AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<_AddMealDialog> {
  final TextEditingController _quantityController =
      TextEditingController(text: '1.0');

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add ${widget.food.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              '${widget.food.calories.toInt()} kcal per ${widget.food.servingSize}${widget.food.unit}'),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantity (servings)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        ElevatedButton(onPressed: _addMeal, child: const Text('Add')),
      ],
    );
  }

  Future<void> _addMeal() async {
    final q = double.tryParse(_quantityController.text) ?? 1.0;
    try {
      await widget.ref
          .read(todayMealsProvider.notifier)
          .addMeal(widget.food, q);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added ${widget.food.name} to your meals!')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error adding meal')));
    }
  }
}
