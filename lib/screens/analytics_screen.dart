import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'package:intl/intl.dart'; // For date formatting

import '../widgets/gradient_background.dart';
import '../repos/preferences_repository.dart';
import '../providers/analytics_provider.dart'; // Import analytics providers
import '../providers/meal_provider.dart'; // For nutrition goals

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  final PreferencesRepository _preferencesRepository = PreferencesRepository();
  bool _isDark = false;
  bool _isLoadingTheme = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
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
          title: const Text('Analytics'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Health Insights',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _isDark ? Colors.white : Colors.black87,
                      ),
                ),
                const SizedBox(height: 24),

                // Daily Calorie Intake Chart
                _buildChartCard(
                  context,
                  title: 'Daily Calorie Intake (Last 7 Days)',
                  child: _buildDailyCalorieChart(context),
                ),
                const SizedBox(height: 24),

                // Today's Macronutrient Distribution
                _buildChartCard(
                  context,
                  title: 'Today\'s Macronutrient Distribution',
                  child: _buildTodayMacrosPieChart(context),
                ),
                const SizedBox(height: 24),

                // Monthly Category Breakdown
                _buildChartCard(
                  context,
                  title: 'Monthly Food Category Breakdown',
                  child: _buildCategoryBreakdownPieChart(context),
                ),
                const SizedBox(height: 24),

                // Weekly Comparison
                _buildWeeklyComparison(context),
                const SizedBox(height: 24),

                // Streaks and Highlights
                _buildStreaksAndHighlights(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context,
      {required String title, required Widget child}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: _isDark ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isDark ? Colors.white : Colors.black87,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200, // Fixed height for charts
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCalorieChart(BuildContext context) {
    final calorieHistoryAsync = ref.watch(calorieHistoryProvider(7));
    final nutritionGoalsAsync = ref.watch(nutritionGoalsProvider);

    return calorieHistoryAsync.when(
      data: (history) {
        if (history.isEmpty) {
          return _buildNoDataWidget('No calorie data for the last 7 days.');
        }

        final dailyGoal =
            nutritionGoalsAsync.valueOrNull?['calories'] ?? 2000.0;

        final List<FlSpot> spots = [];
        final List<BarChartGroupData> barGroups = [];
        double maxCalories = dailyGoal * 1.2; // Max Y-axis value

        for (int i = 0; i < history.length; i++) {
          final day = history[i];
          final calories = (day['calories'] as double);
          spots.add(FlSpot(i.toDouble(), calories));
          barGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: calories,
                  color: calories > dailyGoal
                      ? Colors.redAccent
                      : Colors.blueAccent,
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
          if (calories > maxCalories) maxCalories = calories * 1.1;
        }

        return BarChart(
          BarChartData(
            barGroups: barGroups,
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final date = DateTime.now().subtract(
                        Duration(days: history.length - 1 - value.toInt()));
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 4,
                      child: Text(DateFormat('EEE').format(date),
                          style: TextStyle(
                              color: _isDark ? Colors.white70 : Colors.black54,
                              fontSize: 10)),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toInt().toString(),
                        style: TextStyle(
                            color: _isDark ? Colors.white70 : Colors.black54,
                            fontSize: 10));
                  },
                  reservedSize: 30,
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color:
                      (_isDark ? Colors.white12 : Colors.grey.withOpacity(0.2)),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final date = DateTime.now()
                      .subtract(Duration(days: history.length - 1 - group.x));
                  return BarTooltipItem(
                    '${DateFormat('MMM d').format(date)}\n',
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${rod.toY.toInt()} kcal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            maxY: maxCalories,
            minY: 0,
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error),
    );
  }

  Widget _buildTodayMacrosPieChart(BuildContext context) {
    final todayMacrosAsync = ref.watch(todayMacrosProvider);

    return todayMacrosAsync.when(
      data: (macros) {
        if (macros.isEmpty ||
            (macros['protein'] == 0 &&
                macros['carbs'] == 0 &&
                macros['fat'] == 0)) {
          return _buildNoDataWidget('No macro data for today.');
        }

        final protein = macros['protein'] ?? 0;
        final carbs = macros['carbs'] ?? 0;
        final fat = macros['fat'] ?? 0;

        return PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                color: Colors.blue,
                value: protein,
                title: '${protein.toInt()}% P',
                radius: 50,
                titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              PieChartSectionData(
                color: Colors.green,
                value: carbs,
                title: '${carbs.toInt()}% C',
                radius: 50,
                titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              PieChartSectionData(
                color: Colors.orange,
                value: fat,
                title: '${fat.toInt()}% F',
                radius: 50,
                titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
            sectionsSpace: 2,
            centerSpaceRadius: 40,
            borderData: FlBorderData(show: false),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error),
    );
  }

  Widget _buildCategoryBreakdownPieChart(BuildContext context) {
    final categoryBreakdownAsync = ref.watch(categoryBreakdownProvider);

    return categoryBreakdownAsync.when(
      data: (breakdown) {
        if (breakdown.isEmpty) {
          return _buildNoDataWidget('No category data for this month.');
        }

        final total =
            breakdown.values.fold<int>(0, (sum, count) => sum + count);
        final List<PieChartSectionData> sections = [];
        int i = 0;
        final colors = [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.orange,
          Colors.purple,
          Colors.teal,
          Colors.brown,
          Colors.indigo,
          Colors.cyan,
          Colors.pink,
        ];

        breakdown.forEach((category, count) {
          final percentage = (count / total) * 100;
          sections.add(
            PieChartSectionData(
              color: colors[i % colors.length],
              value: percentage,
              title: '${percentage.toInt()}% ${category}',
              radius: 50,
              titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          );
          i++;
        });

        return PieChart(
          PieChartData(
            sections: sections,
            sectionsSpace: 2,
            centerSpaceRadius: 40,
            borderData: FlBorderData(show: false),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error),
    );
  }

  Widget _buildWeeklyComparison(BuildContext context) {
    final weeklyComparisonAsync = ref.watch(weeklyComparisonProvider);

    return weeklyComparisonAsync.when(
      data: (data) {
        final current = data['current'] as Map<String, dynamic>;
        final previous = data['previous'] as Map<String, dynamic>;
        final changes = data['changes'] as Map<String, dynamic>;

        return Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: _isDark ? Colors.grey[850] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Comparison',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _isDark ? Colors.white : Colors.black87,
                      ),
                ),
                const SizedBox(height: 16),
                _buildComparisonRow('Calories', current['calories'] ?? 0.0,
                    previous['calories'] ?? 0.0, changes['calories'] ?? 0.0),
                _buildComparisonRow('Protein', current['protein'] ?? 0.0,
                    previous['protein'] ?? 0.0, changes['protein'] ?? 0.0,
                    unit: 'g'),
                _buildComparisonRow('Carbs', current['carbs'] ?? 0.0,
                    previous['carbs'] ?? 0.0, changes['carbs'] ?? 0.0,
                    unit: 'g'),
                _buildComparisonRow('Fat', current['fat'] ?? 0.0,
                    previous['fat'] ?? 0.0, changes['fat'] ?? 0.0,
                    unit: 'g'),
                _buildComparisonRow('Fiber', current['fiber'] ?? 0.0,
                    previous['fiber'] ?? 0.0, changes['fiber'] ?? 0.0,
                    unit: 'g'),
              ],
            ),
          ),
        );
      },
      loading: () => _buildLoadingCard(),
      error: (error, stack) => _buildErrorWidget(error),
    );
  }

  Widget _buildComparisonRow(
      String label, double current, double previous, double change,
      {String unit = 'kcal'}) {
    Color changeColor = Colors.grey;
    IconData changeIcon = Icons.remove;

    if (change > 0) {
      changeColor = Colors.green;
      changeIcon = Icons.arrow_upward;
    } else if (change < 0) {
      changeColor = Colors.red;
      changeIcon = Icons.arrow_downward;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                  color: _isDark ? Colors.white70 : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${current.toInt()} $unit',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _isDark ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(changeIcon, color: changeColor, size: 16),
                Text(
                  '${change.abs().toStringAsFixed(1)}%',
                  style: TextStyle(color: changeColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreaksAndHighlights(BuildContext context) {
    final calorieGoalStreakAsync = ref.watch(calorieGoalStreakProvider);
    final monthlyHighlightsAsync = ref.watch(monthlyHighlightsProvider);

    return Column(
      children: [
        calorieGoalStreakAsync.when(
          data: (streak) => _buildInfoCard(
            context,
            icon: Icons.local_fire_department,
            title: 'Calorie Goal Streak',
            value: '$streak days',
            color: Colors.orange,
          ),
          loading: () => _buildLoadingCard(),
          error: (error, stack) => _buildErrorWidget(error),
        ),
        const SizedBox(height: 16),
        monthlyHighlightsAsync.when(
          data: (highlights) {
            final bestDay = highlights['best'] as Map<String, dynamic>?;
            final worstDay = highlights['worst'] as Map<String, dynamic>?;
            final averageCalories =
                highlights['averageCalories'] as double? ?? 0.0;

            return Column(
              children: [
                _buildInfoCard(
                  context,
                  icon: Icons.star,
                  title: 'Best Day (Calories)',
                  value: bestDay != null
                      ? '${(bestDay['calories'] as double).toInt()} kcal on ${DateFormat('MMM d').format(bestDay['date'] as DateTime)}'
                      : 'N/A',
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  icon: Icons.warning,
                  title: 'Worst Day (Calories)',
                  value: worstDay != null
                      ? '${(worstDay['calories'] as double).toInt()} kcal on ${DateFormat('MMM d').format(worstDay['date'] as DateTime)}'
                      : 'N/A',
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Monthly Average Calories',
                  value: '${averageCalories.toInt()} kcal',
                  color: Colors.blue,
                ),
              ],
            );
          },
          loading: () => _buildLoadingCard(),
          error: (error, stack) => _buildErrorWidget(error),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String value,
      required Color color}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: _isDark ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _isDark ? Colors.white : Colors.black87,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: _isDark ? Colors.grey[850] : Colors.white,
      child: const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildNoDataWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 40, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            'Error: ${error.toString()}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
