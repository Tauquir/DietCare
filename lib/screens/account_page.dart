import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'my_plans_page.dart';
import 'about_app_page.dart';
import 'favourites_page.dart';
import 'help_center_page.dart';
import 'calendar_page.dart';
import 'edit_profile_page.dart';
import 'address_page.dart';
import 'login_page.dart';
import 'language_selection_page.dart';
import '../widgets/language_selection_dialog.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import '../services/auth_storage_service.dart';
import '../services/auth_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final LanguageService _languageService = LanguageService();
  bool _isLoading = true;
  Map<String, dynamic>? _profile;

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'userName': 'Abdul Rashid',
      'editProfile': 'EDIT PROFILE',
      'favorites': 'Favourites',
      'myAddress': 'My Address',
      'myPlans': 'My Plans',
      'totalCalories': 'Total Calories',
      'calories': 'KCAL',
      'caloriesUnit': 'calories',
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fats': 'Fats',
      'update': 'UPDATE',
      'otherInformation': 'Other Information',
      'language': 'Language',
      'aboutApp': 'About App',
      'helpCenter': 'Help Center',
      'logout': 'LOG OUT',
      'followUsOn': 'FOLLOW US ON',
      'bringFriends': 'Bring Friends Onboard!',
      'shareApp': 'Share the app and inspire healthier choices.',
      'shareNow': 'SHARE NOW',
      'profileInformation': 'Profile Information',
      'email': 'Email',
      'gender': 'Gender',
      'age': 'Age',
      'height': 'Height',
      'weight': 'Weight',
      'targetWeight': 'Target Weight',
      'activityLevel': 'Activity Level',
      'dietaryPreferences': 'Dietary Preferences',
      'allergies': 'Allergies',
      'medicalConditions': 'Medical Conditions',
      'referralCode': 'Referral Code',
      'otpVerified': 'OTP Verified',
      'notSet': 'Not Set',
      'yes': 'Yes',
      'no': 'No',
      'male': 'Male',
      'female': 'Female',
    },
    'Arabic': {
      'userName': 'عبد الرشيد',
      'editProfile': 'تعديل الملف الشخصي',
      'favorites': 'المفضلة',
      'myAddress': 'عنواني',
      'myPlans': 'خططي',
      'totalCalories': 'مجموع السعرات',
      'calories': 'سعرة',
      'caloriesUnit': 'سعرة',
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'fats': 'دهون',
      'update': 'تحديث',
      'otherInformation': 'معلومات ثانية',
      'language': 'اللغة',
      'aboutApp': 'عن التطبيق',
      'helpCenter': 'مركز المساعدة',
      'logout': 'تسجيل الخروج',
      'followUsOn': 'تابعنا على',
      'bringFriends': 'أحضر الأصدقاء!',
      'shareApp': 'شارك التطبيق وألهم خيارات صحية أفضل.',
      'shareNow': 'شارك الآن',
      'profileInformation': 'معلومات الملف الشخصي',
      'email': 'البريد الإلكتروني',
      'gender': 'الجنس',
      'age': 'العمر',
      'height': 'الطول',
      'weight': 'الوزن',
      'targetWeight': 'الوزن المستهدف',
      'activityLevel': 'مستوى النشاط',
      'dietaryPreferences': 'التفضيلات الغذائية',
      'allergies': 'الحساسية',
      'medicalConditions': 'الحالات الطبية',
      'referralCode': 'رمز الإحالة',
      'otpVerified': 'تم التحقق من OTP',
      'notSet': 'غير محدد',
      'yes': 'نعم',
      'no': 'لا',
      'male': 'ذكر',
      'female': 'أنثى',
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
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get token from storage
      final token = await AuthStorageService.getToken();
      
      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please login to view your profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // Call API to fetch account details with goal=lifestyle
      final response = await UserService.getAccountDetails(token: token, goal: 'lifestyle');
      
      // Debug: Print full response
      print('API Response: $response');
      
      setState(() {
        _isLoading = false;
      });

      // Check if API call was successful
      if (response['success'] == true && response['data'] != null) {
        final accountData = response['data'] as Map<String, dynamic>;
        
        // Parse and map the account details to profile format
        // Construct name from firstName and lastName
        final firstName = accountData['firstName']?.toString() ?? '';
        final lastName = accountData['lastName']?.toString() ?? '';
        final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
        
        // Map account details to profile format for UI compatibility
        final profile = {
          'name': fullName.isNotEmpty ? fullName : null,
          'firstName': accountData['firstName'],
          'lastName': accountData['lastName'],
          'email': accountData['email'],
          'phone': accountData['phone'],
          'phoneCode': accountData['phoneCode'],
          'gender': accountData['gender'],
          'age': accountData['age'],
          'height': accountData['height'],
          'weight': accountData['weight'],
          'targetWeight': accountData['targetWeight'],
          'activityLevel': accountData['activityLevel'],
          'dietaryPreferences': accountData['dietaryPreferences'],
          'allergies': accountData['allergies'],
          'medicalConditions': accountData['medicalConditions'],
          'addresses': accountData['addresses'],
          'bmi': accountData['bmi'],
          'bmr': accountData['bmr'],
          'tdee': accountData['tdee'],
          'calorieConsumption': accountData['calorieConsumption'],
          'activityFactor': accountData['activityFactor'],
          'goal': accountData['goal'],
          'cmsPages': accountData['cmsPages'],
        };
        
        // Debug: Print profile object
        print('Profile object: $profile');
        
          setState(() {
            _profile = profile;
          });
          // Debug: Print profile data
          print('Profile loaded - Name: ${_profile?['name']}, Phone: ${_profile?['phone']}');
          print('Gender: ${_profile?['gender']}, Age: ${_profile?['age']}');
        print('Calorie Consumption: ${_profile?['calorieConsumption']}');
          print('Full profile: $_profile');
      } else {
        print('API call failed or data is null. Response: $response');
        // Handle API error response
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to load profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Debug: Print error
      print('Error fetching profile: $e');
      
      // Handle network or other errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('Network') 
                ? 'Network error. Please check your connection.'
                : 'Failed to load profile: ${e.toString()}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  String _formatPhoneNumber(String phone) {
    // Format phone number with space after country code
    // Example: +96599699277 -> +965 99699277
    if (phone.length > 4 && phone.startsWith('+')) {
      return '${phone.substring(0, 4)} ${phone.substring(4)}';
    }
    return phone;
  }

  String _formatNumber(dynamic value) {
    // Format number with comma separators
    if (value == null) return '0';
    final numValue = value is num ? value : (double.tryParse(value.toString()) ?? 0);
    return numValue.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String? _formatValue(dynamic value, {String? unit}) {
    if (value == null) return null;
    // Handle empty strings
    if (value is String && value.trim().isEmpty) return null;
    // Handle numeric values
    if (value is num) {
      final stringValue = value.toString();
      if (unit != null) {
        return '$stringValue $unit';
      }
      return stringValue;
    }
    // Handle string values
    final stringValue = value.toString().trim();
    if (stringValue.isEmpty) return null;
    if (unit != null) {
      return '$stringValue $unit';
    }
    return stringValue;
  }

  String? _formatGender(dynamic gender) {
    if (gender == null) return null;
    final genderStr = gender.toString().trim().toLowerCase();
    if (genderStr.isEmpty) return null;
    if (genderStr == 'male') return _getText('male');
    if (genderStr == 'female') return _getText('female');
    // Capitalize first letter for display
    return genderStr[0].toUpperCase() + genderStr.substring(1);
  }

  String? _formatBoolean(dynamic value) {
    if (value == null) return null;
    if (value == true) return _getText('yes');
    if (value == false) return _getText('no');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Top Header - Orange Gradient Background (starts from top)
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: statusBarHeight + 20, bottom: 30, left: 24, right: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B35),
                  Color(0xFFE55A2B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        _isLoading
                            ? const SizedBox(
                                height: 28,
                                width: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                (_profile != null && _profile!['name'] != null && (_profile!['name'] as String).isNotEmpty)
                                  ? (_profile!['name'] as String)
                                  : _getText('userName'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                              ),
                        const SizedBox(height: 8),
                        _isLoading
                            ? const SizedBox(height: 16)
                            : Text(
                                (_profile != null && _profile!['phone'] != null && (_profile!['phone'] as String).isNotEmpty)
                                  ? _formatPhoneNumber(_profile!['phone'] as String)
                                  : '+965 88776643',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                              ),
                      ],
                    ),
                  ),
                  // Edit Button on the right
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            initialProfile: _profile,
                          ),
                        ),
                      );
                      if (result == true) {
                        _fetchProfile();
                      }
                    },
                    child: Container(
                      width: 83,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7D3918),
                        borderRadius: BorderRadius.circular(25.13),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 25.13,
                            spreadRadius: 0,
                            offset: const Offset(0, 2.51),
                            blurStyle: BlurStyle.inner,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Edit',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Bring Friends Onboard!" Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getText('bringFriends'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getText('shareApp'),
                              style: const TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 14,
                              ),
                              textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle share action
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF722D),
                                          Color(0xFFB34712),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                      children: [
                                        const Icon(
                                          Icons.share,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _getText('shareNow').toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Placeholder for illustration - you can replace with actual image
                                Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3A3A3A),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.people,
                                    color: Color(0xFF9E9E9E),
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Quick Action Buttons Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          _buildQuickActionButtonWithSvg(
                            'assets/svg/myplan.svg',
                            _getText('myPlans'),
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const MyPlansPage(),
                                ),
                              );
                            },
                          ),
                          _buildQuickActionButtonWithSvg(
                            'assets/svg/myaddress.svg',
                            _getText('myAddress'),
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AddressPage(),
                                ),
                              );
                            },
                          ),
                          _buildQuickActionButtonWithSvg(
                            'assets/svg/fav.svg',
                            _getText('favorites'),
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const FavouritesPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Total Calories Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Text(
                              _getText('totalCalories'),
                              style: const TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                  children: [
                                    Text(
                                      _profile != null && _profile!['calorieConsumption'] != null
                                          ? _formatNumber(_profile!['calorieConsumption'])
                                          : '1,674',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _getText('calories'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1D1D1D),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.local_fire_department,
                                    color: Color(0xFFFF6B35),
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Macronutrient breakdown with colored vertical bars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                _buildMacroItemWithBar(_getText('protein'), '21g', Colors.green),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                _buildMacroItemWithBar(_getText('carbs'), '21g', const Color(0xFF4FC3F7)),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                _buildMacroItemWithBar(_getText('fats'), '21g', const Color(0xFF1976D2)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  // Handle update action
                                },
                                child: Container(
                                  width: 142,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFFF722D),
                                      width: 1.26,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getText('update').toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Other Information Section
                      Text(
                        _getText('otherInformation'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoItemWithSvg('assets/svg/languagesmall.svg', _getText('language'), () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => const LanguageSelectionDialog(),
                        );
                      }),
                      _buildInfoItemWithSvg('assets/svg/aboutapp.svg', _getText('aboutApp'), () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AboutAppPage(),
                          ),
                        );
                      }),
                      _buildInfoItemWithSvg('assets/svg/help.svg', _getText('helpCenter'), () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HelpCenterPage(),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      // Logout Button
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            // Show confirmation dialog
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xFF2A2A2A),
                                title: Text(
                                  _getText('logout'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                content: Text(
                                  _isRTL 
                                    ? 'هل أنت متأكد من أنك تريد تسجيل الخروج؟'
                                    : 'Are you sure you want to log out?',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text(
                                      _isRTL ? 'إلغاء' : 'Cancel',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Log Out',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            
                            if (shouldLogout == true) {
                              try {
                                // Get token before clearing
                                final token = await AuthStorageService.getToken();
                                
                                // Call logout API if token exists
                                if (token != null && token.isNotEmpty) {
                                  try {
                                    await AuthService.logout(token: token);
                                  } catch (e) {
                                    // Log error but continue with logout
                                    print('Error calling logout API: $e');
                                  }
                                }
                                
                              // Clear authentication data
                              await AuthStorageService.clearAuth();
                              
                              if (mounted) {
                                // Navigate to login page and clear navigation stack
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                  (route) => false,
                                );
                                }
                              } catch (e) {
                                // Even if API call fails, clear local storage and navigate
                                await AuthStorageService.clearAuth();
                                
                                if (mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                    (route) => false,
                                  );
                                }
                              }
                            }
                          },
                          child: Container(
                            width: 370,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(25.13),
                            ),
                            child: Center(
                              child: Text(
                                _getText('logout'),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Follow Us On Section
                      Row(
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFF3A3A3A),
                            ),
                          ),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              _getText('followUsOn'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFF3A3A3A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIconInstagram(), // Instagram with gradient
                          const SizedBox(width: 24),
                          _buildSocialIconTikTok(), // TikTok
                          const SizedBox(width: 24),
                          _buildSocialIconSnapchat(), // Snapchat
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtonWithSvg(String svgPath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SvgPicture.asset(
                svgPath,
                width: 32,
                height: 32,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value) {
    return Column(
      crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
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

  Widget _buildMacroItemWithBar(String label, String value, Color barColor) {
    return Row(
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3,
          height: 30,
          margin: EdgeInsets.only(
            right: _isRTL ? 0 : 8,
            left: _isRTL ? 8 : 0,
            top: 2,
          ),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        Column(
          crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
            Icon(
              _isRTL ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItemWithSvg(String svgPath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
            Icon(
              _isRTL ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }

  Widget _buildSocialIconInstagram() {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF4D4D4D),
          width: 1.2,
        ),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/svg/instagram.svg',
        width: 75,
        height: 75,
      ),
    );
  }

  Widget _buildSocialIconTikTok() {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF4D4D4D),
          width: 1.2,
        ),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/svg/tiktok.svg',
        width: 75,
        height: 75,
      ),
    );
  }

  Widget _buildSocialIconSnapchat() {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF4D4D4D),
          width: 1.2,
        ),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/svg/snap.svg',
        width: 75,
        height: 75,
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, dynamic value) {
    final displayValue = value != null 
        ? (value is String ? value : value.toString())
        : _getText('notSet');
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 14,
              ),
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              displayValue,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              textAlign: _isRTL ? TextAlign.right : TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

}

