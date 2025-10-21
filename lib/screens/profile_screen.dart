import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_calories_tracker/screens/edit_goal_screen.dart';
import '../widgets/gradient_background.dart';
import '../repos/preferences_repository.dart';
import '../providers/meal_provider.dart';

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
                        Text(
                          'Nutrition Goals',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        
                        Card(
                          child: Column(
                            children: [
                              _buildGoalTile(
                                context,
                                'Daily Calories',
                                goals['calories'] ?? 2000,
                                '${goals['calories']?.toInt() ?? 2000} cal',
                                Icons.local_fire_department,
                                Colors.orange,
                              ),
                              const Divider(),
                              _buildGoalTile(
                                context,
                                'Protein',
                                goals['protein'] ?? 150,
                                '${goals['protein']?.toInt() ?? 150} g',
                                Icons.fitness_center,
                                Colors.blue,
                              ),
                              const Divider(),
                              _buildGoalTile(
                                context,
                                'Carbohydrates',
                                goals['carbs'] ?? 250,
                                '${goals['carbs']?.toInt() ?? 250} g',
                                Icons.grain,
                                Colors.green,
                              ),
                              const Divider(),
                              _buildGoalTile(
                                context,
                                'Fat',
                                goals['fat'] ?? 67,
                                '${goals['fat']?.toInt() ?? 67} g',
                                Icons.opacity,
                                Colors.purple,
                              ),
                              const Divider(),
                              _buildGoalTile(
                                context,
                                'Fiber',
                                goals['fiber'] ?? 25,
                                '${goals['fiber']?.toInt() ?? 25} g',
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
                              const SnackBar(content: Text('Feedback feature coming soon!')),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.privacy_tip),
                          title: const Text('Privacy Policy'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Privacy policy coming soon!')),
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
    double initialValue,
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
      onTap: () => _editGoal(context, title, initialValue),
    );
  }

  void _editGoal(BuildContext context, String goalName, double initialValue) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditGoalScreen(
          goalName: goalName,
          initialValue: initialValue,
        ),
      ),
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
                const SnackBar(content: Text('Data reset feature coming soon!')),
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