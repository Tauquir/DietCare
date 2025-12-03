import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import '../services/auth_storage_service.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic>? initialProfile;

  const EditProfilePage({
    super.key,
    this.initialProfile,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final LanguageService _languageService = LanguageService();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  String _selectedActivityLevel = 'moderate';
  bool _isLoading = false;

  // Activity level options
  final List<String> _activityLevels = [
    'sedentary',
    'light',
    'moderate',
    'active',
    'very_active',
  ];

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'editProfile': 'Edit Profile',
      'height': 'Height (cm)',
      'weight': 'Weight (kg)',
      'targetWeight': 'Target Weight (kg)',
      'activityLevel': 'Activity Level',
      'save': 'SAVE',
      'cancel': 'CANCEL',
      'updateSuccess': 'Profile updated successfully',
      'updateError': 'Failed to update profile',
      'networkError': 'Network error. Please check your connection.',
      'enterHeight': 'Please enter height',
      'enterWeight': 'Please enter weight',
      'enterTargetWeight': 'Please enter target weight',
      'invalidHeight': 'Height must be between 50 and 300 cm',
      'invalidWeight': 'Weight must be between 10 and 500 kg',
      'invalidTargetWeight': 'Target weight must be between 10 and 500 kg',
      'sedentary': 'Sedentary',
      'light': 'Light',
      'moderate': 'Moderate',
      'active': 'Active',
      'veryActive': 'Very Active',
    },
    'Arabic': {
      'editProfile': 'تعديل الملف الشخصي',
      'height': 'الطول (سم)',
      'weight': 'الوزن (كجم)',
      'targetWeight': 'الوزن المستهدف (كجم)',
      'activityLevel': 'مستوى النشاط',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'updateSuccess': 'تم تحديث الملف الشخصي بنجاح',
      'updateError': 'فشل تحديث الملف الشخصي',
      'networkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
      'enterHeight': 'يرجى إدخال الطول',
      'enterWeight': 'يرجى إدخال الوزن',
      'enterTargetWeight': 'يرجى إدخال الوزن المستهدف',
      'invalidHeight': 'يجب أن يكون الطول بين 50 و 300 سم',
      'invalidWeight': 'يجب أن يكون الوزن بين 10 و 500 كجم',
      'invalidTargetWeight': 'يجب أن يكون الوزن المستهدف بين 10 و 500 كجم',
      'sedentary': 'قليل النشاط',
      'light': 'خفيف',
      'moderate': 'معتدل',
      'active': 'نشط',
      'veryActive': 'نشط جداً',
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
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.initialProfile != null) {
      _heightController.text = widget.initialProfile!['height']?.toString() ?? '';
      _weightController.text = widget.initialProfile!['weight']?.toString() ?? '';
      _targetWeightController.text = widget.initialProfile!['targetWeight']?.toString() ?? '';
      _selectedActivityLevel = widget.initialProfile!['activityLevel']?.toString() ?? 'moderate';
    }
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  Future<void> _saveProfile() async {
    // Validate fields
    if (_heightController.text.isEmpty) {
      _showError(_getText('enterHeight'));
      return;
    }

    if (_weightController.text.isEmpty) {
      _showError(_getText('enterWeight'));
      return;
    }

    if (_targetWeightController.text.isEmpty) {
      _showError(_getText('enterTargetWeight'));
      return;
    }

    final height = int.tryParse(_heightController.text);
    final weight = int.tryParse(_weightController.text);
    final targetWeight = int.tryParse(_targetWeightController.text);

    if (height == null || height < 50 || height > 300) {
      _showError(_getText('invalidHeight'));
      return;
    }

    if (weight == null || weight < 10 || weight > 500) {
      _showError(_getText('invalidWeight'));
      return;
    }

    if (targetWeight == null || targetWeight < 10 || targetWeight > 500) {
      _showError(_getText('invalidTargetWeight'));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get token from storage
      final token = await AuthStorageService.getToken();

      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        _showError('Please login to update profile');
        return;
      }

      // Call API to update profile
      final response = await UserService.updateProfile(
        token: token,
        height: height,
        weight: weight,
        targetWeight: targetWeight,
        activityLevel: _selectedActivityLevel,
      );

      setState(() {
        _isLoading = false;
      });

      // Check if API call was successful
      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getText('updateSuccess')),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back and refresh
          Navigator.of(context).pop(true);
        }
      } else {
        _showError(response['message'] ?? _getText('updateError'));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showError(
        e.toString().contains('Network')
            ? _getText('networkError')
            : _getText('updateError'),
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getActivityLevelLabel(String level) {
    switch (level.toLowerCase()) {
      case 'sedentary':
        return _getText('sedentary');
      case 'light':
        return _getText('light');
      case 'moderate':
        return _getText('moderate');
      case 'active':
        return _getText('active');
      case 'very_active':
        return _getText('veryActive');
      default:
        return level;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            _isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _getText('editProfile'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Height Field
              Text(
                _getText('height'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '175',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 24),

              // Weight Field
              Text(
                _getText('weight'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '80',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 24),

              // Target Weight Field
              Text(
                _getText('targetWeight'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _targetWeightController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '75',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 24),

              // Activity Level Dropdown
              Text(
                _getText('activityLevel'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedActivityLevel,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  dropdownColor: const Color(0xFF2A2A2A),
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items: _activityLevels.map((String level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(
                        _getActivityLevelLabel(level),
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedActivityLevel = newValue;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: const Color(0xFF3A3A3A),
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
                          _getText('save'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

