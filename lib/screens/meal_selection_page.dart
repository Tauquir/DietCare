import 'package:flutter/material.dart';
import 'review_meals_page.dart';
import '../services/language_service.dart';

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
  final LanguageService _languageService = LanguageService();
  late DateTime _displayedDate;
  int _selectedDateIndex = 1; // Default to center date (Oct 22)
  int _selectedCategoryIndex = 2; // Default to Salads
  final Map<int, int> _mealQuantities = {};
  final int _totalSelectedMeals = 3;

  final List<String> _categoriesEn = ['Breakfast', 'Lunch', 'Salads', 'Dinner'];
  final List<String> _categoriesAr = ['إفطار', 'غداء', 'سلطات', 'عشاء'];
  final List<int> _categoryCounts = [2, 2, 2, 0];

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'pauseDay': 'PAUSE DAY',
      'add': 'ADD',
      'saveMeals': 'SAVE MEALS',
      'selected': 'SELECTED',
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fats': 'Fats',
      'kcal': 'kcal',
      'pauseMealsTitle': 'Pause Meals for Today?',
      'pauseMealsDescription': 'Put your meal plan on hold for',
      'pauseMealsDescription2': '. You can unpause it later if you change your mind.',
      'pause': 'PAUSE',
    },
    'Arabic': {
      'pauseDay': 'يوم موقوف',
      'add': 'أضف',
      'saveMeals': 'حفظ الوجبات',
      'selected': 'محدد',
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'fats': 'دهون',
      'kcal': 'كيلو',
      'pauseMealsTitle': 'إيقاف الوجبات لهذا اليوم؟',
      'pauseMealsDescription': 'ضع خطة وجباتك في الانتظار لـ',
      'pauseMealsDescription2': '. يمكنك إلغاء الإيقاف لاحقًا إذا غيرت رأيك.',
      'pause': 'إيقاف',
    },
  };

  String _getText(String key) {
    return _translations[_languageService.currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  bool get _isRTL => _languageService.isRTL;

  List<String> get _categories => _isRTL ? _categoriesAr : _categoriesEn;

  final List<String> _weekDaysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _weekDaysAr = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];

  List<String> get _weekDays => _isRTL ? _weekDaysAr : _weekDaysEn;

  @override
  void initState() {
    super.initState();
    _displayedDate = widget.selectedDate;
    _languageService.addListener(_onLanguageChanged);
    _mealQuantities[1] = 2;
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  List<Map<String, dynamic>> get _meals {
    if (_isRTL) {
      return [
        {
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'description': 'وعاء صحي من الدجاج والخضروات والبيض والحبوب.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
          'image': 'placeholder',
        },
        {
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'description': 'وعاء صحي من الدجاج والخضروات والبيض والحبوب.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': false,
          'image': 'placeholder',
          'quantity': 2,
        },
        {
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'description': 'وعاء صحي من الدجاج والخضروات والبيض والحبوب.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': false,
          'image': 'placeholder',
        },
        {
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'description': 'وعاء صحي من الدجاج والخضروات والبيض والحبوب.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': false,
          'image': 'placeholder',
        },
      ];
    } else {
      return [
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
    }
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
                  ),
                  if (_isRTL)
                    Text(
                      'لامت',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          const Icon(Icons.pause, color: Color(0xFF9E9E9E), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            _getText('pauseDay'),
                            style: const TextStyle(
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
                      margin: EdgeInsets.only(
                        right: _isRTL ? (index == 5 ? 12 : 8) : (index == 0 ? 12 : 8),
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

            // Category Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: _isRTL,
                child: Row(
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: List.generate(_categories.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: _isRTL ? 0 : 20,
                          left: _isRTL ? 20 : 0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                Text(
                                  '${_categories[index]} ${_categoryCounts[index] > 0 ? _categoryCounts[index] : ''}',
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
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        // Image side (left in LTR, right in RTL)
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
                                  right: _isRTL ? null : 8,
                                  left: _isRTL ? 8 : null,
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
                                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                                  child: Text(
                                    _getText('add'),
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
                        const SizedBox(width: 16),
                        // Right side - Text content (left in RTL)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                                mainAxisAlignment: _isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: Color(0xFFFF6B35),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${meal['calories']} ${_getText('kcal')}',
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
                                mainAxisAlignment: _isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                children: [
                                  Text(
                                    _getText('protein'),
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
                                    _getText('carbs'),
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
                                    _getText('fats'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: _isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
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
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            if (_isRTL) ...[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
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
                    child: Text(
                      _getText('saveMeals'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                textDirection: TextDirection.rtl,
                children: [
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
            ] else ...[
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
                    child: Text(
                      _getText('saveMeals'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                Text(
                  _getText('pauseMealsTitle'),
                  style: const TextStyle(
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
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: _getText('pauseMealsDescription')),
                      TextSpan(
                        text: ' ${_formatDate(_displayedDate)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(text: _getText('pauseMealsDescription2')),
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
                    child: Text(
                      _getText('pause'),
                      style: const TextStyle(
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

