import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'set_password_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String? userId; // Optional userId from send-OTP response
  
  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    this.userId,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Auto-focus the first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(String value, int index) {
    if (value.length == 1) {
      // Move to next field
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // All fields filled, verify OTP
        _verifyOtp();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on backspace
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp() {
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == 4) {
      // Test OTP - for development purposes
      if (otp == '1234') {
        // OTP is correct, navigate to main app
        _showSuccessAndNavigate();
      } else {
        // OTP is incorrect, show error
        _showError();
      }
    }
  }

  void _showSuccessAndNavigate() {
    // Show success message and navigate to main app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP verified successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate to password setting screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SetPasswordPage(),
      ),
    );
  }

  void _showError() {
    // Show error message and clear OTP fields
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid OTP. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
    
    // Clear all OTP fields
    for (var controller in _controllers) {
      controller.clear();
    }
    
    // Focus back to first field
    _focusNodes[0].requestFocus();
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
            // Central Icon positioned absolutely
            Positioned(
              top: 101,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  'assets/verifynumber.svg',
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
                    'Verify Your Number',
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
            ),
            // Instructions positioned absolutely
            Positioned(
              top: 287,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 370,
                  height: 22,
                  child: const Text(
                    'Enter the OTP we sent to your phone to continue.',
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
            ),
            // Rest of the content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 300), // Space for positioned elements
               // OTP Input Fields
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: List.generate(4, (index) {
                   return Container(
                     width: 82.93103790283203,
                     height: 62,
                     decoration: BoxDecoration(
                       color: const Color(0xFF2A2A2A),
                       borderRadius: BorderRadius.circular(12.56),
                       border: Border.all(
                         color: _controllers[index].text.isNotEmpty 
                             ? const Color(0xFFFF6B35) 
                             : const Color(0xFF7A7A7A),
                         width: 1.26,
                       ),
                     ),
                    child: Center(
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: (value) => _onTextChanged(value, index),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              // Resend OTP
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(text: "Didn't receive OTP? "),
                    TextSpan(
                      text: 'Resend OTP',
                      style: TextStyle(
                        color: Color(0xFFFF6B35),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
