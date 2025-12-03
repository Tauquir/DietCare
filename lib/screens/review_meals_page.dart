import 'package:flutter/material.dart';
import '../services/language_service.dart';

class ReviewMealsPage extends StatefulWidget {
  final DateTime selectedDate;

  const ReviewMealsPage({
    super.key,
    required this.selectedDate,
  });

  @override
  State<ReviewMealsPage> createState() => _ReviewMealsPageState();
}

class _ReviewMealsPageState extends State<ReviewMealsPage> {
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'reviewMeals': 'Review Your Meals!',
      'checkSelections': 'Check your selections before finalizing.',
      'meals': 'Meals',
      'salads': 'Salads',
      'snacks': 'Snacks',
      'add': 'ADD',
      'quantity': 'Qty:',
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fats': 'Fats',
      'kcal': 'kcal',
      'confirm': 'CONFIRM',
      'forgotMeal': 'Missed selecting a meal?',
      'autoRepeat': 'We\'ll carry over your previous week\'s choices automatically.',
    },
    'Arabic': {
      'reviewMeals': 'راجع وجباتك!',
      'checkSelections': 'تأكد من اختياراتك قبل التأكيد النهائي.',
      'meals': 'وجبات',
      'salads': 'سلطات',
      'snacks': 'سناكات',
      'add': 'أضف',
      'quantity': 'الكمية:',
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'fats': 'دهون',
      'kcal': 'كيلو',
      'confirm': 'تأكيد',
      'forgotMeal': 'نسيت تختار وجبة؟',
      'autoRepeat': 'بنكرر لك اختيارات الأسبوع اللي طاف تلقائيا.',
    },
  };

  String _getText(String key) {
    return _translations[_languageService.currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  bool get _isRTL => _languageService.isRTL;

  String _formatDateForButton(DateTime date) {
    if (_isRTL) {
      final monthsAr = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      return '${monthsAr[date.month - 1]} ${date.day},${date.year}';
    } else {
      final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
      return '${months[date.month - 1]} ${date.day},${date.year}';
    }
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

  List<Map<String, dynamic>> get _selectedSnacks {
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
            Padding(
              padding: const EdgeInsets.all(20),
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
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFF6B35)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFFFF6B35),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDateForButton(widget.selectedDate),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Text(
                    _getText('reviewMeals'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getText('checkSelections'),
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meals Section
                    _buildSection(_getText('meals'), 3, 3, _selectedMeals),
                    const SizedBox(height: 32),

                    // Salads Section
                    _buildSection(_getText('salads'), 1, 0, _selectedSalads),
                    const SizedBox(height: 32),

                    // Snacks Section
                    _buildSection(_getText('snacks'), 2, 1, _selectedSnacks),
                    const SizedBox(height: 32),

                    // Information Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF6B35).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.info,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                Text(
                                  _getText('forgotMeal'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getText('autoRepeat'),
                                  style: const TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Space for fixed bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Summary Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          border: Border(
            top: BorderSide(color: Color(0xFF3A3A3A), width: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: [
                // Total Calories (left in LTR, right in RTL)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '1000 ${_getText('kcal')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Nutritional Summary (right in LTR, left in RTL)
                Row(
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    _buildNutritionLabel(_getText('protein'), '21g'),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.green,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    _buildNutritionLabel(_getText('carbs'), '21g'),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.green,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    _buildNutritionLabel(_getText('fats'), '21g'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Confirm Button
            Container(
              width: double.infinity,
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
                  // Handle confirm
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  _getText('confirm'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionLabel(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getText('add'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map((meal) => _buildMealEntry(meal)),
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
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(30),
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
                      '${meal['calories']} ${_getText('kcal')}',
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
                    _buildNutritionValue(_getText('protein'), meal['protein']),
                    Container(
                      width: 1,
                      height: 12,
                      color: Colors.green,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    _buildNutritionValue(_getText('carbs'), meal['carbs']),
                    Container(
                      width: 1,
                      height: 12,
                      color: Colors.green,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    _buildNutritionValue(_getText('fats'), meal['fats']),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Quantity (right in LTR, left in RTL)
          Text(
            '${_getText('quantity')} ${meal['quantity']}',
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

  Widget _buildNutritionValue(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

