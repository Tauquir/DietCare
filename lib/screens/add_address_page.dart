import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import '../services/auth_storage_service.dart';

class AddAddressPage extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? street;
  final String? fullAddress;

  const AddAddressPage({
    super.key,
    this.latitude,
    this.longitude,
    this.address,
    this.street,
    this.fullAddress,
  });

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final LanguageService _languageService = LanguageService();
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: '88776644');
  final TextEditingController _townCityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _avenueController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  
  String _selectedCountryCode = '+965';
  String _selectedTownCity = '';
  bool _isLoading = false;
  bool _isDefault = false;

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Add Address',
      'addressName': 'Address Name',
      'fullName': 'Full Name',
      'townCity': 'Town City',
      'street': 'Street',
      'avenue': 'Avenue',
      'building': 'Building',
      'floor': 'Floor',
      'flat': 'Flat',
      'state': 'State/Province',
      'zipCode': 'Zip Code',
      'isDefault': 'Set as Default Address',
      'saveAddress': 'SAVE ADDRESS',
      'change': 'CHANGE',
      'deliveringTo': 'Delivering healthy meals to',
      'saveSuccess': 'Address saved successfully',
      'saveError': 'Failed to save address',
      'networkError': 'Network error. Please check your connection.',
      'enterStreet': 'Please enter street address',
      'enterCity': 'Please enter city',
      'enterState': 'Please enter state/province',
      'enterZipCode': 'Please enter zip code',
    },
    'Arabic': {
      'title': 'إضافة عنوان',
      'addressName': 'اسم العنوان',
      'fullName': 'الاسم الكامل',
      'townCity': 'المدينة',
      'street': 'الشارع',
      'avenue': 'الجادة',
      'building': 'المبنى',
      'floor': 'الطابق',
      'flat': 'الشقة',
      'state': 'الولاية/المحافظة',
      'zipCode': 'الرمز البريدي',
      'isDefault': 'تعيين كعنوان افتراضي',
      'saveAddress': 'حفظ العنوان',
      'change': 'تغيير',
      'deliveringTo': 'توصيل الوجبات الصحية إلى',
      'saveSuccess': 'تم حفظ العنوان بنجاح',
      'saveError': 'فشل حفظ العنوان',
      'networkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
      'enterStreet': 'يرجى إدخال عنوان الشارع',
      'enterCity': 'يرجى إدخال المدينة',
      'enterState': 'يرجى إدخال الولاية/المحافظة',
      'enterZipCode': 'يرجى إدخال الرمز البريدي',
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
    // Pre-fill address from location selection if provided
    if (widget.address != null && widget.address!.isNotEmpty) {
      _townCityController.text = widget.address!.split(',')[0].trim();
    }
    if (widget.street != null && widget.street!.isNotEmpty) {
      _streetController.text = widget.street!;
    }
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _addressNameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _townCityController.dispose();
    _streetController.dispose();
    _avenueController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _flatController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  Future<void> _saveAddress() async {
    // Validate required fields according to API spec
    if (_streetController.text.trim().isEmpty) {
      _showError(_getText('enterStreet'));
      return;
    }

    if (_townCityController.text.trim().isEmpty) {
      _showError(_getText('enterCity'));
      return;
    }

    if (_stateController.text.trim().isEmpty) {
      _showError(_getText('enterState'));
      return;
    }

    if (_zipCodeController.text.trim().isEmpty) {
      _showError(_getText('enterZipCode'));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthStorageService.getToken();

      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        _showError('Please login to save address');
        return;
      }

      // Build street address from form fields
      // Combine: street, avenue, building, floor, flat
      final streetParts = [
        _streetController.text.trim(),
        if (_avenueController.text.trim().isNotEmpty) _avenueController.text.trim(),
        if (_buildingController.text.trim().isNotEmpty) 'Building ${_buildingController.text.trim()}',
        if (_floorController.text.trim().isNotEmpty) 'Floor ${_floorController.text.trim()}',
        if (_flatController.text.trim().isNotEmpty) 'Flat ${_flatController.text.trim()}',
      ].where((part) => part.isNotEmpty).toList();
      
      final streetAddress = streetParts.join(', ');

      // Call API to save address with required fields according to API spec
      final response = await UserService.addAddress(
        token: token,
        type: 'home',
        street: streetAddress,
        city: _townCityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        country: 'Kuwait',
        isDefault: _isDefault,
        // Optional fields (if API supports them)
        latitude: widget.latitude,
        longitude: widget.longitude,
        addressName: _addressNameController.text.trim().isNotEmpty ? _addressNameController.text.trim() : null,
        fullName: _fullNameController.text.trim().isNotEmpty ? _fullNameController.text.trim() : null,
        phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        building: _buildingController.text.trim().isNotEmpty ? _buildingController.text.trim() : null,
        floor: _floorController.text.trim().isNotEmpty ? _floorController.text.trim() : null,
        flat: _flatController.text.trim().isNotEmpty ? _flatController.text.trim() : null,
      );

      setState(() {
        _isLoading = false;
      });

      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getText('saveSuccess')),
              backgroundColor: Colors.green,
            ),
          );
          // Pop back to AddressPage
          // If we have location data, we came from LocationSelectionPage, so pop twice
          // Otherwise, we came directly, so pop once
          if (widget.latitude != null && widget.longitude != null) {
            // Came from LocationSelectionPage -> pop twice to get back to AddressPage
            Navigator.of(context).pop(); // Pop AddAddressPage
            Navigator.of(context).pop(); // Pop LocationSelectionPage
          } else {
            // Came directly from AddressPage -> pop once
            Navigator.of(context).pop();
          }
        }
      } else {
        _showError(response['message'] ?? _getText('saveError'));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showError(
        e.toString().contains('Network')
            ? _getText('networkError')
            : _getText('saveError'),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3A3A3A),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: suffix,
        ),
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back button and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isRTL ? Icons.arrow_forward : Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  Expanded(
                    child: Text(
                      _getText('title'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 56), // Balance the back button width
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address display card (only show if location data is provided)
                    if (widget.address != null && widget.address!.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          // Navigate back to location selection to change location
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            // Location icon
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B1B1B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFFFF6B35),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Address text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.address!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                  ),
                                  if (widget.street != null && widget.street!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.street!,
                                      style: const TextStyle(
                                        color: Color(0xFF9E9E9E),
                                        fontSize: 12,
                                      ),
                                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                  ],
                                  if (widget.fullAddress != null && widget.fullAddress!.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.fullAddress!,
                                      style: const TextStyle(
                                        color: Color(0xFF9E9E9E),
                                        fontSize: 12,
                                      ),
                                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Change button
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B1B1B),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getText('change'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                    if (widget.address != null && widget.address!.isNotEmpty)
                      const SizedBox(height: 24),
                    // Address Name
                    _buildTextField(
                      controller: _addressNameController,
                      hintText: _getText('addressName'),
                    ),
                    const SizedBox(height: 16),
                    // Full Name
                    _buildTextField(
                      controller: _fullNameController,
                      hintText: _getText('fullName'),
                    ),
                    const SizedBox(height: 16),
                    // Phone Number Row
                    Row(
                      children: [
                        // Country code selector
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF3A3A3A),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      '🇰🇼',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedCountryCode,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Phone number
                        Expanded(
                          flex: 3,
                          child: _buildTextField(
                            controller: _phoneController,
                            hintText: '',
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Street and Town City Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _townCityController,
                            hintText: _getText('townCity'),
                            suffix: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _streetController,
                            hintText: _getText('street'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Avenue and Building Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _avenueController,
                            hintText: _getText('avenue'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _buildingController,
                            hintText: _getText('building'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Floor and Flat Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _floorController,
                            hintText: _getText('floor'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _flatController,
                            hintText: _getText('flat'),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // State and Zip Code Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _stateController,
                            hintText: _getText('state'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _zipCodeController,
                            hintText: _getText('zipCode'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Default Address Checkbox
                    Row(
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Checkbox(
                          value: _isDefault,
                          onChanged: (bool? value) {
                            setState(() {
                              _isDefault = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFFFF6B35),
                          checkColor: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            _getText('isDefault'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Save Address button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.13),
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
                                _getText('saveAddress'),
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
          ],
        ),
      ),
    );
  }
}

