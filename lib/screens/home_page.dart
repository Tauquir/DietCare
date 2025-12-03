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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  int _selectedBottomNavIndex = 0;
  int _currentCardIndex = 1; // Start with center card focused
  final PageController _pageController = PageController(
    viewportFraction: 0.75,
    initialPage: 1,
  );
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'headerLine1': 'Effortless',
      'headerLine2': 'Healthy Eating!',
      'helpTitle': 'Need help choosing the right meal?',
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
      'helpTitle': 'تحتاج مساعدة في اختيار الوجبة المناسبة؟',
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

  List<String> get _categories => _isRTL ? [
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

  final List<String> _categoryIcons = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
  ];

  // Sample data - will be replaced with backend data
  List<Map<String, dynamic>> get _mealPlans => [
    {
      'title': _getText('zenMealPlan'),
      'subtitle': _getText('zenSubtitle'),
      'imageUrl': null, // Will come from backend
      'protein': '21g',
      'carbs': '60g',
      'kcal': '1000 - 1200',
      'mealComponents': [
        '1 ${_getText('breakfast')}',
        '2 ${_getText('mainCourse')}',
        '1 ${_getText('soupSnack')}',
        '1 ${_getText('saladDrink')}',
      ],
      'price': 'KD 20.000',
    },
    {
      'title': _getText('zenMealPlan'),
      'subtitle': _getText('zenSubtitle'),
      'imageUrl': null,
      'protein': '21g',
      'carbs': '60g',
      'kcal': '1000 - 1200',
      'mealComponents': [
        '1 ${_getText('breakfast')}',
        '2 ${_getText('mainCourse')}',
        '1 ${_getText('soupSnack')}',
        '1 ${_getText('saladDrink')}',
      ],
      'price': 'KD 20.000',
    },
    {
      'title': _getText('zenMealPlan'),
      'subtitle': _getText('zenSubtitle'),
      'imageUrl': null,
      'protein': '21g',
      'carbs': '60g',
      'kcal': '1000 - 1200',
      'mealComponents': [
        '1 ${_getText('breakfast')}',
        '2 ${_getText('mainCourse')}',
        '1 ${_getText('soupSnack')}',
        '1 ${_getText('saladDrink')}',
      ],
      'price': 'KD 20.000',
    },
  ];

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
    _languageService.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Top Header with Home.png background
          Container(
            width: double.infinity,
            child: Image.asset(
              'assets/Home.png',
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Container(
                  color: const Color(0xFFFF6B35),
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.red),
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
                        // Adjusted to avoid overflow - making it taller
                        final screenWidth = MediaQuery.of(context).size.width;
                        final cardHeight = screenWidth / 2.0;
                        
                        return Container(
                          width: double.infinity,
                          height: cardHeight,
                          padding: const EdgeInsets.only(left: 36.0, right: 36.0, top: 36.0, bottom: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              // Doctor PNG background
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'assets/doctor.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                      return Container(
                                        color: const Color(0xFF2A2A2A),
                                        child: const Center(
                                          child: Icon(Icons.error, color: Colors.red),
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
                                    child: Column(
                                      crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
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
                                        const SizedBox(height: 8),
                                        Text(
                                          _getText('helpSubtitle'),
                                          style: const TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 13,
                                            height: 1.3,
                                          ),
                                          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                                        ),
                                        const SizedBox(height: 16),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: List.generate(_categories.length, (index) {
                          final isSelected = _selectedCategoryIndex == index;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategoryIndex = index;
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Category Icon above text
                                  Image.asset(
                                    _categoryIcons[index],
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                      return const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 30,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  // Category Text
                                  Text(
                                    _categories[index],
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
                                  // const SizedBox(height: 4),
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
                     SizedBox(
                       height: 343,
                       child: PageView.builder(
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
      bottomNavigationBar: CustomBottomNavigationBar(
        initialIndex: _selectedBottomNavIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
          
          // Handle navigation
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CalendarPage(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AccountPage(),
              ),
            );
          }
        },
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
            ),
          ),
        );
      },
    );
  }


}
