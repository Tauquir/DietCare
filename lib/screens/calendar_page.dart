import 'package:flutter/material.dart';

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

  // Mock data for meal status
  final Map<int, String> _mealStatus = {
    8: 'delivered',
    9: 'delivered',
    10: 'delivered',
    11: 'delivered',
    12: 'delivered',
    13: 'preparing',
    14: 'preparing',
    15: 'preparing',
    16: 'paused',
    17: 'paused',
    18: 'paused',
    19: 'delivered',
    20: 'selected',
    21: 'selected',
    22: 'choose',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '9:41',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
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
                          int dayNumber = index - 6; // Start from day 1
                          
                          if (dayNumber < 1 || dayNumber > 30) {
                            return const SizedBox(); // Empty space
                          }
                          
                          String status = _mealStatus[dayNumber] ?? 'empty';
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = DateTime(_currentYear, 10, dayNumber);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getDayColor(status),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      dayNumber.toString(),
                                      style: TextStyle(
                                        color: _getTextColor(status),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (status != 'empty') ...[
                                      const SizedBox(height: 2),
                                      Icon(
                                        _getStatusIcon(status),
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ],
                                  ],
                                ),
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
                  _buildLegendItem('Choose a Meal', Icons.touch_app, const Color(0xFFFF6B35)),
                  const SizedBox(height: 8),
                  _buildLegendItem('Meal Selected', Icons.check_circle, Colors.white),
                  const SizedBox(height: 8),
                  _buildLegendItem('Paused Meal', Icons.pause, const Color(0xFF9E9E9E)),
                  const SizedBox(height: 8),
                  _buildLegendItem('Preparing Meal', Icons.restaurant, Colors.red),
                  const SizedBox(height: 8),
                  _buildLegendItem('Meal Delivered', Icons.local_shipping, Colors.blue),
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

  Widget _buildLegendItem(String label, IconData icon, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
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
          // Navigate to account page
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

  Color _getDayColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.blue;
      case 'preparing':
        return Colors.red;
      case 'paused':
        return const Color(0xFF9E9E9E);
      case 'selected':
        return Colors.white;
      case 'choose':
        return Colors.white;
      default:
        return const Color(0xFF2A2A2A);
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'selected':
      case 'choose':
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'delivered':
        return Icons.local_shipping;
      case 'preparing':
        return Icons.restaurant;
      case 'paused':
        return Icons.pause;
      case 'selected':
        return Icons.check_circle;
      case 'choose':
        return Icons.touch_app;
      default:
        return Icons.circle;
    }
  }
}
