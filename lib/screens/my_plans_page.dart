import 'package:flutter/material.dart';
import '../services/language_service.dart';

class MyPlansPage extends StatefulWidget {
  const MyPlansPage({super.key});

  @override
  State<MyPlansPage> createState() => _MyPlansPageState();
}

class _MyPlansPageState extends State<MyPlansPage> {
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'myPlans': 'My Plans',
      'zenMealPlan': 'Zen Meal Plan',
      'upcomingMeals': 'Upcoming Meals',
      'previousPlans': 'Past Plans',
      'days': 'DAYS',
      'day': 'day',
    },
    'Arabic': {
      'myPlans': 'خططي',
      'zenMealPlan': 'خطة وجبات زن',
      'upcomingMeals': 'الوجبات الجاية',
      'previousPlans': 'الخطط السابقة',
      'days': 'يوم',
      'day': 'يوم',
    },
  };

  String _getText(String key) {
    return _translations[_languageService.currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  bool get _isRTL => _languageService.isRTL;

  final List<String> _weekDaysEn = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  final List<String> _weekDaysAr = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];

  List<String> get _weekDays => _isRTL ? _weekDaysAr : _weekDaysEn;

  String _formatDateRange(String startDate, String endDate) {
    if (_isRTL) {
      return '$startDate إلى $endDate';
    } else {
      return '$startDate to $endDate';
    }
  }

  String _formatDate(DateTime date) {
    if (_isRTL) {
      final monthsAr = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      return '${date.day} ${monthsAr[date.month - 1]}, ${date.year}';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  String _formatDateShort(DateTime date) {
    if (_isRTL) {
      final monthsAr = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      return '${date.day} ${monthsAr[date.month - 1]}, ${date.year}';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  IconButton(
                    icon: Icon(
                      _isRTL ? Icons.arrow_forward : Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    _getText('myPlans'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Plan Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              // Image (first in RTL to appear on right, last in LTR to appear on right)
                              if (!_isRTL) ...[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    textDirection: TextDirection.ltr,
                                    children: [
                                      Text(
                                        _getText('zenMealPlan'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDateRange(
                                          _formatDateShort(DateTime(2025, 9, 24)),
                                          _formatDateShort(DateTime(2025, 10, 31)),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                              Container(
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3A3A3A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  color: Color(0xFF9E9E9E),
                                  size: 40,
                                ),
                              ),
                              if (_isRTL) ...[
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Text(
                                        _getText('zenMealPlan'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDateRange(
                                          _formatDateShort(DateTime(2025, 9, 24)),
                                          _formatDateShort(DateTime(2025, 10, 31)),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          // Progress indicator positioned at bottom left (right in RTL)
                          Positioned(
                            bottom: 0,
                            left: _isRTL ? null : 0,
                            right: _isRTL ? 0 : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '30/24 ${_getText('day')}',
                                style: const TextStyle(
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
                    const SizedBox(height: 32),

                    // Upcoming Meals Section
                    Text(
                      _getText('upcomingMeals'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        reverse: _isRTL,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          // Days 18, 17, 16 (paused), 15, 14, 13 (meals)
                          // Weekdays: Wed, Thu, Fri, Sat, Sun, Mon
                          final dayNumbers = [18, 17, 16, 15, 14, 13];
                          final weekdayIndices = [3, 4, 5, 6, 0, 1]; // Wed, Thu, Fri, Sat, Sun, Mon
                          final dayNumber = dayNumbers[index];
                          final isPaused = index < 3; // Days 18, 17, 16 are paused
                          final weekdayIndex = weekdayIndices[index];

                          return Container(
                            width: 80,
                            margin: EdgeInsets.only(
                              right: _isRTL ? 0 : 12,
                              left: _isRTL ? 12 : 0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isPaused ? Icons.pause : Icons.soup_kitchen,
                                  color: isPaused ? Colors.white : Colors.red,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$dayNumber',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _weekDays[weekdayIndex],
                                  style: const TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Past Plans Section
                    Text(
                      _getText('previousPlans'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                    const SizedBox(height: 16),
                    _buildPastPlanCard(
                      _getText('zenMealPlan'),
                      _formatDateRange(
                        _formatDate(DateTime(2025, 9, 24)),
                        _formatDate(DateTime(2025, 10, 25)),
                      ),
                      '26 ${_getText('day')}',
                    ),
                    const SizedBox(height: 12),
                    _buildPastPlanCard(
                      _getText('zenMealPlan'),
                      _formatDateRange(
                        _formatDate(DateTime(2025, 9, 24)),
                        _formatDate(DateTime(2025, 10, 25)),
                      ),
                      '26 ${_getText('day')}',
                    ),
                    const SizedBox(height: 12),
                    _buildPastPlanCard(
                      _getText('zenMealPlan'),
                      _formatDateRange(
                        _formatDate(DateTime(2025, 9, 24)),
                        _formatDate(DateTime(2025, 10, 25)),
                      ),
                      '26 ${_getText('day')}',
                    ),
                    const SizedBox(height: 12),
                    _buildPastPlanCard(
                      _getText('zenMealPlan'),
                      _formatDateRange(
                        _formatDate(DateTime(2025, 9, 24)),
                        _formatDate(DateTime(2025, 10, 25)),
                      ),
                      '26 ${_getText('day')}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastPlanCard(String title, String dateRange, String duration) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Jagged tab on left (right in RTL)
          Container(
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF8B4513),
              borderRadius: _isRTL
                  ? const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
            ),
            child: Center(
              child: RotatedBox(
                quarterTurns: _isRTL ? 0 : 0,
                child: Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateRange,
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

