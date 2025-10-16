import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'login_page.dart';
import 'otp_verification_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _phoneController = TextEditingController(text: '88776644');

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
                SvgPicture.asset(
                  'assets/topbanner.svg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
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
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo
                          SvgPicture.asset(
                            'assets/logo.svg',
                            width: 60,
                            height: 60,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
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
          // Signup Form Section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: const Color(0xFF1A1A1A),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Create Your Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    const Text(
                      'Start your healthy journey with your phone number.',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Phone Number Input
                    Row(
                      children: [
                        // Country Code
                        Container(
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
                              const Text('🇰🇼', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              const Text(
                                '+965',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFE55A2B)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to OTP verification screen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OtpVerificationPage(
                                phoneNumber: _phoneController.text,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
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
            ),
          ),
        ],
      ),
    );
  }
}
