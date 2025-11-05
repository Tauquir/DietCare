import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'login_page.dart';
import 'otp_verification_page.dart';
import '../core/auth_api.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _phoneController = TextEditingController(text: '88776644');
  bool _isLoading = false;
  final AuthApi _authApi = AuthApi();
  
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
        const SnackBar(
          content: Text('Please enter your phone number'),
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
      
      // Call send-OTP API
      final result = await _authApi.sendOtp(fullPhoneNumber);

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true && result['userId'] != null) {
        // Navigate to OTP verification screen with userId
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                phoneNumber: fullPhoneNumber,
                userId: result['userId'],
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to send OTP. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Top Banner Section
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/card back.svg',
                    fit: BoxFit.fill,
                  ),
                ),
                // Card Front
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/card front.svg',
                    fit: BoxFit.fill,
                  ),
                ),
                // Overlay Content
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        // Logo positioned absolutely
                        Positioned(
                          top: 83.26,
                          left: 18.84,
                          child: SvgPicture.asset(
                            'assets/newlogo.svg',
                            width: 69.09375,
                            height: 68.86554718017578,
                          ),
                        ),
                      ],
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
              child: Stack(
                children: [
                  // Title positioned absolutely
                  Positioned(
                    top: 7,
                    left: 18,
                    child: Container(
                      width: 363,
                      height: 33,
                      child: const Text(
                        'Create Your Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Onest',
                          height: 0.82, // line-height: 21.44px / font-size: 26px
                          letterSpacing: 0.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Subtitle positioned absolutely
                  Positioned(
                    top: 48,
                    left: 17,
                    child: Container(
                      width: 367,
                      height: 21,
                      child: const Text(
                        'Start your healthy journey with your phone number.',
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Onest',
                          height: 1.43, // line-height: 21.44px / font-size: 15px
                          letterSpacing: 0.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Rest of the form content
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const SizedBox(height: 60),
                    // Phone Number Input
                    Row(
                      children: [
                        // Country Code Dropdown
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
                        // Phone Number Field
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
                              decoration: const InputDecoration(
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Verification Message
                    const Text(
                      'To verify your number, we\'ll send a code to your phone via SMS.',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Send Code Button
                    Center(
                      child: Container(
                        width: 370,
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
                              : const Text(
                                  'SEND CODE',
                                  style: TextStyle(
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
                          text: const TextSpan(
                            style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                  color: Color(0xFFFF6B35),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Legal Text
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: 'By continuing you agree to our\n'),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' | '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
