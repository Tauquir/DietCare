import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import '../services/auth_storage_service.dart';
import '../widgets/empty_favourites_widget.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final LanguageService _languageService = LanguageService();
  
  // API data state
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _favoriteMealPlans = [];

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'favourites': 'Favourites',
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fats': 'Fats',
      'kcal': 'kcal',
      'yourPlateLooksEmpty': 'Your Plate Looks Empty!',
      'startAddingFavourites': 'Start adding your favourite meals to find them easily next time.',
    },
    'Arabic': {
      'favourites': 'المفضلة',
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'fats': 'دهون',
      'kcal': 'كيلو',
      'yourPlateLooksEmpty': 'طبقك يبدو فارغاً!',
      'startAddingFavourites': 'ابدأ بإضافة وجباتك المفضلة للعثور عليها بسهولة في المرة القادمة.',
    },
  };

  String _getText(String key) {
    return _translations[_languageService.currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  bool get _isRTL => _languageService.isRTL;


  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _loadFavoriteMealPlans();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    _loadFavoriteMealPlans();
  }

  Future<void> _loadFavoriteMealPlans() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = await AuthStorageService.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
          _error = 'Please login to view favorites';
        });
        return;
      }

      final response = await UserService.getFavoriteMealPlans(token: token);

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        final favorites = data['favorites'] as List<dynamic>?;
        
        setState(() {
          if (favorites != null) {
            _favoriteMealPlans = favorites.map((item) => item as Map<String, dynamic>).toList();
          } else {
            _favoriteMealPlans = [];
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = response['message']?.toString() ?? 'Failed to load favorites';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      print('Error loading favorite meal plans: $e');
    }
  }

  Future<void> _removeFavorite(int mealPlanId, int index) async {
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

      print('🗑️ Removing favorite meal plan: $mealPlanId');
      final response = await UserService.removeFavoriteMealPlan(
        token: token,
        mealPlanId: mealPlanId,
      );

      print('📥 API Response: $response');

      if (response['success'] == true) {
        print('✅ Successfully removed from favorites');
        setState(() {
          _favoriteMealPlans.removeAt(index);
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response['message']?.toString() ?? 
                (_isRTL ? 'تمت الإزالة من المفضلة' : 'Removed from favorites'),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        print('❌ API returned success: false');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response['message']?.toString() ?? 
                (_isRTL ? 'فشلت العملية' : 'Failed to remove'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error removing favorite: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Custom Header (same as Help Center)
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFF2B2A2A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6.31,
                  spreadRadius: 0,
                  offset: const Offset(0, 0.63),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isRTL ? Icons.arrow_forward : Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        _getText('favourites'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button width
                  ],
                ),
              ),
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
                        onPressed: _loadFavoriteMealPlans,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                        ),
                        child: const Text('Retry', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : _favoriteMealPlans.isEmpty
                  ? Center(
                      child: EmptyFavouritesWidget(
                        title: _getText('yourPlateLooksEmpty'),
                        subtitle: _getText('startAddingFavourites'),
                        isRTL: _isRTL,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _favoriteMealPlans.length,
                      itemBuilder: (context, index) {
                        final mealPlan = _favoriteMealPlans[index];
                        return _buildMealPlanCard(mealPlan, index);
                      },
                    ),
            ),

        ],
      ),
    );
  }

  Widget _buildMealPlanCard(Map<String, dynamic> mealPlan, int index) {
    final mealPlanId = mealPlan['mealPlanId'] as int?;
    final name = mealPlan['name']?.toString() ?? 'Meal Plan';
    final imageUrl = mealPlan['image']?.toString();
    final favoriteId = mealPlan['id']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Image (left in LTR, right in RTL)
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: _isRTL ? const Radius.circular(0) : const Radius.circular(16),
              topRight: _isRTL ? const Radius.circular(16) : const Radius.circular(0),
              bottomLeft: _isRTL ? const Radius.circular(0) : const Radius.circular(16),
              bottomRight: _isRTL ? const Radius.circular(16) : const Radius.circular(0),
            ),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImagePlaceholder();
                    },
                  )
                : _buildImagePlaceholder(),
          ),
          const SizedBox(width: 16),
          // Text content (right in LTR, left in RTL)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Favorite icon button
                  GestureDetector(
                    onTap: mealPlanId != null ? () async {
                      await _removeFavorite(mealPlanId, index);
                    } : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isRTL ? 'إزالة من المفضلة' : 'Remove',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
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
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        color: Color(0xFF3A3A3A),
      ),
      child: const Icon(
        Icons.restaurant_menu,
        color: Color(0xFF9E9E9E),
        size: 40,
      ),
    );
  }
}

