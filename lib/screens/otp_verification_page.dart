import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'set_password_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  
  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Central Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sms,
                  color: Color(0xFFFF6B35),
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Verify Your Number',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Instructions
              Text(
                'Enter the OTP we sent to your phone to continue.',
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _controllers[index].text.isNotEmpty 
                            ? const Color(0xFFFF6B35) 
                            : const Color(0xFF3A3A3A),
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
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
                      ),
                      onChanged: (value) => _onTextChanged(value, index),
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
      ),
    );
  }

}
