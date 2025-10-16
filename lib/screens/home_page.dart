import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'menu_page.dart';
import 'subscription_page.dart';
import 'calendar_page.dart';

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
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B35),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Slogan
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Effortless',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Healthy Eating!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Background meal images (empty placeholders)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image Card (Empty placeholder)
                    Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: const Color(0xFF3A3A3A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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
                                        size: 16,
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
                    const SizedBox(height: 24),
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
                                      // Nutritional Information
                                      Row(
                                        children: [
                                          _buildNutritionItem('Protein', '21g'),
                                          const SizedBox(width: 10),
                                          _buildNutritionItem('Carbs', '60g'),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          _buildNutritionItem('Fat', '15g'),
                                          const SizedBox(width: 10),
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
                                      const SizedBox(height: 6),
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
            color: Color(0xFF9E9E9E),
            fontSize: 8,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
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
            color: Color(0xFFFF6B35),
            size: 12,
          ),
          const SizedBox(width: 8),
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
          // Navigate to account page when implemented
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
