import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/subscription_service.dart';
import '../services/auth_storage_service.dart';
import '../widgets/empty_plans_widget.dart';
import 'main_page.dart';

class MyPlansPage extends StatefulWidget {
  const MyPlansPage({super.key});

  @override
  State<MyPlansPage> createState() => _MyPlansPageState();
}

class _MyPlansPageState extends State<MyPlansPage> {
  final LanguageService _languageService = LanguageService();
  
  // API data state
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _currentPlan;
  List<Map<String, dynamic>> _dailyStatus = [];
  Map<String, Map<String, dynamic>> _statusByDate = {}; // Map date to status

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'myPlans': 'My Plans',
      'zenMealPlan': 'Zen Meal Plan',
      'upcomingMeals': 'Upcoming Meals',
      'previousPlans': 'Past Plans',
      'days': 'DAYS',
      'day': 'day',
      'noActivePlansYet': 'No Active Plans Yet!',
      'explorePlansSubtitle': 'Explore our plans and pick the one that suits you best.',
      'startExploring': 'START EXPLORING',
    },
    'Arabic': {
      'myPlans': 'خططي',
      'zenMealPlan': 'خطة وجبات زن',
      'upcomingMeals': 'الوجبات الجاية',
      'previousPlans': 'الخطط السابقة',
      'days': 'يوم',
      'day': 'يوم',
      'noActivePlansYet': 'لا توجد خطط نشطة بعد!',
      'explorePlansSubtitle': 'استكشف خططنا واختر ما يناسبك.',
      'startExploring': 'ابدأ الاستكشاف',
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
      return '${date.day} ${months[date.month - 1]}, ${date.year}';
    }
  }

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _loadData();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = await AuthStorageService.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
          _error = 'Please login to view your plans';
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
          final startDate = activeSubscription['startDate']?.toString();
          final endDate = activeSubscription['endDate']?.toString();
          
          if (subscriptionId != null && mealPlanId != null && startDate != null && endDate != null) {
            // Store current plan info
            setState(() {
              _currentPlan = {
                'subscriptionId': subscriptionId,
                'mealPlanId': mealPlanId,
                'startDate': startDate,
                'endDate': endDate,
                'mealPlanName': activeSubscription['mealPlan']?['name']?.toString() ?? _getText('zenMealPlan'),
              };
            });
            
            // Fetch daily selection status
            await _loadDailyStatus(subscriptionId, mealPlanId, startDate, endDate, token);
          } else {
            setState(() {
              _isLoading = false;
              _error = 'Invalid subscription data';
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            // No subscriptions - show empty state or default data
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _error = subscriptionsResponse['message']?.toString() ?? 'Failed to load subscriptions';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      print('Error loading plans data: $e');
    }
  }

  Future<void> _loadDailyStatus(
    String subscriptionId,
    int mealPlanId,
    String startDate,
    String endDate,
    String token,
  ) async {
    try {
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
        
        setState(() {
          if (statusList != null) {
            _dailyStatus = statusList.map((item) => item as Map<String, dynamic>).toList();
            
            // Create a map for quick lookup by date
            _statusByDate = {};
            for (var status in _dailyStatus) {
              final date = status['date']?.toString();
              if (date != null) {
                _statusByDate[date] = status;
              }
            }
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = response['message']?.toString() ?? 'Failed to load daily status';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      print('Error loading daily status: $e');
    }
  }

  // Get status for a specific date
  Map<String, dynamic>? _getStatusForDate(String date) {
    return _statusByDate[date];
  }

  // Parse date string to DateTime
  DateTime? _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  // Get day number from date
  int _getDayNumber(DateTime date) {
    return date.day;
  }

  // Get weekday abbreviation from date
  String _getWeekdayAbbr(DateTime date) {
    final weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return weekdays[date.weekday % 7];
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
                        _getText('myPlans'),
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
                                onPressed: _loadData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6B35),
                                ),
                                child: const Text('Retry', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        )
                      : _currentPlan == null
                          ? Center(
                              child: EmptyPlansWidget(
                                title: _getText('noActivePlansYet'),
                                subtitle: _getText('explorePlansSubtitle'),
                                buttonText: _getText('startExploring'),
                                onExplorePlans: () {
                                  // Navigate to home page to explore plans
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const MainPage(),
                                    ),
                                  );
                                },
                                isRTL: _isRTL,
                              ),
                            )
                          : SingleChildScrollView(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image on the LEFT
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/women.png',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 120,
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
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Text content on the RIGHT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                  children: [
                                    Text(
                                      _currentPlan?['mealPlanName']?.toString() ?? _getText('zenMealPlan'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _currentPlan != null && _currentPlan!['startDate'] != null && _currentPlan!['endDate'] != null
                                          ? _formatDateRange(
                                              _formatDateShort(_parseDate(_currentPlan!['startDate']) ?? DateTime.now()),
                                              _formatDateShort(_parseDate(_currentPlan!['endDate']) ?? DateTime.now()),
                                            )
                                          : _formatDateRange(
                                              _formatDateShort(DateTime(2025, 9, 24)),
                                              _formatDateShort(DateTime(2025, 10, 31)),
                                            ),
                                      style: const TextStyle(
                                        color: Color(0xFF9E9E9E),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Progress indicator positioned at bottom right
                          Positioned(
                            bottom: 0,
                            right: _isRTL ? null : 0,
                            left: _isRTL ? 0 : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '24/30 ${_getText('days')}',
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
                      height: 120,
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF6B35),
                              ),
                            )
                          : _buildUpcomingMealsList(),
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

    );
  }

  Widget _buildUpcomingMealsList() {
    // Get next 6 days from today
    final now = DateTime.now();
    final upcomingDays = List.generate(6, (index) {
      return now.add(Duration(days: index));
    });

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      reverse: _isRTL,
      itemCount: upcomingDays.length,
      itemBuilder: (context, index) {
        final date = upcomingDays[index];
        final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final status = _getStatusForDate(dateStr);
        
        // Determine if paused or has meals
        final isPaused = status != null && (status['is_paused'] == 1 || status['is_paused'] == true);
        final hasMeals = status != null && (status['is_selected'] == 1 || status['is_selected'] == true) && !isPaused;
        final dayNumber = date.day;
        final weekdayAbbr = _getWeekdayAbbr(date);
        
        // Find weekday index for display
        final weekdayIndex = _weekDaysEn.indexOf(weekdayAbbr);
        final displayWeekday = weekdayIndex >= 0 ? _weekDays[weekdayIndex] : weekdayAbbr;

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
              // Food cloche icon for meals, pause icon for paused
              if (isPaused)
                const Icon(
                  Icons.pause,
                  color: Colors.white,
                  size: 32,
                )
              else if (hasMeals)
                const Icon(
                  Icons.restaurant_menu,
                  color: Colors.red,
                  size: 32,
                )
              else
                const Icon(
                  Icons.restaurant_menu,
                  color: Colors.grey,
                  size: 32,
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
              const SizedBox(height: 4),
              Text(
                displayWeekday,
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
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
          // Text content on the left
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
          // Jagged tab on the RIGHT with duration
          Container(
            width: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF8B4513),
              borderRadius: _isRTL
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '26',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getText('days'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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

