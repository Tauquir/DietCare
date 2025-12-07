import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'checkout_page.dart';
import '../services/language_service.dart';
import '../services/subscription_service.dart';
import '../services/auth_storage_service.dart';
import '../services/user_service.dart';

class SubscriptionPage extends StatefulWidget {
  final int? mealPlanId;
  final String? mealPlanName;
  final int? durationDays;
  final double? totalAmount;

  const SubscriptionPage({
    super.key,
    this.mealPlanId,
    this.mealPlanName,
    this.durationDays,
    this.totalAmount,
  });

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final LanguageService _languageService = LanguageService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _nameController = TextEditingController(text: 'Ahmed Rashid');
  final _phoneController = TextEditingController(text: '88776644');
  final _cityController = TextEditingController(text: 'Kuwait City');
  final _blockController = TextEditingController();
  final _streetController = TextEditingController();
  final _avenueController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _flatController = TextEditingController();
  final _instructionsController = TextEditingController();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Where should we deliver?',
      'subtitle': 'Get your meals delivered fast and fresh.',
      'name': 'Name',
      'nameHint': 'Ahmed Rashid',
      'nameError': 'Please enter your name',
      'phoneNumber': 'Phone Number',
      'phoneHint': '88776644',
      'phoneError': 'Please enter phone number',
      'city': 'City',
      'cityHint': 'Kuwait City',
      'cityError': 'Please enter city',
      'block': 'Block',
      'street': 'Street',
      'avenue': 'Avenue',
      'building': 'Building',
      'floor': 'Floor',
      'flat': 'Flat',
      'required': 'Required',
      'deliveryInstructions': 'Delivery Instructions',
      'next': 'NEXT',
    },
    'Arabic': {
      'title': 'أين تريد أن توصل الطلب؟',
      'subtitle': 'احصل على وجباتك طازجة وسريعة.',
      'name': 'الاسم',
      'nameHint': 'الاسم',
      'nameError': 'يرجى إدخال الاسم',
      'phoneNumber': 'رقم الهاتف',
      'phoneHint': '88776644',
      'phoneError': 'يرجى إدخال رقم الهاتف',
      'city': 'المدينة',
      'cityHint': 'مدينة الكويت',
      'cityError': 'يرجى إدخال المدينة',
      'block': 'القطعة',
      'street': 'الشارع',
      'avenue': 'الجادة',
      'building': 'المبنى',
      'floor': 'الطابق',
      'flat': 'الشقة',
      'required': 'مطلوب',
      'deliveryInstructions': 'تعليمات التوصيل',
      'next': 'التالي',
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
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _blockController.dispose();
    _streetController.dispose();
    _avenueController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _flatController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
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
            _isRTL ? Icons.arrow_forward : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section with Icon
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFFFF6B35),
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _getText('title'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getText('subtitle'),
                              style: const TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                      
                      // Full Name Field
                      _buildTextField(
                        controller: _nameController,
                        hint: _getText('nameHint'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _getText('nameError');
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Phone Number Fields (Two Columns)
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF3A3A3A)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('🇰🇼', style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 8),
                                  Text(
                                    '+965',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _phoneController,
                              hint: _getText('phoneHint'),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return _getText('phoneError');
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // City Field
                      _buildTextField(
                        controller: _cityController,
                        hint: _getText('cityHint'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _getText('cityError');
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Address Fields - Row 1
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _blockController,
                              hint: _getText('block'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return _getText('required');
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _streetController,
                              hint: _getText('street'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return _getText('required');
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Address Fields - Row 2
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _avenueController,
                              hint: _getText('avenue'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return _getText('required');
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _buildingController,
                              hint: _getText('building'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return _getText('required');
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Address Fields - Row 3
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _floorController,
                              hint: _getText('floor'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return _getText('required');
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _flatController,
                              hint: _getText('flat'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return _getText('required');
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Delivery Instructions Field
                      _buildTextField(
                        controller: _instructionsController,
                        hint: _getText('deliveryInstructions'),
                        maxLines: 3,
                      ),
                      
                      const SizedBox(height: 100), // Extra space for fixed button
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF6B35),
                Color(0xFFE55A2B),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSubscription,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
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
                    _getText('next'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B35)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              hint: const Text(
                'Select an option',
                style: TextStyle(color: Color(0xFF9E9E9E)),
              ),
              dropdownColor: const Color(0xFF2A2A2A),
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9E9E9E)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubscription() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.mealPlanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal plan information is missing'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get token
      final token = await AuthStorageService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Please login to create subscription');
      }

      // First, create or get address
      String? addressId;
      try {
        // Try to get existing addresses first
        final addressesResponse = await UserService.getAddresses(token: token);
        if (addressesResponse['success'] == true && addressesResponse['data'] != null) {
          final addresses = addressesResponse['data']['addresses'] as List<dynamic>?;
          if (addresses != null && addresses.isNotEmpty) {
            // Use the first address or default address
            final defaultAddress = addresses.firstWhere(
              (addr) => (addr as Map<String, dynamic>)['isDefault'] == true,
              orElse: () => addresses.first,
            ) as Map<String, dynamic>;
            addressId = defaultAddress['id']?.toString();
          }
        }
      } catch (e) {
        print('Error fetching addresses: $e');
      }

      // If no address found, create one
      if (addressId == null) {
        final addressResponse = await UserService.addAddress(
          token: token,
          type: 'home',
          street: _streetController.text.trim().isNotEmpty 
              ? _streetController.text.trim() 
              : '${_blockController.text.trim()} ${_streetController.text.trim()}',
          city: _cityController.text.trim(),
          state: 'Kuwait', // Default state
          zipCode: '00000', // Default zip
          country: 'Kuwait',
          isDefault: true,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          building: _buildingController.text.trim().isNotEmpty ? _buildingController.text.trim() : null,
          floor: _floorController.text.trim().isNotEmpty ? _floorController.text.trim() : null,
          flat: _flatController.text.trim().isNotEmpty ? _flatController.text.trim() : null,
        );

        if (addressResponse['success'] == true && addressResponse['data'] != null) {
          final addressData = addressResponse['data']['address'] as Map<String, dynamic>?;
          addressId = addressData?['id']?.toString();
        }
      }

      if (addressId == null) {
        throw Exception('Failed to create or retrieve address');
      }

      // Calculate dates
      final now = DateTime.now();
      final startDate = now.toIso8601String().split('T')[0]; // Format: YYYY-MM-DD
      final activePlanStartDate = now.add(const Duration(days: 4)).toIso8601String().split('T')[0]; // 4 days from now

      // Create subscription
      final response = await SubscriptionService.createSubscription(
        mealPlanId: widget.mealPlanId!,
        durationDays: widget.durationDays ?? 30,
        startDate: startDate,
        activePlanStartDate: activePlanStartDate,
        totalAmount: widget.totalAmount ?? 0.0,
        addressId: addressId,
        specialInstructions: _instructionsController.text.trim().isNotEmpty 
            ? _instructionsController.text.trim() 
            : null,
        token: token,
      );

      setState(() {
        _isLoading = false;
      });

      if (response['success'] == true) {
        if (mounted) {
          Navigator.of(context).pop(true); // Return true to indicate success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Subscription created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to create subscription');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
