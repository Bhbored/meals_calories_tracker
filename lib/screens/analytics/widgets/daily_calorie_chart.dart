import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meals_calories_tracker/providers/analytics_provider.dart';
import 'package:meals_calories_tracker/providers/meal_provider.dart';

class DailyCalorieChart extends ConsumerWidget {
  const DailyCalorieChart(this.isDark, {super.key});
  final bool isDark;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                              color: isDark ? Colors.white70 : Colors.black54,
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
                            color: isDark ? Colors.white70 : Colors.black54,
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
                      (isDark ? Colors.white12 : Colors.grey.withOpacity(0.2)),
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
}

// _buildDailyCalorieChart
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
