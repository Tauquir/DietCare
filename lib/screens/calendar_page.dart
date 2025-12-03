import 'package:flutter/material.dart';
import 'meal_selection_page.dart';
import 'account_page.dart';
import 'home_page.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../services/language_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final LanguageService _languageService = LanguageService();
  DateTime _currentDate = DateTime(2025, 10, 15); // Start with October 2025

  final List<String> _weekDaysEn = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  final List<String> _weekDaysAr = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
  
  final List<String> _monthNamesEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  
  final List<String> _monthNamesAr = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'calendar': 'CALENDAR',
      'understandMealDays': 'Understand Your Meal Days!',
      'trackMealProgress': 'Track your meal progress from selection to delivery with these icons.',
      'chooseMeal': 'Choose a Meal',
      'mealSelected': 'Meal Selected',
      'pausedMeal': 'Paused Meal',
      'preparingMeal': 'Preparing Meal',
      'mealDelivered': 'Meal Delivered',
    },
    'Arabic': {
      'calendar': 'التقويم',
      'understandMealDays': 'افهم أيام وجباتك!',
      'trackMealProgress': 'تابع تقدم وجباتك من الاختيار إلى التوصيل بهذه الأيقونات',
      'chooseMeal': 'اختار وجبة',
      'mealSelected': 'وجبة مختارة',
      'pausedMeal': 'الوجبة موقفة مؤقتًا',
      'preparingMeal': 'جاري تجهيز الوجبة',
      'mealDelivered': 'الوجبة تم توصيلها',
    },
  };

  String _getText(String key) {
    return _translations[_languageService.currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  bool get _isRTL => _languageService.isRTL;

  List<String> get _weekDays => _isRTL ? _weekDaysAr : _weekDaysEn;
  List<String> get _monthNames => _isRTL ? _monthNamesAr : _monthNamesEn;

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  // Mock data for meal status - keyed by full date (year-month-day) with zero-padding
  final Map<String, String> _mealStatus = {
    '2025-10-08': 'selected',
    '2025-10-09': 'selected',
    '2025-10-10': 'selected',
    '2025-10-11': 'selected',
    '2025-10-12': 'selected',
    '2025-10-13': 'preparing',
    '2025-10-14': 'preparing',
    '2025-10-15': 'preparing',
    '2025-10-16': 'paused',
    '2025-10-17': 'paused',
    '2025-10-18': 'paused',
    '2025-10-19': 'delivered',
    '2025-10-20': 'delivered',
    '2025-10-21': 'delivered',
    '2025-10-22': 'choose',
  };

  // Get the day of week for the first day of the month (0=Sunday, 6=Saturday)
  int _getFirstDayOfWeek() {
    DateTime firstDay = DateTime(_currentDate.year, _currentDate.month, 1);
    // DateTime.weekday: Monday=1, Tuesday=2, ..., Sunday=7
    // We need: Sunday=0, Monday=1, ..., Saturday=6
    return firstDay.weekday == 7 ? 0 : firstDay.weekday;
  }

  // Get number of days in the current month
  int _getDaysInMonth() {
    DateTime firstDay = DateTime(_currentDate.year, _currentDate.month, 1);
    DateTime lastDay = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    return lastDay.day;
  }

  // Get month name
  String _getMonthName() {
    return _monthNames[_currentDate.month - 1];
  }
  
  // Get formatted month and year
  String _getMonthYear() {
    if (_isRTL) {
      return '${_getMonthName()}, ${_currentDate.year}';
    }
    return '${_getMonthName()}, ${_currentDate.year}';
  }

  // Get current day for calendar icon
  int _getCurrentDay() {
    return _currentDate.day;
  }

  // Show month/year picker
  Future<void> _showMonthYearPicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF6B35),
              onPrimary: Colors.white,
              surface: Color(0xFF2A2A2A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _currentDate = DateTime(picked.year, picked.month, _currentDate.day);
        // Ensure day doesn't exceed days in month
        int daysInMonth = DateTime(picked.year, picked.month + 1, 0).day;
        if (_currentDate.day > daysInMonth) {
          _currentDate = DateTime(picked.year, picked.month, daysInMonth);
        }
      });
    }
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
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  // Calendar label and month/year (left in LTR, right in RTL)
                  Column(
                    crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getText('calendar'),
                        style: const TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: _showMonthYearPicker,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Text(
                              _getMonthYear(),
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
                      ),
                    ],
                  ),
                  // 3D calendar icon (right in LTR, left in RTL)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
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
                        // White body
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${_getCurrentDay()}',
                              style: const TextStyle(
                                color: Color(0xFF3A3A3A),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Light blue top (3D effect)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 18,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF81D4FA),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        // Green checkmark
                        Positioned(
                          top: 2,
                          right: 2,
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2A2A2A),
                      ),
                      child: Row(
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: _weekDays.map((day) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  color: Colors.white,
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
                        itemCount: 42, // 6 weeks * 7 days to handle all months
                        itemBuilder: (context, index) {
                          int firstDayOfWeek = _getFirstDayOfWeek();
                          int dayNumber = index - firstDayOfWeek + 1;
                          int daysInMonth = _getDaysInMonth();
                          
                          // Check if this is an empty cell (before day 1 or after last day of month)
                          if (dayNumber < 1 || dayNumber > daysInMonth) {
                            return const SizedBox.shrink();
                          }
                          
                          // Create date key for meal status lookup (format: YYYY-MM-DD)
                          String dateKey = '${_currentDate.year}-${_currentDate.month.toString().padLeft(2, '0')}-${dayNumber.toString().padLeft(2, '0')}';
                          String status = _mealStatus[dateKey] ?? 'empty';
                          
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MealSelectionPage(
                                    selectedDate: DateTime(_currentDate.year, _currentDate.month, dayNumber),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF3A3A3A),
                                  width: 1,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Icon in center (if not empty)
                                  if (status != 'empty')
                                    Center(
                                      child: _buildMealStatusIcon(status),
                                    ),
                                  // Day number at bottom (right in LTR, left in RTL)
                                  Positioned(
                                    bottom: 4,
                                    right: _isRTL ? null : 4,
                                    left: _isRTL ? 4 : null,
                                    child: Text(
                                      dayNumber.toString(),
                                      style: const TextStyle(
                                        color: Color(0xFF9E9E9E),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
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
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Row(
                    textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Expanded(
                        child: Text(
                          _getText('understandMealDays'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B35),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'i',
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
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Expanded(
                        child: Text(
                          _getText('trackMealProgress'),
                          style: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Legend Items - Order matches the image: selected, choose, preparing, paused, delivered
                  _buildLegendItem(_getText('mealSelected'), _buildLegendSelectedIcon()),
                  const SizedBox(height: 12),
                  _buildLegendItem(_getText('chooseMeal'), _buildMealStatusIcon('choose')),
                  const SizedBox(height: 12),
                  _buildLegendItem(_getText('preparingMeal'), _buildMealStatusIcon('preparing')),
                  const SizedBox(height: 12),
                  _buildLegendItem(_getText('pausedMeal'), _buildMealStatusIcon('paused')),
                  const SizedBox(height: 12),
                  _buildLegendItem(_getText('mealDelivered'), _buildLegendDeliveredIcon()),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        initialIndex: 1,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AccountPage(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLegendItem(String label, Widget iconWidget) {
    return Row(
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: iconWidget,
        ),
        const SizedBox(width: 12),
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

  Widget _buildLegendSelectedIcon() {
    // Grey cloche with green checkmark (matches calendar icon)
    return Stack(
      children: [
        const Icon(
          Icons.restaurant_menu,
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
  }

  Widget _buildLegendDeliveredIcon() {
    // Blue square with white checkmark (as shown in legend)
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Color(0xFF2196F3),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 14,
      ),
    );
  }


  Widget _buildMealStatusIcon(String status) {
    switch (status) {
      case 'selected':
        // Grey cloche (restaurant menu) with green checkmark
        return Stack(
          children: [
            const Icon(
              Icons.restaurant_menu,
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
        // Red steaming bowl icon
        return const Icon(
          Icons.soup_kitchen,
          color: Colors.red,
          size: 24,
        );
      case 'paused':
        // White pause icon (two vertical bars)
        return const Icon(
          Icons.pause,
          color: Colors.white,
          size: 20,
        );
      case 'delivered':
        // White cloche (food cover) with green checkmark
        return Stack(
          children: [
            const Icon(
              Icons.restaurant_menu,
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
