import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:meals_calories_tracker/screens/edit_goal_screen.dart'; // REMOVED
import '../base/widgets/gradient_background.dart';
import '../../core/db/repos/preferences_repository.dart';
import '../../providers/meal_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
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

  Future<void> _toggleTheme() async {
    try {
      await _preferencesRepository.toggleDarkMode();
      if (mounted) {
        setState(() {
          _isDark = !_isDark;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling theme: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nutritionGoalsAsync = ref.watch(nutritionGoalsProvider);

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
          title: const Text('Settings & Goals'),
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Theme toggle
                Card(
                  child: ListTile(
                    leading: Icon(_isDark ? Icons.dark_mode : Icons.light_mode),
                    title: const Text('Theme'),
                    subtitle: Text(_isDark ? 'Dark Mode' : 'Light Mode'),
                    trailing: Switch(
                      value: _isDark,
                      onChanged: (_) => _toggleTheme(),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Nutrition goals
                nutritionGoalsAsync.when(
                  data: (goals) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // ADDED
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // ADDED
                        children: [
                          // ADDED
                          Text(
                            'Nutrition Goals',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            // ADDED
                            icon: const Icon(Icons.edit), // ADDED
                            onPressed: () => _showEditGoalsBottomSheet(
                                context, goals), // ADDED
                          ), // ADDED
                        ], // ADDED
                      ), // ADDED
                      const SizedBox(height: 12),

                      Card(
                        child: Column(
                          children: [
                            _buildGoalTile(
                              context,
                              'Daily Calories',
                              '${goals['calories']?.toInt() ?? 2000} cal', // MODIFIED
                              Icons.local_fire_department,
                              Colors.orange,
                            ),
                            const Divider(),
                            _buildGoalTile(
                              context,
                              'Protein',
                              '${goals['protein']?.toInt() ?? 150} g', // MODIFIED
                              Icons.fitness_center,
                              Colors.blue,
                            ),
                            const Divider(),
                            _buildGoalTile(
                              context,
                              'Carbohydrates',
                              '${goals['carbs']?.toInt() ?? 250} g', // MODIFIED
                              Icons.grain,
                              Colors.green,
                            ),
                            const Divider(),
                            _buildGoalTile(
                              context,
                              'Fat',
                              '${goals['fat']?.toInt() ?? 67} g', // MODIFIED
                              Icons.opacity,
                              Colors.purple,
                            ),
                            const Divider(),
                            _buildGoalTile(
                              context,
                              'Fiber',
                              '${goals['fiber']?.toInt() ?? 25} g', // MODIFIED
                              Icons.eco,
                              Colors.green[700]!,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  loading: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (error, stack) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Error loading goals: $error'),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // App info
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.info),
                        title: Text('About'),
                        subtitle: Text('Meal Calories Tracker v1.0.0'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.feedback),
                        title: const Text('Feedback'),
                        subtitle: const Text('Help us improve the app'),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Feedback feature coming soon!')),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip),
                        title: const Text('Privacy Policy'),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Privacy policy coming soon!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Reset data button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showResetDataDialog(context, ref),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Reset All Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildGoalTile(
    BuildContext context,
    String title,
    // double initialValue, // REMOVED
    String value,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
      // onTap: () => _editGoal(context, title, initialValue), // REMOVED
    );
  }

  // void _editGoal(BuildContext context, String goalName, double initialValue) { // REMOVED
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => EditGoalScreen(
  //         goalName: goalName,
  //         initialValue: initialValue,
  //       ),
  //     ),
  //   );
  // }

  void _showEditGoalsBottomSheet(
      BuildContext context, Map<String, double> currentGoals) {
    // ADDED
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EditGoalsBottomSheet(initialGoals: currentGoals),
    );
  }

  void _showResetDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data'),
        content: const Text(
          'This will permanently delete all your meal history, preferences, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Data reset feature coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

// _EditGoalsBottomSheet class content (as provided by the user in the last turn)
class _EditGoalsBottomSheet extends ConsumerStatefulWidget {
  final Map<String, double> initialGoals;

  const _EditGoalsBottomSheet({required this.initialGoals});

  @override
  ConsumerState<_EditGoalsBottomSheet> createState() =>
      _EditGoalsBottomSheetState();
}

class _EditGoalsBottomSheetState extends ConsumerState<_EditGoalsBottomSheet> {
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _fiberController;

  @override
  void initState() {
    super.initState();
    _caloriesController = TextEditingController(
        text: widget.initialGoals['calories']?.toInt().toString());
    _proteinController = TextEditingController(
        text: widget.initialGoals['protein']?.toInt().toString());
    _carbsController = TextEditingController(
        text: widget.initialGoals['carbs']?.toInt().toString());
    _fatController = TextEditingController(
        text: widget.initialGoals['fat']?.toInt().toString());
    _fiberController = TextEditingController(
        text: widget.initialGoals['fiber']?.toInt().toString());
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    super.dispose();
  }

  Future<void> _saveGoals() async {
    final notifier = ref.read(nutritionGoalsProvider.notifier);

    try {
      await notifier.updateDailyCalorieGoal(
          double.tryParse(_caloriesController.text) ?? 0);
      await notifier
          .updateProteinGoal(double.tryParse(_proteinController.text) ?? 0);
      await notifier
          .updateCarbGoal(double.tryParse(_carbsController.text) ?? 0);
      await notifier.updateFatGoal(double.tryParse(_fatController.text) ?? 0);
      await notifier
          .updateFiberGoal(double.tryParse(_fiberController.text) ?? 0);

      // Invalidate the provider to trigger a rebuild with new goals
      ref.invalidate(nutritionGoalsProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goals updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving goals: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Nutrition Goals',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildGoalInputField('Daily Calories (kcal)', _caloriesController,
                Icons.local_fire_department, Colors.orange),
            const SizedBox(height: 16),
            _buildGoalInputField('Protein (g)', _proteinController,
                Icons.fitness_center, Colors.blue),
            const SizedBox(height: 16),
            _buildGoalInputField('Carbohydrates (g)', _carbsController,
                Icons.grain, Colors.green),
            const SizedBox(height: 16),
            _buildGoalInputField(
                'Fat (g)', _fatController, Icons.opacity, Colors.purple),
            const SizedBox(height: 16),
            _buildGoalInputField(
                'Fiber (g)', _fiberController, Icons.eco, Colors.green[700]!),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveGoals,
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalInputField(String label, TextEditingController controller,
      IconData icon, Color color) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }
}
