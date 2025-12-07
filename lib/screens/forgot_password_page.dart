import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_verification_page.dart';
import '../services/language_service.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Forgot Password',
      'subtitle': 'Enter your phone number to receive a password reset code.',
      'phoneHint': 'Phone Number',
      'sendCode': 'SEND CODE',
      'enterPhone': 'Please enter your phone number',
      'otpError': 'Failed to send OTP. Please try again.',
      'networkError': 'Network error. Please check your connection.',
    },
    'Arabic': {
      'title': 'نسيت كلمة المرور',
      'subtitle': 'أدخل رقم هاتفك لتلقي رمز إعادة تعيين كلمة المرور.',
      'phoneHint': 'رقم الهاتف',
      'sendCode': 'إرسال الرمز',
      'enterPhone': 'يرجى إدخال رقم هاتفك',
      'otpError': 'فشل إرسال الرمز. يرجى المحاولة مرة أخرى.',
      'networkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
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
    _phoneController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }
  
  // Country code options
  final List<Map<String, String>> _countries = [
    {'code': '+965', 'flag': '🇰🇼', 'name': 'Kuwait'},
    {'code': '+91', 'flag': '🇮🇳', 'name': 'India'},
    {'code': '+1', 'flag': '🇺🇸', 'name': 'USA'},
    {'code': '+971', 'flag': '🇦🇪', 'name': 'UAE'},
    {'code': '+966', 'flag': '🇸🇦', 'name': 'Saudi Arabia'},
  ];
  
  Map<String, String> _selectedCountry = {'code': '+965', 'flag': '🇰🇼', 'name': 'Kuwait'};

  Future<void> _sendOtp() async {
    // Validate phone number
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getText('enterPhone')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Format phone number with country code
      final fullPhoneNumber = '${_selectedCountry['code']}${_phoneController.text}';
      
      // Call API to send password reset OTP
      final response = await AuthService.forgotPasswordSendOtp(fullPhoneNumber);
      
      setState(() {
        _isLoading = false;
      });

      // Check if API call was successful
      if (response['success'] == true && response['data'] != null) {
        final userId = response['data']['userId'] as String?;
        
        // Navigate to OTP verification screen with userId
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                phoneNumber: fullPhoneNumber,
                userId: userId,
                isForgotPassword: true,
              ),
            ),
          );
        }
      } else {
        // Handle API error response
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? _getText('otpError')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Handle network or other errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('Network') 
                ? _getText('networkError')
                : _getText('otpError'),
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Icon
              SvgPicture.asset(
                'assets/svg/password.svg',
                width: 80,
                height: 80,
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
              const SizedBox(height: 12),
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
              const SizedBox(height: 40),
              // Phone Number Input
              Row(
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: _isRTL ? [
                  // Country Code Dropdown (will appear on right due to RTL)
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFF2A2A2A),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9E9E9E),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              ..._countries.map((country) => ListTile(
                                leading: Text(
                                  country['flag']!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                title: Text(
                                  country['name']!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: Text(
                                  country['code']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedCountry = country;
                                  });
                                  Navigator.pop(context);
                                },
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF3A3A3A)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_selectedCountry['flag']!, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            _selectedCountry['code']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Phone Number Field (will appear on left due to RTL)
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF3A3A3A)),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: _getText('phoneHint'),
                          hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ] : [
                  // Country Code Dropdown (on left for LTR)
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFF2A2A2A),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9E9E9E),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              ..._countries.map((country) => ListTile(
                                leading: Text(
                                  country['flag']!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                title: Text(
                                  country['name']!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: Text(
                                  country['code']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedCountry = country;
                                  });
                                  Navigator.pop(context);
                                },
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF3A3A3A)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_selectedCountry['flag']!, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            _selectedCountry['code']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Phone Number Field (on right for LTR)
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF3A3A3A)),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: _getText('phoneHint'),
                          hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Send Code Button
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
                    onPressed: _isLoading ? null : _sendOtp,
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
                            _getText('sendCode'),
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

