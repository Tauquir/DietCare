import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'review_meals_page.dart';
import 'confirmed_meals_page.dart';
import '../services/language_service.dart';
import '../services/meal_service.dart';
import '../services/subscription_service.dart';
import '../services/auth_storage_service.dart';
import '../widgets/empty_meals_widget.dart';
import '../widgets/pause_day_bottom_sheet.dart';

class MealSelectionPage extends StatefulWidget {
  final DateTime selectedDate;
  final bool isEditMode;
  final int? mealPlanId;
  final Map<String, String>? mealStatusMap; // Status map from calendar page

  const MealSelectionPage({
    super.key,
    required this.selectedDate,
    this.isEditMode = false,
    this.mealPlanId,
    this.mealStatusMap,
  });

  @override
  State<MealSelectionPage> createState() => _MealSelectionPageState();
}

class _MealSelectionPageState extends State<MealSelectionPage> {
  final LanguageService _languageService = LanguageService();
  late DateTime _displayedDate;
  int _selectedDateIndex = 1; // Default to center date (Oct 22)
  int _selectedCategoryIndex = 0; // Default to Breakfast
  Map<int, int> _mealQuantities = {}; // Changed to non-final to allow updates from API

  // API data
  bool _isLoading = false;
  List<Map<String, dynamic>> _categories = [];
  Map<int, List<Map<String, dynamic>>> _mealsByCategory = {};
  Map<int, int> _maxItemsByCategory = {};
  String? _subscriptionId; // Store subscription ID for API calls
  Map<int, int> _previousQuantities = {}; // Track previously selected quantities to detect deselections
  
  // Fallback categories if API fails
  final List<String> _categoriesEn = ['Breakfast', 'Lunch', 'Salads', 'Dinner'];
  final List<String> _categoriesAr = ['إفطار', 'غداء', 'سلطات', 'عشاء'];

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'pauseDay': 'PAUSE DAY',
      'add': 'ADD',
      'saveMeals': 'SAVE MEALS',
      'updateMeals': 'UPDATE',
      'selected': 'SELECTED',
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fats': 'Fats',
      'kcal': 'kcal',
      'noMealsAvailable': 'No Meals Available!',
      'mealsNotScheduled': 'Your meals for this day haven\'t been scheduled yet. Check back later or explore other days.',
    },
    'Arabic': {
      'pauseDay': 'يوم موقوف',
      'add': 'أضف',
      'saveMeals': 'حفظ الوجبات',
      'updateMeals': 'تحديث',
      'selected': 'محدد',
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'fats': 'دهون',
      'kcal': 'كيلو',
      'noMealsAvailable': 'لا توجد وجبات متاحة!',
      'mealsNotScheduled': 'لم يتم جدولة وجباتك لهذا اليوم بعد. تحقق مرة أخرى لاحقًا أو استكشف أيامًا أخرى.',
    },
  };

  String _getText(String key) {
    return _translations[_languageService.currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  bool get _isRTL => _languageService.isRTL;

  final List<String> _weekDaysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _weekDaysAr = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];

  List<String> get _weekDays => _isRTL ? _weekDaysAr : _weekDaysEn;

  @override
  void initState() {
    super.initState();
    _displayedDate = widget.selectedDate;
    _languageService.addListener(_onLanguageChanged);
    _loadMealData();
  }

  // Get day of week abbreviation (MON, TUE, etc.)
  String _getDayOfWeekAbbr(DateTime date) {
    final weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    // DateTime.weekday: Monday=1, Tuesday=2, ..., Sunday=7
    return weekdays[date.weekday - 1];
  }

  // Get category ID for a meal item
  int? _getCategoryIdForMeal(int mealId) {
    for (var category in _categories) {
      final categoryId = category['id'] as int?;
      if (categoryId != null) {
        final meals = _mealsByCategory[categoryId] ?? [];
        for (var meal in meals) {
          if (meal['id'] == mealId) {
            return categoryId;
          }
        }
      }
    }
    return null;
  }

  // Save meal selections to API
  Future<void> _saveMealSelections() async {
    if (widget.mealPlanId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isRTL ? 'لا توجد خطة وجبات' : 'No meal plan selected'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      final token = await AuthStorageService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isRTL ? 'يرجى تسجيل الدخول' : 'Please login'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Get subscription ID
      final subscriptionId = await _getSubscriptionId();
      if (subscriptionId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isRTL ? 'لا توجد اشتراك نشط' : 'No active subscription'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Format date as YYYY-MM-DD
      final dateStr = '${_displayedDate.year}-${_displayedDate.month.toString().padLeft(2, '0')}-${_displayedDate.day.toString().padLeft(2, '0')}';

      // Build selections array from _mealQuantities
      // Include all items: quantity > 0 for selected, quantity = 0 to deselect
      final List<Map<String, dynamic>> selections = [];
      
      // Get all meal IDs from all categories to ensure we handle deselections
      final Set<int> allMealIds = {};
      for (var category in _categories) {
        final categoryId = category['id'] as int?;
        if (categoryId != null) {
          final meals = _mealsByCategory[categoryId] ?? [];
          for (var meal in meals) {
            final mealId = meal['id'] as int?;
            if (mealId != null) {
              allMealIds.add(mealId);
            }
          }
        }
      }
      
      // Add all items: current selections and deselections
      for (var mealId in allMealIds) {
        final categoryId = _getCategoryIdForMeal(mealId);
        if (categoryId != null) {
          final currentQuantity = _mealQuantities[mealId] ?? 0;
          final previousQuantity = _previousQuantities[mealId] ?? 0;
          
          // Include item if:
          // 1. It has a current quantity > 0 (selected)
          // 2. It was previously selected but now has quantity 0 (deselected)
          if (currentQuantity > 0 || (previousQuantity > 0 && currentQuantity == 0)) {
            selections.add({
              'itemId': mealId,
              'mealCategoryId': categoryId,
              'quantity': currentQuantity,
            });
          }
        }
      }

      print('💾 Saving selections: $selections');

      // Call API to save selections
      final response = await SubscriptionService.saveDailySelections(
        subscriptionId: subscriptionId,
        mealPlanId: widget.mealPlanId!,
        date: dateStr,
        selections: selections,
        token: token,
      );

      if (response['success'] == true) {
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message']?.toString() ?? (_isRTL ? 'تم حفظ الوجبات بنجاح' : 'Meals saved successfully')),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate to review page after successful save
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReviewMealsPage(
                selectedDate: _displayedDate,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message']?.toString() ?? (_isRTL ? 'فشل حفظ الوجبات' : 'Failed to save meals')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('Network')
                  ? (_isRTL ? 'خطأ في الشبكة' : 'Network error')
                  : e.toString().replaceFirst('Exception: ', ''),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error saving meal selections: $e');
    }
  }

  // Get subscription ID from active subscription
  Future<String?> _getSubscriptionId() async {
    if (_subscriptionId != null) {
      return _subscriptionId;
    }

    try {
      final token = await AuthStorageService.getToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      final subscriptionsResponse = await SubscriptionService.getMySubscriptions(token: token);
      
      if (subscriptionsResponse['success'] == true && subscriptionsResponse['data'] != null) {
        final subscriptions = subscriptionsResponse['data']['subscriptions'] as List<dynamic>?;
        
        if (subscriptions != null && subscriptions.isNotEmpty) {
          final activeSubscription = subscriptions.firstWhere(
            (sub) => (sub as Map<String, dynamic>)['status'] == 'active' || 
                     (sub as Map<String, dynamic>)['status'] == 'pending',
            orElse: () => subscriptions.first,
          ) as Map<String, dynamic>;
          
          final subscriptionId = activeSubscription['id']?.toString();
          if (subscriptionId != null) {
            _subscriptionId = subscriptionId;
            return subscriptionId;
          }
        }
      }
    } catch (e) {
      print('Error getting subscription ID: $e');
    }
    
    return null;
  }

  // Load meal data from API using daily selections endpoint
  Future<void> _loadMealData() async {
    if (widget.mealPlanId == null) {
      // No meal plan ID, use fallback data
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthStorageService.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get subscription ID
      final subscriptionId = await _getSubscriptionId();
      if (subscriptionId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Format date as YYYY-MM-DD
      final dateStr = '${_displayedDate.year}-${_displayedDate.month.toString().padLeft(2, '0')}-${_displayedDate.day.toString().padLeft(2, '0')}';

      // Fetch daily selections for this date
      final response = await SubscriptionService.getDailySelections(
        subscriptionId: subscriptionId,
        mealPlanId: widget.mealPlanId!,
        date: dateStr,
        token: token,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        final categoriesList = data['categories'] as List<dynamic>?;

        final Map<int, List<Map<String, dynamic>>> mealsByCategory = {};
        final Map<int, int> maxItemsByCategory = {};
        final List<Map<String, dynamic>> categories = [];
        final Map<int, int> mealQuantities = {};

        if (categoriesList != null) {
          for (var cat in categoriesList) {
            final category = cat as Map<String, dynamic>;
            final catId = category['id'] as int?;
            final items = category['items'] as List<dynamic>?;
            final maxLimit = category['maxLimit'] as int? ?? 3;

            if (catId != null) {
              // Store category info
              categories.add({
                'id': catId,
                'name': category['name']?.toString() ?? '',
                'code': category['code']?.toString() ?? '',
              });

              // Parse meal items
              final mealItems = <Map<String, dynamic>>[];
              if (items != null) {
                for (var item in items) {
                  final mealItem = item as Map<String, dynamic>;
                  final itemId = mealItem['id'] as int?;
                  final selectedQuantity = mealItem['selectedQuantity'] as int? ?? 0;
                  final isSelected = mealItem['isSelected'] == true || mealItem['isSelected'] == 1;

                  if (itemId != null) {
                    mealItems.add({
                      'id': itemId,
                      'name': mealItem['name']?.toString() ?? '',
                      'description': mealItem['description']?.toString() ?? '',
                      'kcal': mealItem['kcal'] ?? 0,
                      'protein': mealItem['protein'] ?? 0,
                      'carbs': mealItem['carbs'] ?? 0,
                      'fats': mealItem['fats'] ?? 0,
                      'image': mealItem['image']?.toString(),
                    });

                    // Set quantity if meal is selected
                    if (isSelected && selectedQuantity > 0) {
                      mealQuantities[itemId] = selectedQuantity;
                    }
                  }
                }
              }

              mealsByCategory[catId] = mealItems;
              maxItemsByCategory[catId] = maxLimit;
            }
          }
        }

        setState(() {
          _categories = categories;
          _mealsByCategory = mealsByCategory;
          _maxItemsByCategory = maxItemsByCategory;
          _previousQuantities = Map.from(mealQuantities); // Store previous state
          _mealQuantities = mealQuantities; // Update quantities from API
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading meal data: $e');
    }
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  // Get meals for the currently selected category
  List<Map<String, dynamic>> get _meals {
    if (_categories.isEmpty || _selectedCategoryIndex >= _categories.length) {
      return [];
    }
    
    final selectedCategory = _categories[_selectedCategoryIndex];
    final categoryId = selectedCategory['id'] as int?;
    
    if (categoryId == null) {
      return [];
    }
    
    // Get meals for this category from API data
    final meals = _mealsByCategory[categoryId] ?? [];
    
    // Format meals to match the expected structure
    return meals.map((meal) {
      return {
        'id': meal['id'],
        'title': meal['name'] ?? '',
        'description': meal['description'] ?? '',
        'calories': meal['kcal']?.toString() ?? '0',
        'protein': meal['protein']?.toString() ?? '0',
        'carbs': meal['carbs']?.toString() ?? '0',
        'fats': meal['fats']?.toString() ?? '0',
          'isFavorite': false,
        'image': meal['image'] ?? '',
        'quantity': _mealQuantities[meal['id']] ?? 0,
      };
    }).toList();
  }

  // Get category names from API or fallback
  List<String> get _categoryNames {
    if (_categories.isNotEmpty) {
      return _categories.map((cat) => cat['name']?.toString() ?? '').toList();
    }
    return _isRTL ? _categoriesAr : _categoriesEn;
  }
  
  // Get category count (selected meals / max items)
  int _getCategoryCount(int categoryIndex) {
    if (_categories.isEmpty || categoryIndex >= _categories.length) {
      return 0;
    }
    
    final category = _categories[categoryIndex];
    final categoryId = category['id'] as int?;
    
    if (categoryId == null) {
      return 0;
    }
    
    // Count selected meals in this category
    final meals = _mealsByCategory[categoryId] ?? [];
    int selectedCount = 0;
    for (var meal in meals) {
      final mealId = meal['id'];
      if (_mealQuantities[mealId] != null && _mealQuantities[mealId]! > 0) {
        selectedCount += _mealQuantities[mealId]!;
      }
    }
    
    return selectedCount;
  }
  
  int _getMaxItemsForCategory(int categoryIndex) {
    if (_categories.isEmpty || categoryIndex >= _categories.length) {
      return 3;
    }
    
    final category = _categories[categoryIndex];
    final categoryId = category['id'] as int?;
    
    if (categoryId == null) {
      return 3;
    }
    
    return _maxItemsByCategory[categoryId] ?? 3;
  }

  // Calculate total selected meals across all categories
  int _getTotalSelectedMeals() {
    int total = 0;
    for (var quantity in _mealQuantities.values) {
      if (quantity > 0) {
        total += quantity;
      }
    }
    return total;
  }

  // Calculate total max meals allowed across all categories
  int _getTotalMaxMeals() {
    if (_categories.isEmpty) {
      return 3; // Default fallback
    }
    
    int total = 0;
    for (int i = 0; i < _categories.length; i++) {
      total += _getMaxItemsForCategory(i);
    }
    return total;
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
                  GestureDetector(
                    onTap: () => PauseDayBottomSheet.show(
                      context: context,
                      selectedDate: _displayedDate,
                      onPause: () {
                        // Handle pause action
                        // You can add your pause logic here
                      },
                    ),
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
                  
                  // Get status from calendar data (format: YYYY-MM-DD)
                  final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  final status = widget.mealStatusMap?[dateKey] ?? 'empty';
                  
                  // Determine status icon based on actual status from calendar
                  Widget? statusIcon;
                  if (!isSelected) {
                    switch (status) {
                      case 'delivered':
                        statusIcon = SvgPicture.asset(
                          'assets/svg/mealdel.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        );
                        break;
                      case 'selected':
                        statusIcon = SvgPicture.asset(
                          'assets/svg/meal.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        );
                        break;
                      case 'preparing':
                        statusIcon = SvgPicture.asset(
                          'assets/svg/preparing.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        );
                        break;
                      case 'paused':
                        statusIcon = SvgPicture.asset(
                          'assets/svg/pause.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        );
                        break;
                      case 'choose':
                      default:
                        statusIcon = null; // No icon for empty/choose status
                        break;
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _displayedDate = date;
                        _selectedDateIndex = index;
                        // Reset meal quantities when changing date
                        _mealQuantities.clear();
                      });
                      // Reload meal data for the new date
                      _loadMealData();
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
                            statusIcon!
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

            // Category Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: _isRTL,
                child: Row(
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: List.generate(_categoryNames.length, (index) {
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
                                  _categoryNames[index],
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
                                if (_getCategoryCount(index) > 0) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                    child: Text(
                                      '${_getCategoryCount(index)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        ),
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
              child: _meals.isEmpty
                  ? Center(
                      child: EmptyMealsWidget(
                        title: _getText('noMealsAvailable'),
                        subtitle: _getText('mealsNotScheduled'),
                        isRTL: _isRTL,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _meals.length,
                      itemBuilder: (context, index) {
                  final meal = _meals[index];
                  final mealId = meal['id'];
                  final quantity = _mealQuantities[mealId] ?? 0;

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
                        // Left side - Text content (right in RTL)
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
                              // Nutritional information with colored separators
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
                                    color: Colors.black,
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
                                    color: Colors.green,
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
                                    color: Colors.black,
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
                        const SizedBox(width: 16),
                        // Image side (right in LTR, left in RTL)
                        Column(
                          children: [
                            Stack(
                              children: [
                                ClipOval(
                                  child: meal['image'] != null && meal['image'].toString().isNotEmpty
                                      ? Image.network(
                                          meal['image'],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF3A3A3A),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.restaurant,
                                                color: Color(0xFF9E9E9E),
                                                size: 40,
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 100,
                                          height: 100,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF3A3A3A),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.restaurant,
                                            color: Color(0xFF9E9E9E),
                                            size: 40,
                                          ),
                                        ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: _isRTL ? null : 0,
                                  left: _isRTL ? 0 : null,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        meal['isFavorite'] = !(meal['isFavorite'] ?? false);
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
                                          _mealQuantities[mealId] = quantity - 1;
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
                                        _mealQuantities[mealId] = (quantity ?? 0) + 1;
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
                                    _mealQuantities[mealId] = 1;
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
                      // Save meal selections to API before navigating
                      _saveMealSelections();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      widget.isEditMode ? _getText('updateMeals') : _getText('saveMeals'),
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
                    '${_getTotalSelectedMeals()}/${_getTotalMaxMeals()}',
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
                    'SELECTED MEALS',
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
                    '${_getTotalSelectedMeals()}/${_getTotalMaxMeals()}',
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
                      // Save meal selections to API before navigating
                      _saveMealSelections();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      widget.isEditMode ? _getText('updateMeals') : _getText('saveMeals'),
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

}

