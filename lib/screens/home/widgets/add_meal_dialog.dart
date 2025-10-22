import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_calories_tracker/models/food.dart';
import 'package:meals_calories_tracker/providers/meal_provider.dart';

class AddMealDialog extends StatefulWidget {
  final Food food;
  final WidgetRef ref;
  const AddMealDialog({super.key, required this.food, required this.ref});

  @override
  State<AddMealDialog> createState() => AddMealDialogState();
}

class AddMealDialogState extends State<AddMealDialog> {
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
