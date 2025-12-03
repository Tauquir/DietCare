import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';
import '../services/language_service.dart';
import '../services/auth_service.dart';
import '../services/auth_storage_service.dart';

class SetPasswordPage extends StatefulWidget {
  final String userId;
  
  const SetPasswordPage({
    super.key,
    required this.userId,
  });

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedGender = 'male'; // 'male' or 'female'
  bool _isLoading = false;
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Set Your Password',
      'subtitle': 'Create a secure password to protect your account.',
      'passwordHint': 'Password',
      'confirmPasswordHint': 'Confirm Password',
      'requirements': 'Use at least 8 characters, including a capital letter, small letter, number, and special character.',
      'submit': 'SUBMIT',
      'fillAllFields': 'Please fill in all fields',
      'passwordsNotMatch': 'Passwords do not match',
      'passwordInvalid': 'Password must be at least 8 characters with capital letter, small letter, number, and special character',
      'passwordSetSuccess': 'Password set successfully!',
      'firstNameHint': 'First Name',
      'lastNameHint': 'Last Name',
      'emailHint': 'Email',
      'ageHint': 'Age',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'completeSignupError': 'Failed to complete signup. Please try again.',
      'completeSignupNetworkError': 'Network error. Please check your connection.',
      'invalidEmail': 'Please enter a valid email address',
      'invalidAge': 'Please enter a valid age',
    },
    'Arabic': {
      'title': 'قم بتعيين كلمة المرور',
      'subtitle': 'أنشئ كلمة مرور آمنة لحماية حسابك.',
      'passwordHint': 'كلمة المرور',
      'confirmPasswordHint': 'تأكيد كلمة المرور',
      'requirements': 'استخدم ما لا يقل عن 8 أحرف، بما في ذلك حرف كبير، رقم، ورمز.',
      'submit': 'إرسال',
      'fillAllFields': 'يرجى ملء جميع الحقول',
      'passwordsNotMatch': 'كلمات المرور غير متطابقة',
      'passwordInvalid': 'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل مع حرف كبير وصغير ورقم ورمز خاص',
      'passwordSetSuccess': 'تم تعيين كلمة المرور بنجاح!',
      'firstNameHint': 'الاسم الأول',
      'lastNameHint': 'اسم العائلة',
      'emailHint': 'البريد الإلكتروني',
      'ageHint': 'العمر',
      'gender': 'الجنس',
      'male': 'ذكر',
      'female': 'أنثى',
      'completeSignupError': 'فشل إكمال التسجيل. يرجى المحاولة مرة أخرى.',
      'completeSignupNetworkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
      'invalidEmail': 'يرجى إدخال عنوان بريد إلكتروني صحيح',
      'invalidAge': 'يرجى إدخال عمر صحيح',
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
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _submitPassword() async {
    // Validate all fields
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showError(_getText('fillAllFields'));
      return;
    }

    if (!_isEmailValid(_emailController.text)) {
      _showError(_getText('invalidEmail'));
      return;
    }

    final age = int.tryParse(_ageController.text);
    if (age == null || age < 1 || age > 150) {
      _showError(_getText('invalidAge'));
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError(_getText('passwordsNotMatch'));
      return;
    }

    if (!_isPasswordValid(_passwordController.text)) {
      _showError(_getText('passwordInvalid'));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call API to complete signup
      final response = await AuthService.completeSignup(
        userId: widget.userId,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        gender: _selectedGender,
        age: age,
      );

      setState(() {
        _isLoading = false;
      });

      // Check if API call was successful
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        final token = data['token'] as String?;
        final user = data['user'] as Map<String, dynamic>?;
        
        // Save token and user ID
        if (token != null) {
          await AuthStorageService.saveToken(token);
        }
        if (user != null && user['id'] != null) {
          await AuthStorageService.saveUserId(user['id'] as String);
        }
        
        // Signup completed successfully, navigate to home page
        _showSuccessAndNavigate();
      } else {
        // Handle API error response
        _showError(response['message'] ?? _getText('completeSignupError'));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Handle network or other errors
      _showError(
        e.toString().contains('Network')
            ? _getText('completeSignupNetworkError')
            : (e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  bool _isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false; // At least one capital letter
    if (!password.contains(RegExp(r'[a-z]'))) return false; // At least one small letter
    if (!password.contains(RegExp(r'[0-9]'))) return false; // At least one number
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false; // At least one special character
    return true;
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getText('passwordSetSuccess')),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate to home page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Password Icon
              SvgPicture.asset(
                'assets/setpassword.svg',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                _getText('title'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Onest',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              // Subtitle
              Text(
                _getText('subtitle'),
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Onest',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // First Name Input
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: TextField(
                  controller: _firstNameController,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: _getText('firstNameHint'),
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Last Name Input
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: TextField(
                  controller: _lastNameController,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: _getText('lastNameHint'),
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Email Input
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: _getText('emailHint'),
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Gender Selection
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = 'male';
                        });
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: _selectedGender == 'male' 
                              ? const Color(0xFFFF6B35).withOpacity(0.2)
                              : const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedGender == 'male'
                                ? const Color(0xFFFF6B35)
                                : const Color(0xFF3A3A3A),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _getText('male'),
                            style: TextStyle(
                              color: _selectedGender == 'male'
                                  ? const Color(0xFFFF6B35)
                                  : Colors.white,
                              fontWeight: _selectedGender == 'male'
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = 'female';
                        });
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: _selectedGender == 'female' 
                              ? const Color(0xFFFF6B35).withOpacity(0.2)
                              : const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedGender == 'female'
                                ? const Color(0xFFFF6B35)
                                : const Color(0xFF3A3A3A),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _getText('female'),
                            style: TextStyle(
                              color: _selectedGender == 'female'
                                  ? const Color(0xFFFF6B35)
                                  : Colors.white,
                              fontWeight: _selectedGender == 'female'
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Age Input
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: _getText('ageHint'),
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Password Input
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: _getText('passwordHint'),
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    prefixIcon: _isRTL ? null : IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF9E9E9E),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    suffixIcon: _isRTL ? IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF9E9E9E),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ) : null,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Confirm Password Input
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: _getText('confirmPasswordHint'),
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    prefixIcon: _isRTL ? null : IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF9E9E9E),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    suffixIcon: _isRTL ? IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF9E9E9E),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ) : null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Password Requirements
              Align(
                alignment: _isRTL ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  _getText('requirements'),
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 12,
                  ),
                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                ),
              ),
              const SizedBox(height: 16),
              // Submit Button
              Center(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFE8347), Color(0xFFA43B08)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25.13),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.13),
                      ),
                      disabledBackgroundColor: Colors.transparent,
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
                            _getText('submit'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

