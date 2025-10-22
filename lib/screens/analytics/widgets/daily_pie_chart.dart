import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_calories_tracker/providers/analytics_provider.dart';

class DailyPieChart extends ConsumerWidget {
  const DailyPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}

// _buildTodayMacrosPieChart
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
