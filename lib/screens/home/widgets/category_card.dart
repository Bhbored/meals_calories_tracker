import 'package:flutter/material.dart';
import 'package:meals_calories_tracker/models/food_category.dart';
import 'package:meals_calories_tracker/screens/home/category_meals_screen.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(this.context, this.category, {super.key});
  final BuildContext context;
  final FoodCategory category;

  void _navigateToCategory(BuildContext context, FoodCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => CategoryMealsScreen(category: category)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hex = category.color.toString().replaceAll('#', '');
    final color = Color(int.parse('FF$hex', radix: 16));
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToCategory(context, category),
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle),
                child:
                    Text(category.icon, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 8),
              Text(category.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text('${category.tags.length} items',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
            ]),
          ),
        ),
      ),
    );
  }
}

// _buildModernCategoryCard
