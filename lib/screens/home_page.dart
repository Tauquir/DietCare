import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer' as developer;
import 'menu_page.dart';
import 'subscription_page.dart';
import 'calendar_page.dart';
import 'account_page.dart';
import 'goal_selection_page.dart';
import '../widgets/meal_plan_card.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../services/language_service.dart';
import '../services/meal_service.dart';
import '../services/user_service.dart';
import '../services/auth_storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  int _currentCardIndex = 0;
  late PageController _pageController;
  final LanguageService _languageService = LanguageService();

  // API data state
  bool _isLoading = true;
  bool _isLoadingMealPlans = false; // Separate loading state for meal plans section
  String? _error;
  String? _bannerUrl;
  String? _greeting;
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _mealPlans = [];
  int? _selectedCategoryId;
  Set<int> _favoriteMealPlanIds = {}; // Track favorite meal plan IDs

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'headerLine1': 'Effortless',
      'headerLine2': 'Healthy Eating!',
      'helpTitle': 'Need help choosing',
      'helpTitle2': 'the right meal?',
      'helpSubtitle': 'Set goals & design your meal plan!',
      'letsGo': 'Let\'s Go',
      'dietPlans': 'Diet Plans',
      'healthy': 'Healthy',
      'lifestyle': 'Lifestyle',
      'gainMuscle': 'Gain Muscle',
      'zenMealPlan': 'Zen Meal Plan',
      'zenSubtitle': 'For steady, visible progress.',
      'breakfast': 'Breakfast',
      'mainCourse': 'Main Course',
      'soupSnack': 'Soup & Snack',
      'saladDrink': 'Salad & Drink',
    },
    'Arabic': {
      'headerLine1': 'تناول طعام',
      'headerLine2': 'صحي بسهولة!',
      'helpTitle': 'تحتاج مساعدة في',
      'helpTitle2': 'اختيار الوجبة المناسبة؟',
      'helpSubtitle': 'حدد الأهداف وصمم خطة وجباتك!',
      'letsGo': 'هيا بنا',
      'dietPlans': 'خطط النظام الغذائي',
      'healthy': 'صحي',
      'lifestyle': 'نمط الحياة',
      'gainMuscle': 'اكتساب العضلات',
      'zenMealPlan': 'خطة وجبات زن',
      'zenSubtitle': 'للتقدم المستمر والمرئي.',
      'breakfast': 'إفطار',
      'mainCourse': 'طبق رئيسي',
      'soupSnack': 'شوربة ووجبة خفيفة',
      'saladDrink': 'سلطة ومشروب',
    },
  };

  String _getText(String key) {
    return _translations[_languageService.currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  bool get _isRTL => _languageService.isRTL;

  // Helper method to get category icon (fallback to local assets)
  String _getCategoryIcon(int index) {
    final localIcons = [
      'assets/1.png',
      'assets/2.png',
      'assets/3.png',
      'assets/4.png',
    ];
    if (index < _categories.length && _categories[index]['icon'] != null) {
      return _categories[index]['icon'] as String;
    }
    if (index < localIcons.length) {
      return localIcons[index];
    }
    return 'assets/1.png';
  }

  // Helper method to get category name
  String _getCategoryName(int index) {
    if (index < _categories.length && _categories[index]['name'] != null) {
      return _categories[index]['name'] as String;
    }
    // Fallback to local translations
    final localNames = _isRTL ? [
      _getText('dietPlans'),
      _getText('healthy'),
      _getText('lifestyle'),
      _getText('gainMuscle'),
    ] : [
      'Diet Plans',
      'Healthy',
      'Lifestyle',
      'Gain Muscle',
    ];
    if (index < localNames.length) {
      return localNames[index];
    }
    return '';
  }

  Future<bool> _loadSvgAsset(BuildContext context, String assetPath) async {
    try {
      await DefaultAssetBundle.of(context).loadString(assetPath);
      developer.log('Successfully loaded SVG: $assetPath', name: 'SVGLoader');
      return true;
    } catch (e) {
      developer.log('Failed to load SVG $assetPath: $e', name: 'SVGLoader');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.75,
      initialPage: 0,
    );
    _languageService.addListener(_onLanguageChanged);
    _loadHomeData();
    _loadFavoriteMealPlans();
  }

  Future<void> _loadFavoriteMealPlans() async {
    try {
      final token = await AuthStorageService.getToken();
      if (token == null || token.isEmpty) {
        return; // User not logged in, skip loading favorites
      }

      final response = await UserService.getFavoriteMealPlans(token: token);
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        if (data['favorites'] != null) {
          final favorites = data['favorites'] as List;
          setState(() {
            _favoriteMealPlanIds = favorites
                .map((fav) => fav['mealPlanId'] as int?)
                .where((id) => id != null)
                .cast<int>()
                .toSet();
          });
        }
      }
    } catch (e) {
      print('Error loading favorite meal plans: $e');
      // Silently fail - favorites are optional
    }
  }

  Future<void> _toggleFavorite(int mealPlanId, String name, String? imageUrl) async {
    print('❤️ HEART CLICKED - MealPlanId: $mealPlanId, Name: $name');
    
    try {
      final token = await AuthStorageService.getToken();
      print('🔑 Token retrieved: ${token != null && token.isNotEmpty ? "Yes" : "No"}');
      
      if (token == null || token.isEmpty) {
        print('❌ No token found - user not logged in');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isRTL ? 'يرجى تسجيل الدخول لإضافة المفضلة' : 'Please login to add favorites'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final isCurrentlyFavorite = _favoriteMealPlanIds.contains(mealPlanId);
      print('⭐ Current favorite status: $isCurrentlyFavorite');
      
      if (!isCurrentlyFavorite) {
        print('➕ Adding to favorites...');
        // Add to favorites
        final response = await UserService.addFavoriteMealPlan(
          token: token,
          mealPlanId: mealPlanId,
          name: name,
          image: imageUrl,
        );

        print('📥 API Response: $response');

        if (response['success'] == true) {
          print('✅ Successfully added to favorites');
          setState(() {
            _favoriteMealPlanIds.add(mealPlanId);
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_isRTL ? 'تمت الإضافة إلى المفضلة' : 'Added to favorites'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          print('❌ API returned success: false');
        }
      } else {
        print('➖ Removing from favorites...');
        // Remove from favorites
        final response = await UserService.removeFavoriteMealPlan(
          token: token,
          mealPlanId: mealPlanId,
        );

        print('📥 API Response: $response');

        if (response['success'] == true) {
          print('✅ Successfully removed from favorites');
          setState(() {
            _favoriteMealPlanIds.remove(mealPlanId);
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_isRTL ? 'تمت الإزالة من المفضلة' : 'Removed from favorites'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          print('❌ API returned success: false');
        }
      }
    } catch (e) {
      print('❌ Error toggling favorite: $e');
      print('❌ Stack trace: ${StackTrace.current}');
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
    }
  }

  Future<void> _loadHomeData({bool isCategoryChange = false}) async {
    setState(() {
      if (isCategoryChange) {
        // Only show loading in meal plans section when category changes
        _isLoadingMealPlans = true;
      } else {
        // Show full page loading only on initial load
      _isLoading = true;
      }
      _error = null;
    });

    try {
      final lang = _languageService.currentLanguage == 'Arabic' ? 'ar' : 'en';
      final categoryId = _selectedCategoryIndex < _categories.length && _categories[_selectedCategoryIndex]['id'] != null
          ? _categories[_selectedCategoryIndex]['id'] as int?
          : null;

      final response = await MealService.getHomeData(
        lang: lang,
        categoryId: categoryId,
        page: 1,
        perPage: 20,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        
        setState(() {
          _greeting = data['greeting'] as String?;
          _bannerUrl = data['banner'] as String?;
          _selectedCategoryId = data['selectedCategoryId'] as int?;
          
          // Parse categories
          if (data['categories'] != null) {
            _categories = List<Map<String, dynamic>>.from(
              (data['categories'] as List).map((cat) => cat as Map<String, dynamic>)
            );
          }
          
          // Parse meal plans
          if (data['mealPlans'] != null && data['mealPlans']['data'] != null) {
            final mealPlansData = data['mealPlans']['data'] as List;
            _mealPlans = mealPlansData.map((plan) {
              final planMap = plan as Map<String, dynamic>;
              
              // Format nutritional info
              final protein = planMap['protein']?.toString() ?? '0';
              final carbs = planMap['carbs']?.toString() ?? '0';
              final kcalMin = planMap['kcalMin']?.toString() ?? '0';
              final kcalMax = planMap['kcalMax']?.toString() ?? '0';
              final kcal = '$kcalMin - $kcalMax';
              
              // Format meal components from mealsCategories
              final mealComponents = <String>[];
              if (planMap['mealsCategories'] != null) {
                final mealsCategories = planMap['mealsCategories'] as List;
                for (var category in mealsCategories) {
                  final catMap = category as Map<String, dynamic>;
                  final name = catMap['name']?.toString() ?? '';
                  final maxLimit = catMap['maxLimit']?.toString() ?? '1';
                  mealComponents.add('$maxLimit $name');
                }
              }
              
              // Get price from pricing array
              String price = 'KD 0.000';
              double priceValue = 0.0;
              int durationDays = 7; // Default to 7 days
              if (planMap['pricing'] != null && (planMap['pricing'] as List).isNotEmpty) {
                final pricing = (planMap['pricing'] as List).first as Map<String, dynamic>;
                priceValue = double.tryParse(pricing['price']?.toString() ?? '0') ?? 0.0;
                durationDays = pricing['days'] as int? ?? 7;
                price = 'KD $priceValue';
              }
              
              return {
                'id': planMap['id'],
                'title': planMap['name']?.toString() ?? '',
                'subtitle': planMap['subtitle']?.toString() ?? planMap['description']?.toString() ?? '',
                'imageUrl': planMap['banner']?.toString(),
                'protein': '${protein}g',
                'carbs': '${carbs}g',
                'kcal': kcal,
                'mealComponents': mealComponents,
                'price': price,
                'priceValue': priceValue,
                'durationDays': durationDays,
              };
            }).toList();
          }
          
          // Update selected category index based on selectedCategoryId
          if (_selectedCategoryId != null) {
            final categoryIndex = _categories.indexWhere((cat) => cat['id'] == _selectedCategoryId);
            if (categoryIndex >= 0) {
              _selectedCategoryIndex = categoryIndex;
            }
          }
          
          // Reset page controller if needed
          if (_mealPlans.isNotEmpty && _pageController.hasClients) {
            final initialPage = _mealPlans.length > 1 ? 1 : 0;
            if (_currentCardIndex >= _mealPlans.length) {
              _currentCardIndex = initialPage;
              _pageController.jumpToPage(initialPage);
            }
          }
          
          _isLoading = false;
          _isLoadingMealPlans = false;
        });
      } else {
        setState(() {
          _error = response['message']?.toString() ?? 'Failed to load home data';
          _isLoading = false;
          _isLoadingMealPlans = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isLoadingMealPlans = false;
      });
      print('Error loading home data: $e');
    }
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    _loadHomeData(isCategoryChange: true); // Reload data when language changes
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    _loadHomeData(isCategoryChange: true); // Reload data when category changes
  }

  Future<void> _handleSubscribe(Map<String, dynamic> mealPlan) async {
    // Navigate to menu page first (as shown in the image)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MenuPage(
          mealPlanId: mealPlan['id'] as int?,
          mealPlanName: mealPlan['title'] as String?,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: _isLoading
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
                        onPressed: _loadHomeData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                        ),
                        child: const Text('Retry', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : Column(
        children: [
          // Top Header with banner from API or fallback to home.svg
          Container(
            width: double.infinity,
            child: _bannerUrl != null && _bannerUrl!.isNotEmpty
                ? Image.network(
                    _bannerUrl!,
                    fit: BoxFit.fill,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return SvgPicture.asset(
                        'assets/svg/Home.svg',
                        fit: BoxFit.fill,
                        placeholderBuilder: (BuildContext context) {
                          return Container(
                            color: const Color(0xFFFF6B35),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : SvgPicture.asset(
                    'assets/svg/Home.svg',
                    fit: BoxFit.fill,
                    placeholderBuilder: (BuildContext context) {
                      return Container(
                        color: const Color(0xFFFF6B35),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // "Need help choosing" Card - Promotional Banner
                  SizedBox(
                    width: double.infinity,
                    child: Builder(
                      builder: (context) {
                        // Use the image's aspect ratio to determine height
                        final screenWidth = MediaQuery.of(context).size.width;
                        final cardHeight = screenWidth / 2.5; // Adjusted to fit content without overflow
                        
                        return Container(
                          width: double.infinity,
                          height: cardHeight,
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0, bottom: 18.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              // Doctor SVG background
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SvgPicture.asset(
                                    'assets/svg/doctor.svg',
                                    fit: BoxFit.cover,
                                    placeholderBuilder: (BuildContext context) {
                                      return Container(
                                        color: const Color(0xFF2A2A2A),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFFFF6B35),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Content overlay
                              Row(
                                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                children: [
                                  // Text content
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: _isRTL ? 0 : 10,
                                        right: _isRTL ? 10 : 0,
                                      ),
                                    child: Column(
                                      crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                          const SizedBox(height: 4),
                                        Text(
                                          _getText('helpTitle'),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                          ),
                                          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                                        ),
                                        Text(
                                          _getText('helpTitle2'),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                          ),
                                          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _getText('helpSubtitle'),
                                          style: const TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 13,
                                            height: 1.3,
                                          ),
                                          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                                        ),
                                        const SizedBox(height: 12),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => const GoalSelectionPage(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 87.0,
                                            height: 28.58,
                                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  Color(0xFFFF722D), // #FF722D
                                                  Color(0xFF99441B), // #99441B
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(14.29),
                                            ),
                                            child: Center(
                                              child: Text(
                                                _getText('letsGo'),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0, bottom: 4.0),
                    child: Column(
                      crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                    // Category Navigation
                    SizedBox(
                      height: 100,
                      child: _categories.isEmpty
                          ? const SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: List.generate(_categories.length, (index) {
                                final isSelected = _selectedCategoryIndex == index;
                                final categoryIcon = _getCategoryIcon(index);
                                final categoryName = _getCategoryName(index);
                                
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => _onCategorySelected(index),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Category Icon above text
                                        categoryIcon.startsWith('http')
                                            ? Image.network(
                                                categoryIcon,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.contain,
                                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                  return const Icon(
                                                    Icons.category,
                                                    color: Color(0xFF9E9E9E),
                                                    size: 30,
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                categoryIcon,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.contain,
                                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                  return const Icon(
                                                    Icons.category,
                                                    color: Color(0xFF9E9E9E),
                                                    size: 30,
                                                  );
                                                },
                                              ),
                                        const SizedBox(height: 8),
                                        // Category Text
                                        Text(
                                          categoryName,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF9E9E9E),
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        // Orange underline for selected
                                        Container(
                                          width: 30,
                                          height: 2,
                                          decoration: BoxDecoration(
                                            color: isSelected
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
                    const SizedBox(height: 8),
                     // Meal Plan Cards - Carousel with scaling effect
                     _isLoadingMealPlans
                         ? const SizedBox(
                             height: 343,
                             child: Center(
                               child: CircularProgressIndicator(
                                 color: Color(0xFFFF6B35),
                               ),
                             ),
                           )
                         : _mealPlans.isEmpty
                         ? const SizedBox(
                             height: 343,
                             child: Center(
                               child: Text(
                                 'No meal plans available',
                                 style: TextStyle(color: Color(0xFF9E9E9E)),
                               ),
                             ),
                           )
                         : SizedBox(
                             height: 343,
                             child: _mealPlans.length == 1
                                 ? Center(
                                     child: _buildCard(0),
                                   )
                                 : PageView.builder(
                                     controller: _pageController,
                                     itemCount: _mealPlans.length,
                                     onPageChanged: (index) {
                                       setState(() {
                                         _currentCardIndex = index;
                                       });
                                     },
                                     itemBuilder: (context, index) {
                                       return _buildCard(index);
                                     },
                                   ),
                           ),
                  ],
                ),
              ),
            ])),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    if (index >= _mealPlans.length) {
      return const SizedBox.shrink();
    }

    final mealPlan = _mealPlans[index];
    
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double scale = 0.85; // Default scale for side cards
        
        if (_pageController.hasClients) {
          final currentPage = _pageController.page ?? index.toDouble();
          final offset = (index - currentPage).abs();
          // Center card (offset = 0) gets scale 1.0, side cards get scale 0.85
          scale = 1.0 - (offset * 0.15).clamp(0.0, 0.15);
        }
        
        final mealPlanId = mealPlan['id'] as int?;
        final isFavorite = mealPlanId != null && _favoriteMealPlanIds.contains(mealPlanId);
        
        print('🎴 Building card for mealPlanId: $mealPlanId, isFavorite: $isFavorite');
        
        return Center(
          child: Transform.scale(
            scale: scale,
            child: MealPlanCard(
              title: mealPlan['title'] as String,
              subtitle: mealPlan['subtitle'] as String,
              imageUrl: mealPlan['imageUrl'] as String?,
              protein: mealPlan['protein'] as String,
              carbs: mealPlan['carbs'] as String,
              kcal: mealPlan['kcal'] as String,
              mealComponents: List<String>.from(mealPlan['mealComponents'] as List),
              price: mealPlan['price'] as String,
              mealPlanId: mealPlanId,
              isFavorite: isFavorite,
              onFavoriteToggle: mealPlanId != null
                  ? () {
                      print('🔄 Callback invoked for mealPlanId: $mealPlanId');
                      _toggleFavorite(
                        mealPlanId,
                        mealPlan['title'] as String,
                        mealPlan['imageUrl'] as String?,
                      );
                    }
                  : null,
              onSubscribe: () {
                _handleSubscribe(mealPlan);
              },
            ),
          ),
        );
      },
    );
  }


}

