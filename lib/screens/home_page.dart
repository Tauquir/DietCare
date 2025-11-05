import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'menu_page.dart';
import 'subscription_page.dart';
import 'calendar_page.dart';
import 'account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  int _selectedBottomNavIndex = 0;
  int _currentCardIndex = 1; // Start with center card focused

  final List<String> _categories = [
    'Diet Plans',
    'Healthy',
    'Lifestyle',
    'Gain Muscle',
  ];

  final List<IconData> _categoryIcons = [
    Icons.assignment_outlined,
    Icons.eco_outlined,
    Icons.self_improvement_outlined,
    Icons.fitness_center_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Top Header (Orange Background)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B35),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  // Slogan on the left
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Effortless',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Healthy Eating!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Food collage placeholder on the right
                  Container(
                    width: 120,
                    height: 80,
                    child: Stack(
                      children: [
                        // Placeholder for food images - user will add images later
                        Positioned(
                          right: 40,
                          top: 10,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 25,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 45,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 50,
                          top: 50,
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // "Need help choosing" Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Left side - Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Need help choosing\nthe right meal?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Set goals & design your meal plan!',
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            // Handle navigation
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Let\'s Go',
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
                  ),
                  const SizedBox(width: 16),
                  // Right side - Professional image placeholder
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.medical_services,
                      color: Color(0xFF9E9E9E),
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Navigation
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
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
                                    children: [
                                      Icon(
                                        _categoryIcons[index],
                                        color: _selectedCategoryIndex == index
                                            ? const Color(0xFFFF6B35)
                                            : const Color(0xFF9E9E9E),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _categories[index],
                                        style: TextStyle(
                                          color: _selectedCategoryIndex == index
                                              ? const Color(0xFFFF6B35)
                                              : const Color(0xFF9E9E9E),
                                          fontSize: 14,
                                          fontWeight: _selectedCategoryIndex == index
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 25,
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
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                     // Meal Plan Cards
                     SizedBox(
                       height: 380,
                       child: ListView.builder(
                         scrollDirection: Axis.horizontal,
                         itemCount: 3,
                         itemBuilder: (context, index) {
                           // All cards same size
                           final cardWidth = 280;
                           final cardHeight = 350;
                           final imageHeight = 120;
                           final borderRadius = 12.0;
                           
                           return GestureDetector(
                             onTap: () {
                               setState(() {
                                 _currentCardIndex = index;
                               });
                             },
                             child: Container(
                               width: cardWidth.toDouble(),
                               margin: const EdgeInsets.only(right: 8),
                               decoration: BoxDecoration(
                                 color: const Color(0xFF2A2A2A),
                                 borderRadius: BorderRadius.circular(borderRadius),
                               ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Card Image (Empty placeholder)
                                Container(
                                  width: double.infinity,
                                  height: imageHeight.toDouble(),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3A3A3A),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(borderRadius),
                                      topRight: Radius.circular(borderRadius),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Empty image placeholder
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: const Color(0xFF4A4A4A),
                                      ),
                                      // Title overlay
                                      Positioned(
                                        bottom: 10,
                                        left: 14,
                                        right: 14,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Zen Meal Plan',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
                                              'For steady, visible progress.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 6),
                                      // Nutritional Information with vertical dividers
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          _buildNutritionItem('Protein', '21g'),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color: const Color(0xFF9E9E9E),
                                            margin: const EdgeInsets.symmetric(horizontal: 8),
                                          ),
                                          _buildNutritionItem('Carbs', '60g'),
                                          Container(
                                            width: 1,
                                            height: 20,
                                            color: const Color(0xFF9E9E9E),
                                            margin: const EdgeInsets.symmetric(horizontal: 8),
                                          ),
                                          _buildNutritionItem('Fat', '15g'),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6, 
                                              vertical: 2
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3A3A3A),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'Kcal 1000',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      // Includes Section
                                      const Text(
                                        'INCLUDES',
                                        style: TextStyle(
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => const MenuPage(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'VIEW MENU >',
                                          style: TextStyle(
                                            color: Color(0xFFFF6B35),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Meal Components
                                      _buildMealComponent('1 Breakfast'),
                                      _buildMealComponent('2 Main Course'),
                                      _buildMealComponent('1 Soup & Snack'),
                                      _buildMealComponent('1 Salad & Drink'),
                                      const SizedBox(height: 16),
                                      // Pricing and Subscribe Button
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'STARTING FROM',
                                                style: TextStyle(
                                                  color: Color(0xFF9E9E9E),
                                                  fontSize: 8,
                                                ),
                                              ),
                                              Text(
                                                'KD 20.000',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => const SubscriptionPage(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 14, 
                                                vertical: 6
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFF6B35),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                'SUBSCRIBE',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
           // Bottom Navigation Bar
           Container(
             height: 70,
             decoration: const BoxDecoration(
               color: Color(0xFF1A1A1A),
               border: Border(
                 top: BorderSide(color: Color(0xFF3A3A3A), width: 0.5),
               ),
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 _buildBottomNavItem(Icons.assignment_outlined, 'PLANS', 0),
                 _buildBottomNavItem(Icons.calendar_today_outlined, 'CALENDAR', 1),
                 _buildBottomNavItem(Icons.person_outline, 'ACCOUNT', 2),
               ],
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMealComponent(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          const Icon(
            Icons.check,
            color: Colors.green,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedBottomNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBottomNavIndex = index;
        });
        
        // Navigate to appropriate page
        if (label == 'CALENDAR') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CalendarPage(),
            ),
          );
        } else if (label == 'ACCOUNT') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AccountPage(),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF9E9E9E),
            size: 20,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF9E9E9E),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
