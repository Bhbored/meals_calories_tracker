import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/food.dart';
import '../../../providers/meal_provider.dart';

class FoodSearchBar extends ConsumerStatefulWidget {
  final Function(Food)? onFoodSelected;
  final String? category;
  final String hintText;

  const FoodSearchBar({
    super.key,
    this.onFoodSelected,
    this.category,
    this.hintText = 'Search for food...',
  });

  @override
  ConsumerState<FoodSearchBar> createState() => _FoodSearchBarState();
}

class _FoodSearchBarState extends ConsumerState<FoodSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;
  List<Food> _searchResults = [];
  Timer? _debounce;
  String? _errorMessage; // ADDED

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _performSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
          _errorMessage = null; // ADDED
        });
        return;
      }

      setState(() {
        _isSearching = true;
        _errorMessage = null; // ADDED
      });

      try {
        final foods = await ref
            .read(foodSearchProvider(query, category: widget.category).future);
        setState(() {
          _searchResults = foods;
          _isSearching = false;
          _errorMessage = null; // ADDED
        });
      } catch (e) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
          _errorMessage =
              'Error searching for food: ${e.toString()}'; // MODIFIED
        });
      }
    });
  }

  void _selectFood(Food food) {
    _controller.clear();
    _focusNode.unfocus();
    setState(() {
      _searchResults = [];
      _isSearching = false;
      _errorMessage = null; // ADDED
    });

    if (widget.onFoodSelected != null) {
      widget.onFoodSelected!(food);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _performSearch,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            setState(() {
                              _searchResults = [];
                              _errorMessage = null; // ADDED
                            });
                          },
                        )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
        ),

        // Search results dropdown
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ] else if (_searchResults.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final food = _searchResults[index];
                return FoodSearchResultTile(
                  food: food,
                  onTap: () => _selectFood(food),
                );
              },
            ),
          ),
        ] else if (!_isSearching && _controller.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'No results found for "${_controller.text}"',
            style: TextStyle(color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class FoodSearchResultTile extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;

  const FoodSearchResultTile({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Food image or placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: food.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        food.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.fastfood,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.fastfood,
                      color: Theme.of(context).primaryColor,
                    ),
            ),

            const SizedBox(width: 12),

            // Food details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${food.brand} • ${food.category}',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildNutritionChip(
                        context,
                        '${food.calories.toInt()} cal',
                        Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildNutritionChip(
                        context,
                        'P: ${food.protein.toInt()}g',
                        Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      _buildNutritionChip(
                        context,
                        'C: ${food.carbs.toInt()}g',
                        Colors.green,
                      ),
                      const SizedBox(width: 8),
                      _buildNutritionChip(
                        context,
                        'F: ${food.fat.toInt()}g',
                        Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Add button
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionChip(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
