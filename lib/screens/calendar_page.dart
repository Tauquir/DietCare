import 'package:flutter/material.dart';
import 'meal_selection_page.dart';
import 'account_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  String _currentMonth = 'October';
  int _currentYear = 2025;

  final List<String> _weekDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  // Mock data for meal status - matching the image
  final Map<int, String> _mealStatus = {
    8: 'selected',
    9: 'selected',
    10: 'selected',
    11: 'selected',
    12: 'selected',
    13: 'preparing',
    14: 'preparing',
    15: 'preparing',
    16: 'paused',
    17: 'paused',
    18: 'paused',
    19: 'selected',
    20: 'delivered',
    21: 'delivered',
    22: 'choose',
  };

  // Get the day of week for the first day of the month (0=Sunday, 6=Saturday)
  int _getFirstDayOfWeek() {
    DateTime firstDay = DateTime(_currentYear, 10, 1);
    // October 1, 2025 is a Wednesday (day 3)
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Orange Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B35),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - CALENDAR label and month/year
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CALENDAR',
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '$_currentMonth, $_currentYear',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Right side - 3D calendar icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Text(
                            '15',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Calendar Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Week Days Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: _weekDays.map((day) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    // Calendar Days Grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: 35, // 5 weeks * 7 days
                        itemBuilder: (context, index) {
                          int firstDayOfWeek = _getFirstDayOfWeek();
                          int dayNumber = index - firstDayOfWeek + 1;
                          
                          // Check if this is an empty cell (before day 1 or after day 30)
                          if (dayNumber < 1 || dayNumber > 30) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          }
                          
                          String status = _mealStatus[dayNumber] ?? 'empty';
                          
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MealSelectionPage(
                                    selectedDate: DateTime(_currentYear, 10, dayNumber),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: status == 'empty' 
                                    ? Colors.transparent
                                    : const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: status == 'empty' 
                                      ? const Color(0xFF3A3A3A)
                                      : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (status != 'empty')
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: _buildMealStatusIcon(status),
                                    )
                                  else
                                    const SizedBox(height: 20),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          dayNumber.toString(),
                                          style: TextStyle(
                                            color: status == 'empty' 
                                                ? const Color(0xFF9E9E9E)
                                                : Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Legend Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Understand Your Meal Days!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B35),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Track your meal progress from selection to delivery with these icons.',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 12,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Legend Items
                  _buildLegendItem('Choose a Meal', _buildMealStatusIcon('choose')),
                  const SizedBox(height: 8),
                  _buildLegendItem('Meal Selected', _buildMealStatusIcon('selected')),
                  const SizedBox(height: 8),
                  _buildLegendItem('Paused Meal', _buildMealStatusIcon('paused')),
                  const SizedBox(height: 8),
                  _buildLegendItem('Preparing Meal', _buildMealStatusIcon('preparing')),
                  const SizedBox(height: 8),
                  _buildLegendItem('Meal Delivered', _buildMealStatusIcon('delivered')),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          border: Border(
            top: BorderSide(color: Color(0xFF3A3A3A), width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(Icons.assignment_outlined, 'PLANS', false),
            _buildBottomNavItem(Icons.calendar_today, 'CALENDAR', true),
            _buildBottomNavItem(Icons.person_outline, 'ACCOUNT', false),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Widget iconWidget) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: iconWidget,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (label == 'PLANS') {
          Navigator.of(context).pushReplacementNamed('/');
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
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF9E9E9E),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealStatusIcon(String status) {
    switch (status) {
      case 'selected':
        // Meal bag with green checkmark
        return Stack(
          children: [
            const Icon(
              Icons.shopping_bag,
              color: Color(0xFF9E9E9E),
              size: 20,
            ),
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 6,
                ),
              ),
            ),
          ],
        );
      case 'preparing':
        // Red cloche with heat waves
        return const Icon(
          Icons.restaurant,
          color: Colors.red,
          size: 20,
        );
      case 'paused':
        // Gray pause icon
        return const Icon(
          Icons.pause,
          color: Color(0xFF9E9E9E),
          size: 20,
        );
      case 'delivered':
        // White cloche with green checkmark
        return Stack(
          children: [
            const Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 20,
            ),
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 6,
                ),
              ),
            ),
          ],
        );
      case 'choose':
        // Orange hand tapping icon
        return const Icon(
          Icons.touch_app,
          color: Color(0xFFFF6B35),
          size: 20,
        );
      default:
        return const SizedBox();
    }
  }
}
