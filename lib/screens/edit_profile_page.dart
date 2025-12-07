import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import '../services/auth_storage_service.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic>? initialProfile;

  const EditProfilePage({
    super.key,
    this.initialProfile,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final LanguageService _languageService = LanguageService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: '88776644');
  final TextEditingController _emailController = TextEditingController();
  String _selectedCountryCode = '+965'; // Kuwait
  bool _isLoading = false;

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'editProfile': 'Edit Profile',
      'firstName': 'First Name',
      'lastName': 'Last Name',
      'emailAddress': 'Email Address',
      'save': 'SAVE',
      'deleteAccount': 'DELETE ACCOUNT',
      'updateSuccess': 'Profile updated successfully',
      'updateError': 'Failed to update profile',
      'networkError': 'Network error. Please check your connection.',
      'enterFirstName': 'Please enter first name',
      'enterLastName': 'Please enter last name',
      'enterEmail': 'Please enter email address',
      'invalidEmail': 'Please enter a valid email address',
    },
    'Arabic': {
      'editProfile': 'تعديل الملف الشخصي',
      'firstName': 'الاسم الأول',
      'lastName': 'اسم العائلة',
      'emailAddress': 'البريد الإلكتروني',
      'save': 'حفظ',
      'deleteAccount': 'حذف الحساب',
      'updateSuccess': 'تم تحديث الملف الشخصي بنجاح',
      'updateError': 'فشل تحديث الملف الشخصي',
      'networkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
      'enterFirstName': 'يرجى إدخال الاسم الأول',
      'enterLastName': 'يرجى إدخال اسم العائلة',
      'enterEmail': 'يرجى إدخال البريد الإلكتروني',
      'invalidEmail': 'يرجى إدخال بريد إلكتروني صحيح',
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
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.initialProfile != null) {
      final name = widget.initialProfile!['name']?.toString() ?? '';
      if (name.isNotEmpty) {
        final nameParts = name.split(' ');
        _firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
        _lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      }
      _phoneController.text = widget.initialProfile!['phone']?.toString() ?? '88776644';
      _emailController.text = widget.initialProfile!['email']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  Future<void> _saveProfile() async {
    // Validate fields
    if (_firstNameController.text.trim().isEmpty) {
      _showError(_getText('enterFirstName'));
      return;
    }

    if (_lastNameController.text.trim().isEmpty) {
      _showError(_getText('enterLastName'));
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showError(_getText('enterEmail'));
      return;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      _showError(_getText('invalidEmail'));
      return;
    }

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
        _showError('Please login to update profile');
        return;
      }

      // Get existing profile data for fields not in the edit form
      final initialProfile = widget.initialProfile ?? {};
      
      // Call API to update profile
      final response = await UserService.updateProfile(
        token: token,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        height: initialProfile['height'] as int?,
        weight: initialProfile['weight'] as int?,
        targetWeight: initialProfile['targetWeight'] as int?,
        activityLevel: initialProfile['activityLevel']?.toString(),
        dietaryPreferences: initialProfile['dietaryPreferences']?.toString(),
        allergies: initialProfile['allergies']?.toString(),
        medicalConditions: initialProfile['medicalConditions']?.toString(),
        gender: initialProfile['gender']?.toString(),
        age: initialProfile['age'] as int?,
      );

      setState(() {
        _isLoading = false;
      });

      // Check if API call was successful
      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getText('updateSuccess')),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back and refresh
          Navigator.of(context).pop(true);
        }
      } else {
        _showError(response['message'] ?? _getText('updateError'));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showError(
        e.toString().contains('Network')
            ? _getText('networkError')
            : _getText('updateError'),
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteAccountDialog() {
    showModalBottomSheet(
      context: context,
        backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1B1B1B),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
                    ),
        child: SafeArea(
          child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                    // Delete account icon
                    SvgPicture.asset(
                      'assets/svg/deleteacc.svg',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 24),
                    // Heading
                    Text(
                      _isRTL ? 'حذف حسابك؟' : 'Delete Your Account?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      _isRTL
                          ? 'سيؤدي هذا إلى إزالة حسابك وجميع بياناتك بشكل دائم. لا يمكن التراجع عن هذا الإجراء.'
                          : 'This will permanently remove your account and all your data. This action cannot be undone.',
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Delete Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _deleteAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: const Color(0xFF3A3A3A),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                _isRTL ? 'حذف الحساب' : 'DELETE ACCOUNT',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                const SizedBox(height: 16),
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2A2A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isRTL ? 'إلغاء' : 'CANCEL',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Bottom padding for safe area
                SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthStorageService.getToken();

      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        _showError('Please login to delete account');
        Navigator.of(context).pop(); // Close dialog
        return;
      }

      final response = await AuthService.deleteAccount(token: token);

      setState(() {
        _isLoading = false;
      });

      if (response['success'] == true) {
        // Close dialog
        if (mounted) {
          Navigator.of(context).pop(); // Close delete dialog
          
          // Clear authentication data
          await AuthStorageService.clearAuth();
          
          // Navigate to login page and clear navigation stack
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response['data']?['message']?.toString() ?? 
                (_isRTL ? 'تم حذف الحساب بنجاح' : 'Account deleted successfully'),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        Navigator.of(context).pop(); // Close dialog
        _showError(response['message']?.toString() ?? 'Failed to delete account');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        _showError(
          e.toString().contains('Network')
              ? _getText('networkError')
              : e.toString().replaceFirst('Exception: ', ''),
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
          onPressed: () => Navigator.of(context).pop(),
        ),
                    Expanded(
                      child: Text(
          _getText('editProfile'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Profile Picture
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/edit.svg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),

              // First Name and Last Name Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _firstNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: _getText('firstName'),
                        hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _lastNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: _getText('lastName'),
                        hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Phone Number Row with Country Code
              Row(
                children: [
                  // Country Code Selector
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        isExpanded: true,
                        dropdownColor: const Color(0xFF2A2A2A),
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9E9E9E), size: 20),
                        items: [
                          DropdownMenuItem(
                            value: '+965',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Kuwait flag emoji or icon
                                  const Text('🇰🇼', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 4),
                                  const Text('+965', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCountryCode = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Phone Number Field
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: '88776644',
                        hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email Address Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: _getText('emailAddress'),
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 40),

              // Save Button
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : _saveProfile,
                  child: Container(
                    width: 370,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: _isLoading ? null : const LinearGradient(
                        colors: [
                          Color(0xFFFE8347),
                          Color(0xFFA43B08),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      color: _isLoading ? const Color(0xFF3A3A3A) : null,
                      borderRadius: BorderRadius.circular(25.13),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              _getText('save'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Delete Account Button
              Center(
                child: GestureDetector(
                  onTap: _showDeleteAccountDialog,
                  child: Container(
                    width: 370,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(25.13),
                    ),
                    child: Center(
                      child: Text(
                        _getText('deleteAccount'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
          ),
        ],
      ),
    );
  }
}
