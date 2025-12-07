import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'meal_selection_page.dart';
import '../services/language_service.dart';
import '../services/subscription_service.dart';
import '../services/auth_storage_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  CalendarPageState createState() => _CalendarPageState();
}

abstract class CalendarPageState extends State<CalendarPage> {
  void reloadCalendarData();
}

class _CalendarPageState extends CalendarPageState {
  final LanguageService _languageService = LanguageService();
  DateTime _currentDate = DateTime.now(); // Start with current date
  bool _isLoading = false;
  Map<String, String> _mealStatus = {}; // Will be populated from API
  int? _activeMealPlanId; // Store active meal plan ID

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
    _loadCalendarData();
  }

  // Public method to reload calendar data when page becomes visible
  @override
  void reloadCalendarData() {
    _loadCalendarData();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  // Get start and end dates of the current month
  String _getMonthStartDate() {
    final firstDay = DateTime(_currentDate.year, _currentDate.month, 1);
    return '${firstDay.year}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}';
  }

  String _getMonthEndDate() {
    final lastDay = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    return '${lastDay.year}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}';
  }

  // Load calendar data from API
  Future<void> _loadCalendarData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthStorageService.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
          _mealStatus = {}; // Clear status if not logged in
        });
        return;
      }

      // Get user's active subscriptions
      final subscriptionsResponse = await SubscriptionService.getMySubscriptions(token: token);
      
      if (subscriptionsResponse['success'] == true && subscriptionsResponse['data'] != null) {
        final subscriptions = subscriptionsResponse['data']['subscriptions'] as List<dynamic>?;
        
        if (subscriptions != null && subscriptions.isNotEmpty) {
          // Get the first active subscription
          final activeSubscription = subscriptions.firstWhere(
            (sub) => (sub as Map<String, dynamic>)['status'] == 'active' || 
                     (sub as Map<String, dynamic>)['status'] == 'pending',
            orElse: () => subscriptions.first,
          ) as Map<String, dynamic>;
          
          final subscriptionId = activeSubscription['id']?.toString();
          final mealPlanId = activeSubscription['mealPlanId'] as int?;
          
          if (subscriptionId != null && mealPlanId != null) {
            // Store meal plan ID for navigation
            setState(() {
              _activeMealPlanId = mealPlanId;
            });
            
            // Get start and end dates of current month
            final startDate = _getMonthStartDate();
            final endDate = _getMonthEndDate();
            
            // Fetch daily selection status
            final response = await SubscriptionService.getDailySelectionStatus(
              subscriptionId: subscriptionId,
              mealPlanId: mealPlanId,
              startDate: startDate,
              endDate: endDate,
              token: token,
            );

            if (response['success'] == true && response['data'] != null) {
              final data = response['data'] as Map<String, dynamic>;
              final statusList = data['status'] as List<dynamic>?;
              
              // Map API response to meal status
              final Map<String, String> newStatusMap = {};
              
              if (statusList != null) {
                for (var statusItem in statusList) {
                  final status = statusItem as Map<String, dynamic>;
                  final date = status['date']?.toString();
                  
                  if (date != null) {
                    final isDelivered = status['is_delivered'] == 1 || status['is_delivered'] == true;
                    final isPaused = status['is_paused'] == 1 || status['is_paused'] == true;
                    final isSelected = status['is_selected'] == 1 || status['is_selected'] == true;
                    final isEditable = status['is_editable'] == 1 || status['is_editable'] == true;
                    
                    // Determine status based on flags
                    String mealStatus;
                    if (isDelivered) {
                      mealStatus = 'delivered';
                    } else if (isPaused) {
                      mealStatus = 'paused';
                    } else if (isSelected && !isEditable) {
                      // Selected but not editable means it's being prepared
                      mealStatus = 'preparing';
                    } else if (isSelected) {
                      mealStatus = 'selected';
                    } else {
                      mealStatus = 'choose';
                    }
                    
                    newStatusMap[date] = mealStatus;
                  }
                }
              }
              
              setState(() {
                _mealStatus = newStatusMap;
                _isLoading = false;
              });
            } else {
              setState(() {
                _isLoading = false;
                _mealStatus = {};
              });
            }
          } else {
            setState(() {
              _isLoading = false;
              _mealStatus = {};
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            _mealStatus = {};
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _mealStatus = {};
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _mealStatus = {};
      });
      print('Error loading calendar data: $e');
    }
  }

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
      // Reload calendar data for the new month
      _loadCalendarData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: Column(
        children: [
          // Orange Header - extends to top
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 12,
              left: 16,
              right: 20,
            ),
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
                        style: GoogleFonts.onest(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 27.07 / 14, // line-height: 27.07px / font-size: 14px
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: _showMonthYearPicker,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 174,
                                maxWidth: 250,
                              ),
                              child: SizedBox(
                                height: 28,
                                child: Text(
                              _getMonthYear(),
                                  style: GoogleFonts.onest(
                                color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                    height: 27.07 / 25, // line-height: 27.07px / font-size: 25px
                                    letterSpacing: 0,
                                  ),
                                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 30,
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
              child: Column(
                children: [
                  // Week Days Header - Full Screen Width
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 12.0,
                      bottom: 4.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B1B1B),
                    ),
                    child: Row(
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      children: _weekDays.map((day) {
                        return Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: 40,
                                height: 24,
                            child: Text(
                                  day.toUpperCase(),
                                  style: GoogleFonts.onest(
                                color: Colors.white,
                                fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 23.58 / 12, // line-height: 23.58px / font-size: 12px
                                    letterSpacing: 0,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  textHeightBehavior: const TextHeightBehavior(
                                    applyHeightToFirstAscent: false,
                                    applyHeightToLastDescent: false,
                                  ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Calendar Days Grid - no spacing between weekday header and grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 4.0,
                        bottom: 0.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 46 / 52, // width: 46, height: 52
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
                                    mealPlanId: _activeMealPlanId,
                                    mealStatusMap: _mealStatus, // Pass the status map
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 46,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF7A7A7A),
                                  width: 0.94,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Icon in center (if not empty)
                                  if (status != 'empty')
                                    Center(
                                      child: _buildMealStatusIcon(status),
                                    ),
                                  // Day number positioned at bottom right
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                      child: Text(
                                        dayNumber.toString(),
                                      style: GoogleFonts.onest(
                                        color: const Color(0xFF7A7A7A).withOpacity(0.5),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        height: 23.58 / 10, // line-height: 23.58px / font-size: 10px
                                        letterSpacing: 0,
                                      ),
                                      textAlign: TextAlign.right,
                                      textHeightBehavior: const TextHeightBehavior(
                                        applyHeightToFirstAscent: false,
                                        applyHeightToLastDescent: false,
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
                  ),
                ],
              ),
            ),
            
            // Legend Section
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
              width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
              decoration: const BoxDecoration(
                  color: Color(0xFF1B1B1B),
                ),
              child: Stack(
                children: [
                  // Background SVG with gradient
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 402,
                        height: 292.70623779296875,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF2B2A2A),
                              Color.fromRGBO(27, 27, 27, 0),
                            ],
                          ),
              ),
                        child: SvgPicture.asset(
                          'assets/svg/Rectanglecal.svg',
                          width: 402,
                          height: 292.70623779296875,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Content on top
                  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                mainAxisSize: MainAxisSize.min,
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
                  
                  const SizedBox(height: 8),
                  
                  // Legend Items - 2 column grid layout
                  Row(
                    textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                  _buildLegendItem(_getText('chooseMeal'), _buildMealStatusIcon('choose')),
                  const SizedBox(height: 12),
                            _buildLegendItem(_getText('pausedMeal'), _buildMealStatusIcon('paused')),
                            const SizedBox(height: 12),
                            _buildLegendItem(_getText('mealDelivered'), _buildLegendDeliveredIcon()),
                          ],
                        ),
                      ),
                      // Vertical separator
                      Container(
                        width: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: const Color(0xFF595959),
                      ),
                      // Right Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: _isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                  _buildLegendItem(_getText('mealSelected'), _buildLegendSelectedIcon()),
                  const SizedBox(height: 12),
                  _buildLegendItem(_getText('preparingMeal'), _buildMealStatusIcon('preparing')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                  ),
                ],
              ),
              ),
            ),
          ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Widget iconWidget) {
    return Row(
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF595959),
              width: 1.26,
            ),
          ),
          child: Center(
            child: SizedBox(
          width: 24,
          height: 24,
          child: iconWidget,
            ),
          ),
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
    // Meal selected icon using meal.svg
    return Center(
      child: SvgPicture.asset(
        'assets/svg/meal.svg',
        width: 24,
        height: 24,
        fit: BoxFit.contain,
        alignment: Alignment.center,
            ),
    );
  }

  Widget _buildLegendDeliveredIcon() {
    // Meal delivered icon using mealdel.svg
    return Center(
      child: SvgPicture.asset(
        'assets/svg/mealdel.svg',
        width: 24,
        height: 24,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      ),
    );
  }


  Widget _buildMealStatusIcon(String status) {
    switch (status) {
      case 'selected':
        // Meal selected icon using meal.svg
        return Center(
          child: SvgPicture.asset(
            'assets/svg/meal.svg',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            alignment: Alignment.center,
                ),
        );
      case 'preparing':
        // Preparing meal icon using preparing.svg
        return Center(
          child: SvgPicture.asset(
            'assets/svg/preparing.svg',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            alignment: Alignment.center,
                ),
        );
      case 'paused':
        // Pause meal icon using pause.svg
        return Center(
          child: SvgPicture.asset(
            'assets/svg/pause.svg',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        );
      case 'delivered':
        // Meal delivered icon using mealdel.svg
        return Center(
          child: SvgPicture.asset(
            'assets/svg/mealdel.svg',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        );
      case 'choose':
        // Orange hand tapping icon - using choose.svg
        return Center(
          child: SvgPicture.asset(
            'assets/svg/choose.svg',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
