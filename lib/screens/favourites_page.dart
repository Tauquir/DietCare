import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  // Mock favorite meals data
  final List<Map<String, dynamic>> _favoriteMeals = [
    {
      'title': 'Grilled Chicken Power Bowl',
      'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
      'calories': '145',
      'protein': '21g',
      'carbs': '21g',
      'fats': '21g',
      'isFavorite': true,
    },
    {
      'title': 'Grilled Chicken Power Bowl',
      'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
      'calories': '145',
      'protein': '21g',
      'carbs': '21g',
      'fats': '21g',
      'isFavorite': true,
    },
    {
      'title': 'Grilled Chicken Power Bowl',
      'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
      'calories': '145',
      'protein': '21g',
      'carbs': '21g',
      'fats': '21g',
      'isFavorite': true,
    },
    {
      'title': 'Grilled Chicken Power Bowl',
      'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
      'calories': '145',
      'protein': '21g',
      'carbs': '21g',
      'fats': '21g',
      'isFavorite': true,
    },
    {
      'title': 'Grilled Chicken Power Bowl',
      'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
      'calories': '145',
      'protein': '21g',
      'carbs': '21g',
      'fats': '21g',
      'isFavorite': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favourites',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _favoriteMeals.length,
        itemBuilder: (context, index) {
          final meal = _favoriteMeals[index];
          return _buildMealCard(meal, index);
        },
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meal['description'],
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Color(0xFFFF6B35),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${meal['calories']} kcal',
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Nutritional breakdown
                Row(
                  children: [
                    _buildNutritionLabel('Protein', meal['protein'], Colors.green),
                    Container(
                      width: 1,
                      height: 16,
                      color: const Color(0xFF3A3A3A),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    _buildNutritionLabel('Carbs', meal['carbs'], Colors.orange),
                    Container(
                      width: 1,
                      height: 16,
                      color: const Color(0xFF3A3A3A),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    _buildNutritionLabel('Fats', meal['fats'], Colors.blue),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right side - Image
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Color(0xFF9E9E9E),
                  size: 40,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // Toggle favorite status
                      meal['isFavorite'] = !meal['isFavorite'];
                      if (!meal['isFavorite']) {
                        // Remove from favorites
                        _favoriteMeals.removeAt(index);
                      }
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionLabel(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

