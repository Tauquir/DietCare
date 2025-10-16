import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedDayIndex = 0; // Monday is selected by default
  int _selectedMealCategoryIndex = 0; // Breakfast is selected by default
  
  // Track favorite status for each meal item
  List<bool> _favoriteStatus = [true, false, false, false]; // First item is liked by default
  
  final List<String> _days = [
    'Mon',
    'Tue', 
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  
  final List<String> _mealCategories = [
    'Breakfast',
    'Lunch',
    'Salads',
    'Dinner',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Zen Meal Plan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Weekly Day Indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              border: Border(
                bottom: BorderSide(color: Color(0xFF3A3A3A), width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _days.asMap().entries.map((entry) {
                int index = entry.key;
                String day = entry.value;
                bool isSelected = index == _selectedDayIndex;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Meal Category Navigation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              border: Border(
                bottom: BorderSide(color: Color(0xFF3A3A3A), width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _mealCategories.asMap().entries.map((entry) {
                int index = entry.key;
                String category = entry.value;
                bool isSelected = index == _selectedMealCategoryIndex;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMealCategoryIndex = index;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: category.length * 8.0, // Dynamic width based on text length
                        height: 2,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              
              // Meal Items List
              _buildMealItemCard(
                0, // Index for favorite tracking
                'Grilled Chicken Power Bowl',
                'A wholesome bowl of chicken, veggies, eggs & grains.',
                '145 kcal',
                'Protein 21g',
                'Carbs 21g',
                'Fats 21g',
              ),
              
              const SizedBox(height: 16),
              
              _buildMealItemCard(
                1, // Index for favorite tracking
                'Grilled Chicken Power Bowl',
                'A wholesome bowl of chicken, veggies, eggs & grains.',
                '145 kcal',
                'Protein 21g',
                'Carbs 21g',
                'Fats 21g',
              ),
              
              const SizedBox(height: 16),
              
              _buildMealItemCard(
                2, // Index for favorite tracking
                'Grilled Chicken Power Bowl',
                'A wholesome bowl of chicken, veggies, eggs & grains.',
                '145 kcal',
                'Protein 21g',
                'Carbs 21g',
                'Fats 21g',
              ),
              
              const SizedBox(height: 16),
              
              _buildMealItemCard(
                3, // Index for favorite tracking
                'Grilled Chicken Power Bowl',
                'A wholesome bowl of chicken, veggies, eggs & grains.',
                '145 kcal',
                'Protein 21g',
                'Carbs 21g',
                'Fats 21g',
              ),
              
              const SizedBox(height: 100), // Extra space for fixed button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF6B35),
                Color(0xFFE55A2B),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: ElevatedButton(
            onPressed: () {
              // Handle subscription
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'SUBSCRIBE NOW!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionSummary(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMealCategory(String title, String count, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              count,
              style: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildMealItemCard(int index, String name, String description, String calories, String protein, String carbs, String fats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
                      calories,
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      protein,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      carbs,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      fats,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Food Image
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
                      _favoriteStatus[index] = !_favoriteStatus[index];
                    });
                  },
                  child: Icon(
                    _favoriteStatus[index] ? Icons.favorite : Icons.favorite_border,
                    color: _favoriteStatus[index] ? Colors.red : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
