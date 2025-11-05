import 'package:flutter/material.dart';
import 'review_meals_page.dart';

class MealSelectionPage extends StatefulWidget {
  final DateTime selectedDate;

  const MealSelectionPage({
    super.key,
    required this.selectedDate,
  });

  @override
  State<MealSelectionPage> createState() => _MealSelectionPageState();
}

class _MealSelectionPageState extends State<MealSelectionPage> {
  late DateTime _displayedDate;
  int _selectedDateIndex = 1; // Default to center date (Oct 22)
  int _selectedCategoryIndex = 2; // Default to Salads
  final Map<int, int> _mealQuantities = {};
  final int _totalSelectedMeals = 3;

  final List<String> _categories = ['Breakfast', 'Lunch', 'Salads', 'Dinner'];
  final List<int> _categoryCounts = [2, 2, 2, 0];

  final List<Map<String, dynamic>> _meals = [
    {
      'title': 'Grilled Chicken Power Bowl',
      'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
      'calories': '145',
      'protein': '21g',
      'carbs': '21g',
      'fats': '21g',
      'isFavorite': true,
      'image': 'placeholder',
    },
    {
      'title': 'Grilled Chicken Power Bowl',
      'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
      'calories': '145',
      'protein': '21g',
      'carbs': '21g',
      'fats': '21g',
      'isFavorite': false,
      'image': 'placeholder',
      'quantity': 2,
    },
    {
      'title': 'Grilled Chicken Power Bowl',
      'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
      'calories': '145',
      'protein': '21g',
      'carbs': '21g',
      'fats': '21g',
      'isFavorite': false,
      'image': 'placeholder',
    },
    {
      'title': 'Grilled Chicken Power Bowl',
      'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
      'calories': '145',
      'protein': '21g',
      'carbs': '21g',
      'fats': '21g',
      'isFavorite': false,
      'image': 'placeholder',
    },
  ];

  @override
  void initState() {
    super.initState();
    _displayedDate = widget.selectedDate;
    _mealQuantities[1] = 2;
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _getDayOfWeek(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    _formatDate(_displayedDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showPauseDayDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.pause, color: Color(0xFF9E9E9E), size: 16),
                          SizedBox(width: 4),
                          Text(
                            'PAUSE DAY',
                            style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Date Selector
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  // Show dates relative to the original selected date (widget.selectedDate)
                  final date = widget.selectedDate.add(Duration(days: index - 1));
                  final isSelected = index == _selectedDateIndex;
                  
                  String status = 'empty';
                  IconData? statusIcon;
                  if (index == 0) {
                    statusIcon = Icons.check_circle;
                  } else if (index == 2) {
                    statusIcon = Icons.restaurant;
                  } else if (index == 3) {
                    statusIcon = Icons.restaurant;
                  } else if (index == 4) {
                    statusIcon = Icons.restaurant;
                  } else if (index == 5) {
                    statusIcon = Icons.restaurant;
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _displayedDate = date;
                        _selectedDateIndex = index;
                        // Reset meal quantities when changing date
                        _mealQuantities.clear();
                        _mealQuantities[1] = 2; // Show default quantity for demo
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: EdgeInsets.only(right: index == 0 ? 12 : 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.transparent
                            : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: const Color(0xFFFF6B35), width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (statusIcon != null && !isSelected)
                            Icon(
                              statusIcon,
                              color: statusIcon == Icons.check_circle 
                                  ? Colors.green
                                  : statusIcon == Icons.restaurant
                                      ? Colors.red
                                      : const Color(0xFF9E9E9E),
                              size: 20,
                            )
                          else if (isSelected)
                            const Icon(
                              Icons.touch_app,
                              color: Color(0xFFFF6B35),
                              size: 20,
                            )
                          else
                            const SizedBox(height: 20),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getDayOfWeek(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Category Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: List.generate(_categories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _categories[index],
                                style: TextStyle(
                                  color: _selectedCategoryIndex == index
                                      ? Colors.white
                                      : const Color(0xFF9E9E9E),
                                  fontSize: 14,
                                  fontWeight: _selectedCategoryIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              if (_categoryCounts[index] > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${_categoryCounts[index]}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 50,
                            height: 2,
                            decoration: BoxDecoration(
                              color: _selectedCategoryIndex == index
                                  ? const Color(0xFFFF6B35)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Meal List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _meals.length,
                itemBuilder: (context, index) {
                  final meal = _meals[index];
                  final quantity = _mealQuantities[index] ?? 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
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
                              // Calories
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
                              // Nutritional information
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Protein',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 12,
                                    color: Colors.green,
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                  ),
                                  Text(
                                    'Carbs',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 12,
                                    color: Colors.green,
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                  ),
                                  Text(
                                    'Fats',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    meal['protein'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 12,
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                  ),
                                  Text(
                                    meal['carbs'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 12,
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                  ),
                                  Text(
                                    meal['fats'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Right side - Image
                        Column(
                          children: [
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
                                        _meals[index]['isFavorite'] = !(_meals[index]['isFavorite'] ?? false);
                                      });
                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      color: (meal['isFavorite'] ?? false) ? Colors.red : Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Quantity selector or ADD button
                            if (quantity > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFFF6B35)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (quantity > 0) {
                                            _mealQuantities[index] = quantity - 1;
                                          }
                                        });
                                      },
                                      child: const Text(
                                        '-',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _mealQuantities[index] = (quantity ?? 0) + 1;
                                        });
                                      },
                                      child: const Text(
                                        '+',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _mealQuantities[index] = 1;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFFF6B35)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'ADD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'SELECTED ${_categories[_selectedCategoryIndex].toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.shopping_bag,
                  color: Color(0xFFFF6B35),
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '3/$_totalSelectedMeals',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 16),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReviewMealsPage(
                          selectedDate: _displayedDate,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'SAVE MEALS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPauseDayDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                  ),
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Color(0xFFFF6B35),
                        size: 40,
                      ),
                      Positioned(
                        top: 24,
                        child: Icon(
                          Icons.pause,
                          color: Color(0xFFFF6B35),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  'Pause Meals for Today?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Description
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                    children: [
                      const TextSpan(text: 'Put your meal plan on hold for '),
                      TextSpan(
                        text: _formatDate(_displayedDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const TextSpan(text: '. You can unpause it later if you change your mind.'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Pause button
                GestureDetector(
                  onTap: () {
                    // Handle pause action
                    Navigator.of(context).pop();
                    // You can add your pause logic here
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF3A3A3A),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'PAUSE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

