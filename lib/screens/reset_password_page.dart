import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_page.dart';
import '../services/language_service.dart';
import '../services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  final String phoneNumber;
  final String? userId;
  
  const ResetPasswordPage({
    super.key,
    required this.phoneNumber,
    this.userId,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Reset Your Password',
      'subtitle': 'Create a new secure password for your account.',
      'passwordHint': 'New Password',
      'confirmPasswordHint': 'Confirm New Password',
      'requirements': 'Use at least 8 characters, including a capital letter, small letter, number, and special character.',
      'submit': 'RESET PASSWORD',
      'fillAllFields': 'Please fill in all fields',
      'passwordsNotMatch': 'Passwords do not match',
      'passwordInvalid': 'Password must be at least 8 characters with capital letter, small letter, number, and special character',
      'passwordResetSuccess': 'Password reset successfully!',
      'resetError': 'Failed to reset password. Please try again.',
      'resetNetworkError': 'Network error. Please check your connection.',
    },
    'Arabic': {
      'title': 'إعادة تعيين كلمة المرور',
      'subtitle': 'أنشئ كلمة مرور جديدة آمنة لحسابك.',
      'passwordHint': 'كلمة المرور الجديدة',
      'confirmPasswordHint': 'تأكيد كلمة المرور الجديدة',
      'requirements': 'استخدم ما لا يقل عن 8 أحرف، بما في ذلك حرف كبير، رقم، ورمز.',
      'submit': 'إعادة تعيين كلمة المرور',
      'fillAllFields': 'يرجى ملء جميع الحقول',
      'passwordsNotMatch': 'كلمات المرور غير متطابقة',
      'passwordInvalid': 'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل مع حرف كبير وصغير ورقم ورمز خاص',
      'passwordResetSuccess': 'تم إعادة تعيين كلمة المرور بنجاح!',
      'resetError': 'فشل إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى.',
      'resetNetworkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
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

  bool _isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false; // At least one capital letter
    if (!password.contains(RegExp(r'[a-z]'))) return false; // At least one small letter
    if (!password.contains(RegExp(r'[0-9]'))) return false; // At least one number
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false; // At least one special character
    return true;
  }

  Future<void> _resetPassword() async {
    // Validate all fields
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showError(_getText('fillAllFields'));
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
      // Call API to reset password
      final response = await AuthService.forgotPasswordReset(
        widget.phoneNumber,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      // Check if API call was successful
      if (response['success'] == true && response['data'] != null) {
        // Password reset successfully, navigate to login page
        _showSuccessAndNavigate();
      } else {
        // Handle API error response
        _showError(response['message'] ?? _getText('resetError'));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Handle network or other errors
      _showError(
        e.toString().contains('Network')
            ? _getText('resetNetworkError')
            : (e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getText('passwordResetSuccess')),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate to login page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false, // Remove all previous routes
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
                    onPressed: _isLoading ? null : _resetPassword,
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

