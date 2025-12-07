import 'package:flutter/material.dart';
import 'subscription_page.dart';
import '../services/meal_service.dart';
import '../services/language_service.dart';
import '../services/auth_storage_service.dart';
import '../widgets/empty_meals_widget.dart';
import '../widgets/meal_detail_widget.dart';

class MenuPage extends StatefulWidget {
  final int? mealPlanId;
  final String? mealPlanName;

  const MenuPage({
    super.key,
    this.mealPlanId,
    this.mealPlanName,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedDayIndex = 0; // Monday is selected by default
  int _selectedMealCategoryIndex = 0; // Breakfast is selected by default
  
  // API data state
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _mealItems = [];
  Map<int, bool> _favoriteStatus = {}; // Track favorites by meal ID
  int? _selectedCategoryId; // Store the actual category ID from API
  List<Map<String, dynamic>> _mealsCategories = []; // Store mealsCategories from meal plan
  
  final LanguageService _languageService = LanguageService();
  
  final List<String> _days = [
    'Mon',
    'Tue', 
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  
  // Map day names to API day IDs
  final Map<String, String> _dayIdMap = {
    'Mon': 'MON',
    'Tue': 'TUE',
    'Wed': 'WED',
    'Thu': 'THU',
    'Fri': 'FRI',
    'Sat': 'SAT',
    'Sun': 'SUN',
  };
  
  final List<String> _mealCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Salads',
  ];

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _loadMealPlanCategories();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    _loadMealPlanCategories();
  }

  bool get _isRTL => _languageService.isRTL;

  // Load meal plan data to get mealsCategories
  Future<void> _loadMealPlanCategories() async {
    if (widget.mealPlanId == null) {
      _loadMealData();
      return;
    }

    try {
      final lang = _languageService.currentLanguage == 'Arabic' ? 'ar' : 'en';
      
      // Fetch home data to get meal plan with mealsCategories
      final response = await MealService.getHomeData(
        lang: lang,
        page: 1,
        perPage: 20,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        
        if (data['mealPlans'] != null && data['mealPlans']['data'] != null) {
          final mealPlans = data['mealPlans']['data'] as List;
          
          // Find the meal plan that matches our mealPlanId
          for (var plan in mealPlans) {
            final planMap = plan as Map<String, dynamic>;
            if (planMap['id'] == widget.mealPlanId) {
              // Extract mealsCategories
              if (planMap['mealsCategories'] != null) {
                setState(() {
                  _mealsCategories = List<Map<String, dynamic>>.from(
                    (planMap['mealsCategories'] as List).map((cat) => cat as Map<String, dynamic>)
                  );
                  
                  // Set initial selected category ID from mealsCategories
                  if (_mealsCategories.isNotEmpty) {
                    _selectedCategoryId = _mealsCategories[0]['id'] as int?;
                  }
                });
              }
              break;
            }
          }
        }
      }
    } catch (e) {
      print('Error loading meal plan categories: $e');
    }
    
    // Load meal data after getting categories
    _loadMealData();
  }

  Future<void> _loadMealData() async {
    if (widget.mealPlanId == null) {
      setState(() {
        _isLoading = false;
        _error = 'Meal plan ID is required';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final lang = _languageService.currentLanguage == 'Arabic' ? 'ar' : 'en';
      final dayId = _dayIdMap[_days[_selectedDayIndex]] ?? 'MON';
      
      // Get category ID from mealsCategories array by matching name/code
      int mealCategoryId;
      if (_selectedCategoryId != null) {
        mealCategoryId = _selectedCategoryId!;
      } else if (_mealsCategories.isNotEmpty) {
        // Find category by matching name/code with selected category
        final categoryName = _mealCategories[_selectedMealCategoryIndex];
        final foundCategory = _mealsCategories.firstWhere(
          (cat) {
            final name = cat['name']?.toString().toLowerCase() ?? '';
            final code = cat['code']?.toString().toLowerCase() ?? '';
            return name.contains(categoryName.toLowerCase()) || 
                   (categoryName == 'Breakfast' && code == 'bf') ||
                   (categoryName == 'Lunch' && code == 'ln') ||
                   (categoryName == 'Dinner' && (code == 'din' || code == 'dinner')) ||
                   (categoryName == 'Salads' && (code == 'sal' || code == 'salads'));
          },
          orElse: () => _selectedMealCategoryIndex < _mealsCategories.length 
              ? _mealsCategories[_selectedMealCategoryIndex] 
              : (_mealsCategories.isNotEmpty ? _mealsCategories[0] : {}),
        );
        mealCategoryId = foundCategory['id'] as int? ?? (_selectedMealCategoryIndex + 1);
        _selectedCategoryId = mealCategoryId;
      } else {
        // Fallback if mealsCategories not loaded yet
        mealCategoryId = _selectedMealCategoryIndex + 1;
      }
      
      // Get userId if available
      final userId = await AuthStorageService.getUserId();

      final response = await MealService.getMealDetailsFromDetails(
        lang: lang,
        mealPlanId: widget.mealPlanId!,
        dayId: dayId,
        mealCategoryId: mealCategoryId,
        userId: userId,
        page: 1,
        perPage: 20,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        
        setState(() {
          // Parse categories
          if (data['categories'] != null) {
            _categories = List<Map<String, dynamic>>.from(
              (data['categories'] as List).map((cat) => cat as Map<String, dynamic>)
            );
            
            // The API already filters by mealCategoryId, so the response contains only the requested category
            // Find the category that matches the ID we sent (or use the first category if only one is returned)
            Map<String, dynamic>? selectedCategory;
            if (_categories.isNotEmpty) {
              // Try to find category by the ID we sent to the API
              if (_selectedCategoryId != null) {
                selectedCategory = _categories.firstWhere(
                  (cat) => cat['id'] == _selectedCategoryId,
                  orElse: () => _categories[0], // Fallback to first category
                );
              } else {
                // If no ID set, use first category (API should only return one category anyway)
                selectedCategory = _categories[0];
                _selectedCategoryId = selectedCategory['id'] as int?;
              }
            }
            
            // Get meal items from the selected category
            // The API already filters items by mealCategoryId, so items are already in the correct category
            _mealItems = [];
            if (selectedCategory != null && 
                selectedCategory['items'] != null && 
                selectedCategory['items']['data'] != null) {
              // Items are already filtered by the API based on mealCategoryId parameter
              // So we can directly use items from the selected category's array
              _mealItems = List<Map<String, dynamic>>.from(
                (selectedCategory['items']['data'] as List).map((item) => item as Map<String, dynamic>)
              );
            }
          }
          
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response['message']?.toString() ?? 'Failed to load meal data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Error loading meal data: $e');
    }
  }

  void _onDaySelected(int index) {
    setState(() {
      _selectedDayIndex = index;
    });
    _loadMealData();
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedMealCategoryIndex = index;
      
      // Get category ID from mealsCategories array by matching name/code
      final categoryName = _mealCategories[index];
      final foundCategory = _mealsCategories.firstWhere(
        (cat) {
          final name = cat['name']?.toString().toLowerCase() ?? '';
          final code = cat['code']?.toString().toLowerCase() ?? '';
            return name.contains(categoryName.toLowerCase()) || 
                   (categoryName == 'Breakfast' && code == 'bf') ||
                   (categoryName == 'Lunch' && code == 'ln') ||
                   (categoryName == 'Dinner' && (code == 'din' || code == 'dinner')) ||
                   (categoryName == 'Salads' && (code == 'sal' || code == 'salads'));
        },
        orElse: () => _mealsCategories.isNotEmpty && index < _mealsCategories.length 
            ? _mealsCategories[index] 
            : (_mealsCategories.isNotEmpty ? _mealsCategories[0] : {}),
      );
      _selectedCategoryId = foundCategory['id'] as int?;
    });
    _loadMealData();
  }

  // Map UI category names to API category codes/names
  String _getCategoryCode(int index) {
    final categoryMap = {
      0: 'bf', // Breakfast
      1: 'ln', // Lunch
      2: 'sal', // Salads
      3: 'din', // Dinner
    };
    return categoryMap[index] ?? 'bf';
  }

  // Find category ID by matching name or code
  int? _findCategoryId(List<Map<String, dynamic>> categories, int selectedIndex) {
    if (categories.isEmpty) return null;
    
    final categoryName = _mealCategories[selectedIndex];
    final categoryCode = _getCategoryCode(selectedIndex);
    
    // Try to find by name first
    for (var category in categories) {
      final name = category['name']?.toString().toLowerCase() ?? '';
      final code = category['code']?.toString().toLowerCase() ?? '';
      
      if (name.contains(categoryName.toLowerCase()) || 
          code == categoryCode) {
        return category['id'] as int?;
      }
    }
    
    // Fallback: use first category with items
    for (var category in categories) {
      if (category['items'] != null && 
          category['items']['data'] != null &&
          (category['items']['data'] as List).isNotEmpty) {
        return category['id'] as int?;
      }
    }
    
    // Last resort: use first category
    if (categories.isNotEmpty) {
      return categories[0]['id'] as int?;
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.mealPlanName ?? 'Zen Meal Plan',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.info_outline,
              color: Color(0xFFFF6B35),
              size: 20,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Weekly Day Indicator
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              border: Border(
                bottom: BorderSide(color: Color(0xFF3A3A3A), width: 0.5),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                String day = _days[index];
                bool isSelected = index == _selectedDayIndex;
                
                return GestureDetector(
                  onTap: () => _onDaySelected(index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Meal Category Navigation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              border: Border(
                bottom: BorderSide(color: Color(0xFF3A3A3A), width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _mealCategories.asMap().entries.map((entry) {
                int index = entry.key;
                String category = entry.value;
                bool isSelected = index == _selectedMealCategoryIndex;
                
                return GestureDetector(
                  onTap: () => _onCategorySelected(index),
                  child: Column(
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: category.length * 8.0, // Dynamic width based on text length
                        height: 2,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          // Main Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF6B35),
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadMealData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35),
                              ),
                              child: const Text('Retry', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Meal Items List from API
                              if (_mealItems.isEmpty)
                                Center(
                                  child: EmptyMealsWidget(
                                    title: _isRTL ? 'لا توجد وجبات متاحة!' : 'No Meals Available!',
                                    subtitle: _isRTL 
                                        ? 'لم يتم جدولة وجباتك لهذا اليوم بعد. تحقق مرة أخرى لاحقًا أو استكشف أيامًا أخرى.'
                                        : 'Your meals for this day haven\'t been scheduled yet. Check back later or explore other days.',
                                    isRTL: _isRTL,
                                  ),
                                )
                              else
                                ..._mealItems.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final meal = entry.value;
                                  final mealId = meal['id'] as int?;
                                  
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: index < _mealItems.length - 1 ? 16 : 0),
                                    child: _buildMealItemCard(
                                      mealId ?? index,
                                      meal['name']?.toString() ?? '',
                                      meal['description']?.toString() ?? '',
                                      meal['kcal']?.toString() ?? '0',
                                      meal['protein']?.toString() ?? '0',
                                      meal['carbs']?.toString() ?? '0',
                                      meal['fats']?.toString() ?? '0',
                                      meal['image']?.toString(),
                                    ),
                                  );
                                }).toList(),
                              
                              const SizedBox(height: 100), // Extra space for fixed button
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: _mealItems.isEmpty
          ? null
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 56,
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
                    // Navigate to subscription page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SubscriptionPage(
                          mealPlanId: widget.mealPlanId,
                          mealPlanName: widget.mealPlanName,
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
                  child: const Text(
                    'SUBSCRIBE NOW!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildNutritionSummary(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMealCategory(String title, String count, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              count,
              style: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildMealItemCard(int mealId, String name, String description, String calories, String protein, String carbs, String fats, [String? imageUrl]) {
    final isFavorite = _favoriteStatus[mealId] ?? false;
    return GestureDetector(
      onTap: () {
        // Parse meal data and show bottom sheet
        final caloriesInt = int.tryParse(calories) ?? 0;
        final proteinInt = int.tryParse(protein) ?? 0;
        final carbsInt = int.tryParse(carbs) ?? 0;
        final fatsInt = int.tryParse(fats) ?? 0;
        
        MealDetailWidget.showAsBottomSheet(
          context: context,
          title: name,
          description: description.isNotEmpty ? description : name,
          calories: caloriesInt,
          protein: proteinInt,
          carbs: carbsInt,
          fat: fatsInt,
          imageUrl: imageUrl,
          onAddMeals: () {
            // Handle add meals action
            Navigator.of(context).pop(); // Close bottom sheet
            // Navigate to subscription page or handle add meals
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SubscriptionPage(
                  mealPlanId: widget.mealPlanId,
                  mealPlanName: widget.mealPlanName,
                ),
              ),
            );
          },
        );
      },
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Color(0xFFFF6B35),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$calories kcal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Protein ${protein}g',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.green,
                    ),
                    Text(
                      'Carbs ${carbs}g',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.green,
                    ),
                    Text(
                      'Fats ${fats}g',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Food Image
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.restaurant,
                              color: Color(0xFF9E9E9E),
                              size: 40,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.restaurant,
                        color: Color(0xFF9E9E9E),
                        size: 40,
                      ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _favoriteStatus[mealId] = !isFavorite;
                    });
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
