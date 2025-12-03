import 'package:flutter/material.dart';
import 'my_plans_page.dart';
import 'about_app_page.dart';
import 'favourites_page.dart';
import 'help_center_page.dart';
import 'home_page.dart';
import 'calendar_page.dart';
import 'edit_profile_page.dart';
import 'address_page.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import '../services/auth_storage_service.dart';

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
      'logout': 'Logout',
      'followUsOn': 'FOLLOW US ON',
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
      
      // Call API to fetch profile with token
      final response = await UserService.getProfile(token: token);
      
      // Debug: Print full response
      print('API Response: $response');
      
      setState(() {
        _isLoading = false;
      });

      // Check if API call was successful
      if (response['success'] == true && response['data'] != null) {
        final profile = response['data']['profile'] as Map<String, dynamic>?;
        
        // Debug: Print profile object
        print('Profile object: $profile');
        
        if (profile != null) {
          setState(() {
            _profile = profile;
          });
          // Debug: Print profile data
          print('Profile loaded - Name: ${_profile?['name']}, Phone: ${_profile?['phone']}');
          print('Gender: ${_profile?['gender']}, Age: ${_profile?['age']}');
          print('Full profile: $_profile');
        } else {
          print('Profile is null in response');
        }
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
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header - Orange Gradient Background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 30),
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
              child: Column(
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
                        ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            initialProfile: _profile,
                          ),
                        ),
                      );
                      // Refresh profile if updated
                      if (result == true) {
                        _fetchProfile();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFF6B35)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getText('editProfile'),
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
                      // Quick Actions Section
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          _buildQuickActionButton(
                            Icons.favorite,
                            _getText('favorites'),
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const FavouritesPage(),
                                ),
                              );
                            },
                          ),
                          _buildQuickActionButton(
                            Icons.location_on,
                            _getText('myAddress'),
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AddressPage(),
                                ),
                              );
                            },
                          ),
                          _buildQuickActionButton(
                            Icons.bookmark,
                            _getText('myPlans'),
                            () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const MyPlansPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Total Calories Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(16),
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: Color(0xFFFF6B35),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '1,674',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _getText('caloriesUnit'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Macronutrient breakdown
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                _buildMacroItem(_getText('fats'), '21g', Colors.blue),
                                _buildMacroItem(_getText('carbs'), '21g', Colors.blue),
                                _buildMacroItem(_getText('protein'), '21g', Colors.green),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFFF6B35)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getText('update'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Profile Information Section
                      Text(
                        _getText('profileInformation'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileInfoRow(_getText('email'), _formatValue(_profile?['email'])),
                            _buildProfileInfoRow(_getText('gender'), _formatGender(_profile?['gender'])),
                            _buildProfileInfoRow(_getText('age'), _formatValue(_profile?['age'])),
                            _buildProfileInfoRow(_getText('height'), _formatValue(_profile?['height'], unit: 'cm')),
                            _buildProfileInfoRow(_getText('weight'), _formatValue(_profile?['weight'], unit: 'kg')),
                            _buildProfileInfoRow(_getText('targetWeight'), _formatValue(_profile?['targetWeight'], unit: 'kg')),
                            _buildProfileInfoRow(_getText('activityLevel'), _formatValue(_profile?['activityLevel'])),
                            _buildProfileInfoRow(_getText('dietaryPreferences'), _formatValue(_profile?['dietaryPreferences'])),
                            _buildProfileInfoRow(_getText('allergies'), _formatValue(_profile?['allergies'])),
                            _buildProfileInfoRow(_getText('medicalConditions'), _formatValue(_profile?['medicalConditions'])),
                            _buildProfileInfoRow(_getText('referralCode'), _formatValue(_profile?['referralCode'])),
                            _buildProfileInfoRow(_getText('otpVerified'), _formatBoolean(_profile?['otpVerified'])),
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
                      _buildInfoItem(Icons.language, _getText('language'), () {}),
                      _buildInfoItem(Icons.info_outline, _getText('aboutApp'), () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AboutAppPage(),
                          ),
                        );
                      }),
                      _buildInfoItem(Icons.headset_mic, _getText('helpCenter'), () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HelpCenterPage(),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      // Logout Button
                      GestureDetector(
                        onTap: () {
                          // Handle logout
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            _getText('logout'),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                          _buildSocialIcon(Icons.photo_camera, Colors.purple), // Snapchat
                          const SizedBox(width: 24),
                          _buildSocialIcon(Icons.music_note, Colors.white), // TikTok
                          const SizedBox(width: 24),
                          _buildSocialIcon(Icons.photo, Colors.yellow), // Instagram
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        initialIndex: 2,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const CalendarPage(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
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
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value, Color indicatorColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: indicatorColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
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

