
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/meal_provider.dart';
import '../widgets/gradient_background.dart';

class EditGoalScreen extends ConsumerStatefulWidget {
  final String goalName;
  final double initialValue;

  const EditGoalScreen({
    super.key,
    required this.goalName,
    required this.initialValue,
  });

  @override
  ConsumerState<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends ConsumerState<EditGoalScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    final value = double.tryParse(_controller.text);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    try {
      final notifier = ref.read(nutritionGoalsProvider.notifier);
      switch (widget.goalName) {
        case 'Daily Calories':
          await notifier.updateDailyCalorieGoal(value);
          break;
        case 'Protein':
          await notifier.updateProteinGoal(value);
          break;
        case 'Carbohydrates':
          await notifier.updateCarbGoal(value);
          break;
        case 'Fat':
          await notifier.updateFatGoal(value);
          break;
        case 'Fiber':
          await notifier.updateFiberGoal(value);
          break;
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving goal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      isDark: Theme.of(context).brightness == Brightness.dark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Edit ${widget.goalName}'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'New ${widget.goalName} Goal',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGoal,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
