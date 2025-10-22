import 'package:flutter/material.dart';
import 'package:meals_calories_tracker/screens/home/widgets/nutrition_row.dart';
import 'package:meals_calories_tracker/screens/home/widgets/progress_ring.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class DailyGoalCard extends StatefulWidget {
  const DailyGoalCard(
      this.context,
      this.caloriesRemaining,
      this.dailyProgressAsync,
      this.dailyGoalKcal,
      this.isDailyGoalExpanded,
      this.controller,
      this.animation,
      {super.key});
  final BuildContext context;
  final double caloriesRemaining;
  final AsyncValue<Map<String, double>> dailyProgressAsync;
  final double dailyGoalKcal;
  final bool isDailyGoalExpanded;
  final AnimationController controller;
  final Animation<double> animation;
  @override
  State<DailyGoalCard> createState() => _DailyGoalCardState();
}

class _DailyGoalCardState extends State<DailyGoalCard> {
  @override
  Widget build(BuildContext context) {
    final isOver = widget.caloriesRemaining < 0;
    final displayValue = widget.caloriesRemaining.abs();
    final dailyProgressAsync = widget.dailyProgressAsync;
    final dailyGoalKcal = widget.dailyGoalKcal;
    var isDailyGoalExpanded = widget.isDailyGoalExpanded;
    var controller = widget.controller;
    var animation = widget.animation;
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
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                dailyProgressAsync.when(
                  data: (progress) {
                    final kcal = (progress['calories'] ?? 0.0)
                        .clamp(0.0, double.infinity);
                    final pct = (kcal / dailyGoalKcal).clamp(0.0, 1.0);
                    return ProgressRing(pct, Colors.white);
                  },
                  loading: () => const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(color: Colors.white)),
                  error: (_, __) => const ProgressRing(0.0, Colors.white),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isDailyGoalExpanded = !isDailyGoalExpanded;
                  if (isDailyGoalExpanded) {
                    controller.forward();
                  } else {
                    controller.reverse();
                  }
                });
              },
              child: Icon(
                isDailyGoalExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
              ),
            ),
            SizeTransition(
              sizeFactor: animation,
              child: dailyProgressAsync.when(
                data: (progress) => Column(
                  children: [
                    NutritionRow(
                        'Protein', progress['protein'] ?? 0, Colors.white),
                    NutritionRow('Carbs', progress['carbs'] ?? 0, Colors.white),
                    NutritionRow('Fat', progress['fat'] ?? 0, Colors.white),
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
}
