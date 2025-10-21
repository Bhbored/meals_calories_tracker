import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/gradient_background.dart';
import '../repos/preferences_repository.dart';
import '../providers/meal_provider.dart';
import '../models/consumed_meal.dart';

class ConsumeScreen extends ConsumerStatefulWidget {
  const ConsumeScreen({super.key});

  @override
  ConsumerState<ConsumeScreen> createState() => _ConsumeScreenState();
}

class _ConsumeScreenState extends ConsumerState<ConsumeScreen> {
  final PreferencesRepository _preferencesRepository = PreferencesRepository();
  final TextEditingController _searchController = TextEditingController();
  bool _isDark = false;
  bool _isLoadingTheme = true;
  List<ConsumedMeal> _filteredMeals = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  Future<void> _loadTheme() async {
    try {
      final isDark = await _preferencesRepository.isDarkMode();
      if (mounted) {
        setState(() {
          _isDark = isDark;
          _isLoadingTheme = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDark = false;
          _isLoadingTheme = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayMealsAsync = ref.watch(todayMealsProvider);
    final dailyProgressAsync = ref.watch(dailyProgressProvider);

    if (_isLoadingTheme) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GradientBackground(
      isDark: _isDark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Today\'s Consumption'),
          backgroundColor: Colors.transparent,
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Reset', style: TextStyle(color: Colors.white)),
              onPressed: () => _resetDailyConsumption(context, ref),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Daily progress card
                dailyProgressAsync.when(
                  data: (progress) =>
                      _buildDailyProgressCard(context, progress),
                  loading: () => _buildLoadingCard(context),
                  error: (error, stack) => _buildErrorCard(context),
                ),

                const SizedBox(height: 20),

                // Search bar
                _buildSearchBar(context),

                const SizedBox(height: 20),

                // Meals list
                Expanded(
                  child: todayMealsAsync.when(
                    data: (meals) {
                      _filteredMeals = meals.where((meal) {
                        if (_searchQuery.isEmpty) return true;
                        return meal.food.name
                            .toLowerCase()
                            .contains(_searchQuery);
                      }).toList();

                      if (_filteredMeals.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.no_food,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'No meals logged today'
                                    : 'No meals found',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Go to Home to search and add foods'
                                    : 'Try a different search term',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[500],
                                    ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: _filteredMeals.length,
                        itemBuilder: (context, index) {
                          final meal = _filteredMeals[index];
                          return _buildMealCard(context, meal);
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: $error'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyProgressCard(
      BuildContext context, Map<String, double> progress) {
    final caloriesProgress = progress['calories'] ?? 0.0;
    final proteinProgress = progress['protein'] ?? 0.0;
    final carbsProgress = progress['carbs'] ?? 0.0;
    final fatProgress = progress['fat'] ?? 0.0;
    final fiberProgress = progress['fiber'] ?? 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.today, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Daily Progress',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressRow(
                context, 'Calories', caloriesProgress, Colors.orange),
            const SizedBox(height: 8),
            _buildProgressRow(context, 'Protein', proteinProgress, Colors.blue),
            const SizedBox(height: 8),
            _buildProgressRow(context, 'Carbs', carbsProgress, Colors.green),
            const SizedBox(height: 8),
            _buildProgressRow(context, 'Fat', fatProgress, Colors.purple),
            const SizedBox(height: 8),
            _buildProgressRow(context, 'Fiber', fiberProgress, Colors.brown),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(
      BuildContext context, String label, double progress, Color color) {
    final percentage = (progress * 100).clamp(0, 100).toInt();

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        Expanded(
          flex: 5,
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            color: color,
            backgroundColor: Colors.white.withOpacity(0.3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$percentage%',
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search your meals...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, ConsumedMeal meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: meal.isConsumed
              ? [Colors.green.shade100, Colors.green.shade50]
              : [
                  Colors.white,
                  Colors.grey.shade50,
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Food image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: meal.food.imageUrl != null
                    ? FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: meal.food.imageUrl!,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 500),
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Container(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Icon(
                            Icons.fastfood,
                            color: Theme.of(context).primaryColor,
                            size: 32,
                          ),
                        ),
                      )
                    : Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.fastfood,
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 16),

            // Meal details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.food.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${meal.quantity} servings • ${meal.totalCalories.toInt()} cal',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildNutritionChip(
                          'P: ${meal.totalProtein.toInt()}g', Colors.blue),
                      const SizedBox(width: 8),
                      _buildNutritionChip(
                          'C: ${meal.totalCarbs.toInt()}g', Colors.green),
                      const SizedBox(width: 8),
                      _buildNutritionChip(
                          'F: ${meal.totalFat.toInt()}g', Colors.purple),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Column(
              children: [
                if (!meal.isConsumed)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.check,
                          color: Colors.green, size: 20),
                      onPressed: () => _consumeMeal(context, meal),
                      tooltip: 'Mark as consumed',
                    ),
                  ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => _removeMeal(context, meal.id),
                    tooltip: 'Delete meal',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 32),
            SizedBox(height: 8),
            Text('Error loading data', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  void _consumeMeal(BuildContext context, ConsumedMeal meal) async {
    try {
      await ref
          .read(todayMealsProvider.notifier)
          .updateMealConsumedStatus(meal.id, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${meal.food.name} marked as consumed!'),
          backgroundColor: Colors.green,
        ),
      );

      // Check if daily goal is reached
      final progress = await ref.read(dailyProgressProvider.future);
      if (progress['calories'] != null && progress['calories']! >= 1.0) {
        _showGoalReachedDialog(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetDailyConsumption(BuildContext context, WidgetRef ref) async {
    await ref.read(todayMealsProvider.notifier).resetTodaysMeals();
  }

  void _removeMeal(BuildContext context, String mealId) async {
    try {
      await ref.read(todayMealsProvider.notifier).removeMeal(mealId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meal removed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing meal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showGoalReachedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.green, size: 28),
            const SizedBox(width: 8),
            const Text('Goal Reached!'),
          ],
        ),
        content: const Text(
          'Congratulations! You\'ve reached your daily calorie goal. '
          'Keep up the great work!',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child:
                const Text('Awesome!', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
