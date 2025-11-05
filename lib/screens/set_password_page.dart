import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitPassword() {
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    if (!_isPasswordValid(_passwordController.text)) {
      _showError('Password must be at least 8 characters with capital letter, small letter, number, and special character');
      return;
    }

    // Password is valid, show success and navigate to main app
    _showSuccessAndNavigate();
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
      const SnackBar(
        content: Text('Password set successfully!'),
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
        child: Stack(
          children: [
            // Password Icon positioned absolutely
            Positioned(
              top: 101,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  'assets/setpassword.svg',
                  width: 125,
                  height: 125,
                ),
              ),
            ),
            // Title positioned absolutely
            Positioned(
              top: 251,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 256,
                  height: 28,
                  child: const Text(
                    'Set Your Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.38,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Onest',
                      height: 0.81, // line-height: 21.44px / font-size: 26.38px
                      letterSpacing: 0.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Subtitle positioned absolutely
            Positioned(
              top: 284.61,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 319.0874938964844,
                  height: 22,
                  child: const Text(
                    'Create a secure password to protect your account.',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 13.82,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Onest',
                      height: 1.55, // line-height: 21.44px / font-size: 13.82px
                      letterSpacing: -0.54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Rest of the content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 280), // Space for positioned elements
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
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Password',
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
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: IconButton(
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
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password Requirements
              const Text(
                'Use at least 8 characters, including a capital letter, small letter, number, and special character.',
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              // Submit Button
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
                    onPressed: _submitPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.13),
                      ),
                    ),
                    child: const Text(
                      'SUBMIT',
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
              const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

