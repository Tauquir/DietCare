import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'login_page.dart';
import 'otp_verification_page.dart';
import '../services/language_service.dart';
import '../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: '88776644');
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Create Your Account',
      'subtitle': 'Start your healthy journey with your phone number.',
      'firstNameHint': 'First Name',
      'lastNameHint': 'Last Name',
      'phoneHint': 'Phone Number',
      'emailHint': 'Email Address',
      'verificationMessage': 'Get a code via SMS to verify your number.',
      'sendCode': 'SEND CODE',
      'alreadyHaveAccount': 'Already have an account? ',
      'logIn': 'Log In',
      'terms': 'By continuing you agree to our\n',
      'termsLink': 'Terms of Service',
      'privacyLink': 'Privacy Policy',
      'enterPhone': 'Please enter your phone number',
      'otpError': 'Failed to send OTP. Please try again.',
      'networkError': 'Network error. Please check your connection.',
    },
    'Arabic': {
      'title': 'إنشاء حسابك',
      'subtitle': 'ابدأ رحلتك الصحية برقم هاتفك.',
      'firstNameHint': 'الاسم الأول',
      'lastNameHint': 'اسم العائلة',
      'phoneHint': 'رقم الهاتف',
      'emailHint': 'البريد الإلكتروني',
      'verificationMessage': 'احصل على رمز عبر الرسائل النصية للتحقق من رقمك.',
      'sendCode': 'إرسال الرمز',
      'alreadyHaveAccount': 'هل لديك حساب بالفعل؟ ',
      'logIn': 'تسجيل الدخول',
      'terms': 'بمتابعتك، فإنك توافق على\n',
      'termsLink': 'شروط الخدمة',
      'privacyLink': 'سياسة الخصوصية',
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  // Country code options
  final List<Map<String, dynamic>> _countries = [
    {'code': '+965', 'icon': 'assets/svg/arabic.svg', 'name': 'Kuwait'},
    {'code': '+91', 'icon': 'assets/svg/english.svg', 'name': 'India'},
    {'code': '+1', 'icon': 'assets/svg/english.svg', 'name': 'USA'},
    {'code': '+971', 'icon': 'assets/svg/arabic.svg', 'name': 'UAE'},
    {'code': '+966', 'icon': 'assets/svg/arabic.svg', 'name': 'Saudi Arabia'},
  ];

  Map<String, dynamic> _selectedCountry = {'code': '+965', 'icon': 'assets/svg/arabic.svg', 'name': 'Kuwait'};

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

      // Call API to send OTP
      final response = await AuthService.sendOtp(fullPhoneNumber);

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

  // @override
  // void dispose() {
  //   _phoneController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Top Banner Section
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                // Banner Image
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/svg/signup.svg',
                    fit: BoxFit.fill,
                    placeholderBuilder: (BuildContext context) {
                      return Container(
                        color: const Color(0xFF1B1B1B),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Overlay Content (transparent to show image)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SafeArea(
                    child: Align(
                      alignment: _isRTL ? Alignment.topRight : Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          right: _isRTL ? 18.84 : 0,
                          left: _isRTL ? 0 : 18.84,
                        ),
                        child: SvgPicture.asset(
                          'assets/newlogo.svg',
                          width: 69.09375,
                          height: 68.86554718017578,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Curved Separator
          Container(
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          // Signup Form Section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: const Color(0xFF1A1A1A),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 7.0,
                  bottom: 24.0 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                    Center(
                    child: SizedBox(
                      width: 363,
                      child: Text(
                        _getText('title'),
                        style: GoogleFonts.onest(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          height: 0.82,
                          letterSpacing: 0.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                    const SizedBox(height: 13),
                  // Subtitle
                    Center(
                      child: Text(
                        _getText('subtitle'),
                        style: GoogleFonts.onest(
                          color: const Color(0xFF9E9E9E),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                          letterSpacing: 0.0,
                        ),
                        textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                    const SizedBox(height: 24),
                    // First Name and Last Name Inputs
                    Row(
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        // First Name Field
                        Expanded(
                          child: Container(
                            height: 56,
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
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Last Name Field
                        Expanded(
                          child: Container(
                            height: 56,
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
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                                      leading: SvgPicture.asset(
                                        country['icon']!,
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
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
                                SvgPicture.asset(
                                  _selectedCountry['icon']!,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain,
                                ),
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
                                      leading: SvgPicture.asset(
                                        country['icon']!,
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
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
                                SvgPicture.asset(
                                  _selectedCountry['icon']!,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain,
                                ),
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
                    const SizedBox(height: 16),
                    // Email Input
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF3A3A3A)),
                      ),
                      child: TextField(
                        controller: _emailController,
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: _getText('emailHint'),
                          hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Verification Message
                    Text(
                      _getText('verificationMessage'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                    ),
                    const SizedBox(height: 32),
                    // Send Code Button
                    Center(
                      child: Container(
                        width: 370,
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
                    const SizedBox(height: 16),
                    // Login Link
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(text: _getText('alreadyHaveAccount')),
                              TextSpan(
                                text: _getText('logIn'),
                                style: const TextStyle(
                                  color: Color(0xFFFF6B35),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Legal Text
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: _getText('terms')),
                            TextSpan(
                              text: _getText('termsLink'),
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' | '),
                            TextSpan(
                              text: _getText('privacyLink'),
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
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
          ),
        ],
      ),
    );
  }
}
