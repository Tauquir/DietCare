import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_page.dart';
import 'main_page.dart';
import 'forgot_password_page.dart';
import '../services/language_service.dart';
import '../services/auth_service.dart';
import '../services/auth_storage_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController(text: '88776644');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'headerTitle': 'Eat Well, Live Better!',
      'headerSubtitle': 'Discover balanced meals tailored to your lifestyle. Log in to start your journey toward healthier choices.',
      'title': "Let's Get Started!",
      'subtitle': 'Quick login with your phone number.',
      'phoneHint': 'Phone Number',
      'emailHint': 'Email Address',
      'passwordHint': 'Password',
      'forgotPassword': 'Forgot Password?',
      'continue': 'CONTINUE',
      'noAccount': "Don't have an account? ",
      'signUp': 'Sign Up',
      'terms': 'By continuing you agree to our\n',
      'termsLink': 'Terms of Service',
      'privacyLink': 'Privacy Policy',
      'fillAllFields': 'Please fill in all fields',
      'loginError': 'Failed to login. Please try again.',
      'loginNetworkError': 'Network error. Please check your connection.',
      'enterPhone': 'Please enter your phone number',
      'enterPassword': 'Please enter your password',
    },
    'Arabic': {
      'headerTitle': 'كل جيدًا، عِش أفضل!',
      'headerSubtitle': 'اكتشف وجبات متوازنة مصممة لمساعدتك على بدء رحلتك نحو خيارات صحية أفضل.',
      'title': 'لنبدأ!',
      'subtitle': 'تسجيل سريع باستخدام رقم هاتفك.',
      'phoneHint': 'رقم الهاتف',
      'emailHint': 'البريد الإلكتروني',
      'passwordHint': 'كلمة المرور',
      'forgotPassword': 'هل نسيت كلمة المرور؟',
      'continue': 'متابعة',
      'noAccount': 'ليس لديك حساب؟ ',
      'signUp': 'سجل الآن',
      'terms': 'بمتابعتك، فإنك توافق على\n',
      'termsLink': 'شروط الخدمة',
      'privacyLink': 'سياسة الخصوصية',
      'fillAllFields': 'يرجى ملء جميع الحقول',
      'loginError': 'فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.',
      'loginNetworkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
      'enterPhone': 'يرجى إدخال رقم هاتفك',
      'enterPassword': 'يرجى إدخال كلمة المرور',
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

  Future<void> _handleLogin() async {
    // Validate inputs - API only requires phone and password
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getText('enterPhone')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getText('enterPassword')),
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
      
      // Call API to login
      final response = await AuthService.login(fullPhoneNumber, _passwordController.text);
      
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
        
        // Login successful, navigate to home page
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        }
      } else {
        // Handle API error response
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? _getText('loginError')),
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
                ? _getText('loginNetworkError')
                : _getText('loginError'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Top Banner Section
          Expanded(
            flex: 2,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner Image - starts from absolute top (including status bar area)
                // SVG dimensions: width 402, height 298
                Positioned(
                  top: -statusBarHeight,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                    width: screenWidth,
                    height: 298, // Fixed height as per SVG dimensions
                    child: SvgPicture.asset(
                      'assets/svg/login.svg',
                      width: screenWidth,
                      height: 298,
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
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
                ),
                // Overlay Content (transparent to show SVG)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          // Logo
                          Align(
                            alignment: _isRTL ? Alignment.topRight : Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 0,
                                right: _isRTL ? 0 : 0,
                                left: _isRTL ? 0 : 0,
                              ),
                              child: SvgPicture.asset(
                                'assets/newlogo.svg',
                                width: 69.09375,
                                height: 68.86554718017578,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Text Overlay
                          Align(
                            alignment: _isRTL ? Alignment.centerRight : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 280,
                                  child: Text(
                                    _getText('headerTitle'),
                                    style: GoogleFonts.onest(
                                      color: Colors.white,
                                      fontSize: 21.98,
                                      fontWeight: FontWeight.w700,
                                      height: 0.98,
                                      letterSpacing: -0.54,
                                    ),
                                    textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 347,
                                  child: Text(
                                    _getText('headerSubtitle'),
                                    style: GoogleFonts.onest(
                                      color: Colors.white,
                                      fontSize: 11.31,
                                      fontWeight: FontWeight.w500,
                                      height: 1.67,
                                      letterSpacing: 0.0,
                                    ),
                                    textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
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
          // Login Form Section
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: const Color(0xFF1A1A1A),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 24.0,
                      bottom: 24.0 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // Title
                    Center(
                      child: SizedBox(
                        width: 256,
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
                    const SizedBox(height: 8),
                    // Subtitle
                    Center(
                      child: SizedBox(
                        width: 319,
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
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
                    const SizedBox(height: 20),
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
                              color: const Color(0xFF9E9E9E),
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
                    // Forgot Password Link
                    Align(
                      alignment: _isRTL ? Alignment.centerLeft : Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          _getText('forgotPassword'),
                          style: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Continue Button
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
                        onPressed: _isLoading ? null : _handleLogin,
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
                                _getText('continue'),
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
                    // Sign Up Link
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const SignupPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(text: _getText('noAccount')),
                              TextSpan(
                                text: _getText('signUp'),
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
                    const SizedBox(height: 100), // Extra space for legal text at bottom
                  ],
                ),
              ),
                  // Legal Text - Fixed at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
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

// Temporary MyHomePage for navigation - this should be moved to a separate file later
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
