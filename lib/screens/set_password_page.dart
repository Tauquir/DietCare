import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';
import '../services/language_service.dart';
import '../services/auth_service.dart';
import '../services/auth_storage_service.dart';

class SetPasswordPage extends StatefulWidget {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  
  const SetPasswordPage({
    super.key,
    required this.userId,
    this.firstName,
    this.lastName,
    this.email,
  });

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Set Your Password',
      'subtitle': 'Create a secure password to protect your account.',
      'passwordHint': 'Password',
      'confirmPasswordHint': 'Confirm Password',
      'requirements': 'Use at least 8 characters, including a capital letter, number, and symbol.',
      'proceed': 'PROCEED',
      'passwordsNotMatch': 'Passwords do not match',
      'passwordInvalid': 'Password must be at least 8 characters with capital letter, number, and symbol',
      'passwordSetSuccess': 'Password set successfully!',
      'setPasswordError': 'Failed to set password. Please try again.',
      'setPasswordNetworkError': 'Network error. Please check your connection.',
    },
    'Arabic': {
      'title': 'قم بتعيين كلمة المرور',
      'subtitle': 'أنشئ كلمة مرور آمنة لحماية حسابك.',
      'passwordHint': 'كلمة المرور',
      'confirmPasswordHint': 'تأكيد كلمة المرور',
      'requirements': 'استخدم ما لا يقل عن 8 أحرف، بما في ذلك حرف كبير ورقم ورمز.',
      'proceed': 'متابعة',
      'passwordsNotMatch': 'كلمات المرور غير متطابقة',
      'passwordInvalid': 'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل مع حرف كبير ورقم ورمز',
      'passwordSetSuccess': 'تم تعيين كلمة المرور بنجاح!',
      'setPasswordError': 'فشل تعيين كلمة المرور. يرجى المحاولة مرة أخرى.',
      'setPasswordNetworkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
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
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  Future<void> _submitPassword() async {
    // Validate password fields
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showError(_getText('passwordsNotMatch'));
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
      // Call API to complete signup with only firstName, lastName, email, password
      final response = await AuthService.completeSignup(
        userId: widget.userId,
        firstName: widget.firstName ?? '',
        lastName: widget.lastName ?? '',
        email: widget.email ?? '',
        password: _passwordController.text,
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
        
        // Password set successfully, navigate to home page
        _showSuccessAndNavigate();
      } else {
        // Handle API error response
        _showError(response['message'] ?? _getText('setPasswordError'));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Handle network or other errors
      _showError(
        e.toString().contains('Network')
            ? _getText('setPasswordNetworkError')
            : (e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  bool _isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false; // At least one capital letter
    if (!password.contains(RegExp(r'[0-9]'))) return false; // At least one number
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false; // At least one symbol
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
        builder: (context) => const MainPage(),
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
                'assets/svg/password.svg',
                width: 125,
                height: 125,
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                _getText('title'),
                style: GoogleFonts.onest(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                _getText('subtitle'),
                style: GoogleFonts.onest(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Password Input
              Container(
                height: 56,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Confirm Password Input
              Container(
                height: 56,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
              const Spacer(),
              // Proceed Button
              Center(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF722D), Color(0xFFB34712)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
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
                            _getText('proceed'),
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

