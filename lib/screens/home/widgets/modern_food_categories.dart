import 'package:flutter/material.dart';
import 'package:meals_calories_tracker/models/food_category.dart';
import 'package:meals_calories_tracker/screens/home/widgets/category_card.dart';

class ModernFoodCategories extends StatefulWidget {
  const ModernFoodCategories(this.context, {super.key});
  final BuildContext context;
  @override
  State<ModernFoodCategories> createState() => _ModernFoodCategoriesState();
}

class _ModernFoodCategoriesState extends State<ModernFoodCategories> {
  @override
  Widget build(BuildContext context) {
    final categories = FoodCategory.getDefaultCategories();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (_, i) => CategoryCard(context, categories[i]),
    );
  }
}

// _buildModernFoodCategories
