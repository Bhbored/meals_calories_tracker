import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../base/widgets/gradient_background.dart';
import '../../core/db/repos/preferences_repository.dart';
import '../../providers/meal_provider.dart';
import '../../models/food_category.dart';
import '../../models/consumed_meal.dart';

/// Small helpers to avoid dynamic/tear-off pitfalls
extension _Lower on String {
  String l() => toLowerCase();
}

extension _IterString on Iterable {
  Iterable<String> asStringsLower() =>
      where((e) => e != null).map((e) => e.toString().toLowerCase());
}

bool _anyTagOverlap(Iterable? a, Iterable? b) {
  if (a == null || b == null) return false;
  final bset = b.asStringsLower().toSet();
  for (final e in a.asStringsLower()) {
    if (bset.contains(e)) return true;
  }
  return false;
}

class CategoryMealsScreen extends ConsumerStatefulWidget {
  final FoodCategory category;
  const CategoryMealsScreen({super.key, required this.category});

  @override
  ConsumerState<CategoryMealsScreen> createState() =>
      _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends ConsumerState<CategoryMealsScreen> {
  final _prefs = PreferencesRepository();
  bool _isDark = false;
  bool _loadingTheme = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final isDark = await _prefs.isDarkMode();
      if (!mounted) return;
      setState(() {
        _isDark = isDark;
        _loadingTheme = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isDark = false;
        _loadingTheme = false;
      });
    }
  }

  bool _matches(ConsumedMeal m, FoodCategory c) {
    final food = m.food;
    final foodCat = (food.category).toString().l();
    final cName = (c.name).l();
    final cId = (c.id).toString().l();

    if (foodCat.contains(cName) || foodCat.contains(cId)) return true;

    // tag intersection (SAFE: no tear-offs, no dynamic predicates)
    if (_anyTagOverlap(food.tags, c.tags)) return true;

    // dietary booleans (null-safe)
    if (c.isVegan == true && food.isVegan == true) return true;
    if (c.isVegetarian == true && food.isVegetarian == true) return true;
    if (c.isGlutenFree == true && food.isGlutenFree == true) return true;
    if (c.isLactoseFree == true && food.isLactoseFree == true) return true;
    if (c.isDairyFree == true && food.isDairyFree == true) return true;
    if (c.isNutFree == true && food.isNutFree == true) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final mealsAsync =
        ref.watch(todayMealsProvider); // AsyncValue<List<ConsumedMeal>>

    if (_loadingTheme) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GradientBackground(
      isDark: _isDark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              Text(widget.category.icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child:
                    Text(widget.category.name, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: mealsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _FriendlyError(isDark: _isDark),
            data: (meals) {
              final filtered =
                  meals.where((m) => _matches(m, widget.category)).toList();

              if (filtered.isEmpty) {
                return _Empty(
                    isDark: _isDark,
                    emoji: widget.category.icon,
                    title: 'No items yet',
                    sub:
                        'Nothing under ${widget.category.name.toLowerCase()} today.');
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) =>
                    _MealTile(meal: filtered[i], isDark: _isDark),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MealTile extends StatelessWidget {
  final ConsumedMeal meal;
  final bool isDark;
  const _MealTile({required this.meal, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          child: Text(
            meal.food.name.isNotEmpty
                ? meal.food.name.characters.first.toUpperCase()
                : '?',
          ),
        ),
        title:
            Text(meal.food.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${meal.totalCalories.toStringAsFixed(0)} kcal • '
          '${meal.totalProtein.toStringAsFixed(1)} P • '
          '${meal.totalCarbs.toStringAsFixed(1)} C • '
          '${meal.totalFat.toStringAsFixed(1)} F',
        ),
        trailing: Text(
          '${meal.quantity.toStringAsFixed(0)} ${meal.food.unit}',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final bool isDark;
  final String emoji;
  final String title;
  final String sub;
  const _Empty(
      {required this.isDark,
      required this.emoji,
      required this.title,
      required this.sub});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Colors.white.withOpacity(0.06),
                    Colors.white.withOpacity(0.03)
                  ]
                : [Colors.grey.shade50, Colors.grey.shade100],
          ),
          boxShadow: [
            if (!isDark)
              const BoxShadow(
                  color: Colors.black12, blurRadius: 14, offset: Offset(0, 8)),
          ],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(sub, textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class _FriendlyError extends StatelessWidget {
  final bool isDark;
  const _FriendlyError({required this.isDark});
  @override
  Widget build(BuildContext context) {
    final bg = isDark ? Colors.red.withOpacity(0.15) : Colors.red.shade50;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 12),
          Flexible(child: Text("Couldn't load this category right now.")),
        ]),
      ),
    );
  }
}
