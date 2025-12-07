import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/language_service.dart';
import '../widgets/pause_day_bottom_sheet.dart';
import 'meal_selection_page.dart';

class ConfirmedMealsPage extends StatefulWidget {
  final DateTime selectedDate;

  const ConfirmedMealsPage({
    super.key,
    required this.selectedDate,
  });

  @override
  State<ConfirmedMealsPage> createState() => _ConfirmedMealsPageState();
}

class _ConfirmedMealsPageState extends State<ConfirmedMealsPage> {
  final LanguageService _languageService = LanguageService();
  late DateTime _displayedDate;
  int _selectedDateIndex = 1; // Default to center date (Oct 22)

  final List<String> _weekDaysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _weekDaysAr = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];

  List<String> get _weekDays => _isRTL ? _weekDaysAr : _weekDaysEn;

  bool get _isRTL => _languageService.isRTL;

  // Check if the selected date has meals in preparing status
  bool get _isPreparing {
    // Check if the date index is 2 or 3 (Oct 23 or Oct 24) - these have preparing status
    return _selectedDateIndex == 2 || _selectedDateIndex == 3;
  }

  List<Map<String, dynamic>> get _selectedMeals {
    if (_isRTL) {
      return [
        {
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'quantity': 2,
          'category': 'meals',
        },
        {
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'quantity': 2,
          'category': 'meals',
        },
      ];
    } else {
      return [
        {
          'title': 'Grilled Chicken Power Bowl',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'quantity': 2,
          'category': 'meals',
        },
        {
          'title': 'Grilled Chicken Power Bowl',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'quantity': 2,
          'category': 'meals',
        },
      ];
    }
  }

  List<Map<String, dynamic>> get _selectedSalads => [];

  List<Map<String, dynamic>> get _selectedSalads2 {
    if (_isRTL) {
      return [
        {
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'quantity': 2,
        },
      ];
    } else {
      return [
        {
          'title': 'Grilled Chicken Power Bowl',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'quantity': 2,
        },
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _displayedDate = widget.selectedDate;
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

  String _formatDate(DateTime date) {
    if (_isRTL) {
      final monthsAr = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      return '${monthsAr[date.month - 1]} ${date.day}';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  String _getDayOfWeek(DateTime date) {
    return _weekDays[date.weekday - 1];
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
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  IconButton(
                    icon: Icon(
                      _isRTL ? Icons.arrow_forward : Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _formatDate(_displayedDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),

            // Date Selector
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  final date = widget.selectedDate.add(Duration(days: index - 1));
                  final isSelected = index == _selectedDateIndex;

                  Widget? statusIcon;
                  if (index == 0) {
                    // Delivered - green checkmark
                    statusIcon = SvgPicture.asset(
                      'assets/svg/mealdel.svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    );
                  } else if (index == 1) {
                    // Selected - orange hand (will be shown when selected)
                    statusIcon = null;
                  } else if (index >= 2 && index <= 3) {
                    // Preparing - red hot plate
                    statusIcon = SvgPicture.asset(
                      'assets/svg/preparing.svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    );
                  } else if (index == 4) {
                    // Delivered - green checkmark
                    statusIcon = SvgPicture.asset(
                      'assets/svg/mealdel.svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _displayedDate = date;
                        _selectedDateIndex = index;
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: EdgeInsets.only(
                        right: _isRTL ? (index == 4 ? 12 : 8) : (index == 0 ? 12 : 8),
                        left: _isRTL ? (index == 0 ? 12 : 8) : 0,
                      ),
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
                            statusIcon!
                          else if (isSelected && (index == 2 || index == 3))
                            // Show preparing icon when selected date is in preparing status
                            SvgPicture.asset(
                              'assets/svg/preparing.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            )
                          else if (isSelected)
                            SvgPicture.asset(
                              'assets/svg/choose.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            )
                          else
                            const SizedBox(height: 24),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day} ${_getDayOfWeek(date)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Preparation Banner (shown when preparing)
                    if (_isPreparing) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFF6B35).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/preparing.svg',
                              width: 32,
                              height: 32,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _isRTL
                                    ? 'وجباتك قيد التحضير الآن. لا يمكن إجراء تعديلات أو إيقاف.'
                                    : 'Your meals are now being prepared. No further edits or pauses are available.',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Meals Section
                    _buildSection('Meals', 3, 3, _selectedMeals),
                    const SizedBox(height: 32),

                    // Salads Section - 0/3
                    _buildSection('Salads', 0, 3, []),
                    const SizedBox(height: 32),

                    // Salads Section - 1/3
                    _buildSection('Salads', 1, 3, _selectedSalads2),
                    const SizedBox(height: 100), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: [
                // Nutritional Summary (left in LTR, right in RTL)
                Row(
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Text(
                      'Protein',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.green,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    Text(
                      '21g',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.blue,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    Text(
                      'Carbs',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.blue,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    Text(
                      '21g',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.blue,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    Text(
                      'Fats',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.blue,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    Text(
                      '21g',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Total Calories (right in LTR, left in RTL)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Color(0xFFFF6B35),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Kcal 1000',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Action Buttons (hidden when preparing)
            if (!_isPreparing) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  // PAUSE Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        PauseDayBottomSheet.show(
                          context: context,
                          selectedDate: _displayedDate,
                          onPause: () {
                            // Handle pause action
                          },
                        );
                      },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF3A3A3A),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/pause.svg',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'PAUSE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // EDIT Button
                Expanded(
                    child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MealSelectionPage(
                            selectedDate: _displayedDate,
                            isEditMode: true,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF6B35),
                            Color(0xFFE55A2B),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'EDIT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, int current, int total, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            RichText(
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: '$title - '),
                  TextSpan(
                    text: '$current/$total',
                    style: const TextStyle(
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                ],
              ),
            ),
            if (current < total)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ADD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...items.map((meal) => _buildMealEntry(meal)),
        ],
      ],
    );
  }

  Widget _buildMealEntry(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Image (left in LTR, right in RTL)
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF3A3A3A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant,
              color: Color(0xFF9E9E9E),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                Row(
                  mainAxisAlignment: _isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Color(0xFFFF6B35),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${meal['calories']} kcal',
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: _isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
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
                      color: Colors.blue,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
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
                      color: Colors.blue,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
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
                      color: Colors.blue,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Text(
                      'Fats',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 12,
                      color: Colors.blue,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
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
          // Quantity (right in LTR, left in RTL)
          Text(
            'Qty: ${meal['quantity']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

