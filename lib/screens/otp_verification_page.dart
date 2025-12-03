import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'set_password_page.dart';
import 'reset_password_page.dart';
import '../services/language_service.dart';
import '../services/auth_service.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String? userId; // Optional userId from send-OTP response
  final bool isForgotPassword; // Indicates if this is for password reset
  
  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    this.userId,
    this.isForgotPassword = false,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final LanguageService _languageService = LanguageService();
  bool _isResending = false;
  bool _isVerifying = false;
  String? _currentUserId;

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Verify Your Number',
      'instructions': 'Enter the code sent to your phone to continue.',
      'didntReceive': "Didn't receive OTP? ",
      'resend': 'Resend OTP',
      'otpVerified': 'OTP verified successfully!',
      'invalidOtp': 'Invalid OTP. Please try again.',
      'otpResent': 'OTP resent successfully!',
      'resendError': 'Failed to resend OTP. Please try again.',
      'resendNetworkError': 'Network error. Please check your connection.',
      'verifyError': 'Failed to verify OTP. Please try again.',
      'verifyNetworkError': 'Network error. Please check your connection.',
    },
    'Arabic': {
      'title': 'تحقق من رقمك',
      'instructions': 'أدخل الرمز المرسل إلى هاتفك للمتابعة.',
      'didntReceive': 'لم تستلم الرمز؟ ',
      'resend': 'أعد الإرسال',
      'otpVerified': 'تم التحقق من الرمز بنجاح!',
      'invalidOtp': 'رمز غير صحيح. يرجى المحاولة مرة أخرى.',
      'otpResent': 'تم إعادة إرسال الرمز بنجاح!',
      'resendError': 'فشل إعادة إرسال الرمز. يرجى المحاولة مرة أخرى.',
      'resendNetworkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
      'verifyError': 'فشل التحقق من الرمز. يرجى المحاولة مرة أخرى.',
      'verifyNetworkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
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
    _currentUserId = widget.userId;
    // Auto-focus the first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  void _onTextChanged(String value, int index) {
    if (value.length == 1) {
      // Move to next field immediately
      if (index < 5) {
        // Use a microtask to ensure focus happens after text is set
        Future.microtask(() {
          if (mounted) {
            _focusNodes[index + 1].requestFocus();
          }
        });
      } else {
        // All fields filled, verify OTP
        Future.microtask(() {
          _verifyOtp();
        });
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on backspace
      Future.microtask(() {
        if (mounted) {
          _focusNodes[index - 1].requestFocus();
        }
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (_isVerifying) return;
    
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length != 6) return;

    setState(() {
      _isVerifying = true;
    });

    try {
      // Call appropriate API based on flow type
      final response = widget.isForgotPassword
          ? await AuthService.forgotPasswordVerifyOtp(widget.phoneNumber, otp)
          : await AuthService.verifyOtp(widget.phoneNumber, otp);
      
      setState(() {
        _isVerifying = false;
      });

      // Check if API call was successful
      if (response['success'] == true && response['data'] != null) {
        final userId = response['data']['userId'] as String?;
        
        // Update userId if provided
        if (userId != null) {
          setState(() {
            _currentUserId = userId;
          });
        }
        
        // OTP is correct, navigate to appropriate page
        _showSuccessAndNavigate();
      } else {
        // Handle API error response
        _showError(response['message'] ?? _getText('verifyError'));
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
      });
      
      // Handle network or other errors
      _showError(
        e.toString().contains('Network') 
          ? _getText('verifyNetworkError')
          : (e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  void _showSuccessAndNavigate() {
    // Show success message and navigate to appropriate page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getText('otpVerified')),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate to appropriate page based on flow type
    if (widget.isForgotPassword) {
      // Navigate to reset password page for forgot password flow
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(
            phoneNumber: widget.phoneNumber,
            userId: _currentUserId ?? widget.userId,
          ),
        ),
      );
    } else {
      // Navigate to set password page for signup flow
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SetPasswordPage(userId: _currentUserId ?? widget.userId ?? ''),
        ),
      );
    }
  }

  void _showError([String? errorMessage]) {
    // Show error message and clear OTP fields
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage ?? _getText('invalidOtp')),
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

  Future<void> _resendOtp() async {
    if (_isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      // Call appropriate API based on flow type
      final response = widget.isForgotPassword
          ? await AuthService.forgotPasswordSendOtp(widget.phoneNumber)
          : await AuthService.resendOtp(widget.phoneNumber);
      
      setState(() {
        _isResending = false;
      });

      // Check if API call was successful
      if (response['success'] == true && response['data'] != null) {
        final userId = response['data']['userId'] as String?;
        
        // Update userId if provided
        if (userId != null) {
          setState(() {
            _currentUserId = userId;
          });
        }
        
        // Clear OTP fields
        for (var controller in _controllers) {
          controller.clear();
        }
        
        // Focus back to first field
        _focusNodes[0].requestFocus();
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getText('otpResent')),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Handle API error response
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? _getText('resendError')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isResending = false;
      });
      
      // Handle network or other errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('Network') 
                ? _getText('resendNetworkError')
                : _getText('resendError'),
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
                  child: SizedBox(
                  width: 256,
                  child: Text(
                    _getText('title'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Onest',
                      height: 0.82,
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
                child: SizedBox(
                  width: 370,
                  child: Text(
                    _getText('instructions'),
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Onest',
                      height: 1.43,
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
                 children: List.generate(6, (index) {
                   return Container(
                     width: 48,
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
              GestureDetector(
                onTap: _isResending ? null : _resendOtp,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(text: _getText('didntReceive')),
                      TextSpan(
                        text: _isResending ? '...' : _getText('resend'),
                        style: TextStyle(
                          color: _isResending 
                            ? const Color(0xFF9E9E9E)
                            : const Color(0xFFFF6B35),
                          decoration: _isResending 
                            ? TextDecoration.none
                            : TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
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
