import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import '../services/auth_storage_service.dart';
import '../widgets/empty_address_widget.dart';
import 'location_selection_page.dart';
import 'add_address_page.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final LanguageService _languageService = LanguageService();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  String _selectedType = 'home';
  bool _isDefault = false;
  bool _isLoading = false;
  bool _isLoadingAddresses = true;
  bool _showAddForm = false;
  List<Map<String, dynamic>> _addresses = [];

  // Address type options
  final List<String> _addressTypes = ['home', 'work', 'other'];

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'myAddress': 'My Address',
      'addAddress': 'Add Address',
      'type': 'Address Type',
      'street': 'Street Address',
      'city': 'City',
      'state': 'State/Province',
      'zipCode': 'Zip Code',
      'country': 'Country',
      'isDefault': 'Set as Default Address',
      'save': 'SAVE',
      'cancel': 'CANCEL',
      'addSuccess': 'Address added successfully',
      'addError': 'Failed to add address',
      'networkError': 'Network error. Please check your connection.',
      'enterStreet': 'Please enter street address',
      'enterCity': 'Please enter city',
      'enterState': 'Please enter state/province',
      'enterZipCode': 'Please enter zip code',
      'enterCountry': 'Please enter country',
      'home': 'Home',
      'work': 'Work',
      'other': 'Other',
      'savedAddresses': 'Saved Addresses',
      'noAddresses': 'No addresses saved yet',
      'noAddressAddedYet': 'No Address Added Yet!',
      'addFirstAddressSubtitle': 'Add your first address to make ordering faster and easier.',
      'default': 'Default',
      'addNewAddress': 'ADD NEW ADDRESS',
    },
    'Arabic': {
      'myAddress': 'عنواني',
      'addAddress': 'إضافة عنوان',
      'type': 'نوع العنوان',
      'street': 'عنوان الشارع',
      'city': 'المدينة',
      'state': 'الولاية/المحافظة',
      'zipCode': 'الرمز البريدي',
      'country': 'الدولة',
      'isDefault': 'تعيين كعنوان افتراضي',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'addSuccess': 'تم إضافة العنوان بنجاح',
      'addError': 'فشل إضافة العنوان',
      'networkError': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
      'enterStreet': 'يرجى إدخال عنوان الشارع',
      'enterCity': 'يرجى إدخال المدينة',
      'enterState': 'يرجى إدخال الولاية/المحافظة',
      'enterZipCode': 'يرجى إدخال الرمز البريدي',
      'enterCountry': 'يرجى إدخال الدولة',
      'home': 'منزل',
      'work': 'عمل',
      'other': 'أخرى',
      'savedAddresses': 'العناوين المحفوظة',
      'noAddresses': 'لا توجد عناوين محفوظة بعد',
      'noAddressAddedYet': 'لم يتم إضافة عنوان بعد!',
      'addFirstAddressSubtitle': 'أضف عنوانك الأول لجعل الطلب أسرع وأسهل.',
      'default': 'افتراضي',
      'addNewAddress': 'إضافة عنوان جديد',
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
    _fetchAddresses();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  Future<void> _fetchAddresses() async {
    setState(() {
      _isLoadingAddresses = true;
    });

    try {
      final token = await AuthStorageService.getToken();

      if (token == null || token.isEmpty) {
        setState(() {
          _isLoadingAddresses = false;
        });
        return;
      }

      final response = await UserService.getAddresses(token: token);

      if (response['success'] == true && response['data'] != null) {
        final addresses = response['data']['addresses'] as List<dynamic>?;
        setState(() {
          _addresses = addresses?.map((addr) => addr as Map<String, dynamic>).toList() ?? [];
          _isLoadingAddresses = false;
        });
      } else {
        setState(() {
          _isLoadingAddresses = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingAddresses = false;
      });
      print('Error fetching addresses: $e');
    }
  }

  Future<void> _saveAddress() async {
    // Validate fields
    if (_streetController.text.trim().isEmpty) {
      _showError(_getText('enterStreet'));
      return;
    }

    if (_cityController.text.trim().isEmpty) {
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

    if (_countryController.text.trim().isEmpty) {
      _showError(_getText('enterCountry'));
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
        _showError('Please login to add address');
        return;
      }

      // Call API to save address
      final response = await UserService.addAddress(
        token: token,
        type: _selectedType,
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        country: _countryController.text.trim(),
        isDefault: _isDefault,
      );

      setState(() {
        _isLoading = false;
      });

      // Check if API call was successful
      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getText('addSuccess')),
              backgroundColor: Colors.green,
            ),
          );
          // Clear form and refresh addresses
          _clearForm();
          setState(() {
            _showAddForm = false;
          });
          _fetchAddresses();
        }
      } else {
        _showError(response['message'] ?? _getText('addError'));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showError(
        e.toString().contains('Network')
            ? _getText('networkError')
            : _getText('addError'),
      );
    }
  }

  void _clearForm() {
    _streetController.clear();
    _cityController.clear();
    _stateController.clear();
    _zipCodeController.clear();
    _countryController.clear();
    _selectedType = 'home';
    _isDefault = false;
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

  String _getAddressTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return _getText('home');
      case 'work':
        return _getText('work');
      case 'other':
        return _getText('other');
      default:
        return type;
    }
  }

  Widget _buildAddressCard(Map<String, dynamic> address) {
    // Get address fields - check for fullName or addressName, fallback to type
    final name = address['fullName']?.toString() ?? 
                 address['addressName']?.toString() ?? 
                 _getAddressTypeLabel(address['type']?.toString() ?? 'home');
    final street = address['street']?.toString() ?? '';
    final city = address['city']?.toString() ?? '';
    final state = address['state']?.toString() ?? '';
    final zipCode = address['zipCode']?.toString() ?? '';
    final country = address['country']?.toString() ?? '';
    
    // Format address lines as shown in the image
    // Line 1: street address (e.g., "Block 3, Street 18 House 12 Salmiya Area")
    // Line 2: zipCode state, country (e.g., "22014 Hawali, Kuwait")
    final addressLine1 = street;
    // Use state if available, otherwise use city
    final location = state.isNotEmpty ? state : city;
    final addressLine2Parts = <String>[];
    if (zipCode.isNotEmpty) addressLine2Parts.add(zipCode);
    if (location.isNotEmpty && country.isNotEmpty) {
      addressLine2Parts.add('$location, $country');
    } else if (location.isNotEmpty) {
      addressLine2Parts.add(location);
    } else if (country.isNotEmpty) {
      addressLine2Parts.add(country);
    }
    final addressLine2 = addressLine2Parts.join(' ');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // House icon on the left
          const Icon(
            Icons.home_outlined,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          // Address details in the middle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: [
                // Name
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
                const SizedBox(height: 8),
                // Address line 1
                if (addressLine1.isNotEmpty)
                  Text(
                    addressLine1,
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                    textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                if (addressLine1.isNotEmpty && addressLine2.isNotEmpty)
                  const SizedBox(height: 4),
                // Address line 2
                if (addressLine2.isNotEmpty)
                  Text(
                    addressLine2,
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                    textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Edit and Delete icons on the right
          Column(
            children: [
              // Edit icon
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to edit address page
                  print('Edit address: ${address['id']}');
                },
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              // Delete icon
              GestureDetector(
                onTap: () {
                  // TODO: Show delete confirmation and delete address
                  print('Delete address: ${address['id']}');
                },
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Custom Header (same as Help Center)
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFF2B2A2A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6.31,
                  spreadRadius: 0,
                  offset: const Offset(0, 0.63),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        _getText('myAddress'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button width
                  ],
                ),
              ),
            ),
          ),
          // Main Content
          Expanded(
            child: _isLoadingAddresses
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                ),
              )
            : _showAddForm
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Add Address Form content
                        _buildAddAddressForm(),
                      ],
                    ),
                  )
                : _addresses.isEmpty
                    ? Column(
                        children: [
                          Expanded(
                            child: EmptyAddressWidget(
                              title: _getText('noAddressAddedYet'),
                              subtitle: _getText('addFirstAddressSubtitle'),
                              isRTL: _isRTL,
                            ),
                          ),
                          AddAddressButton(
                            text: _getText('addNewAddress'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LocationSelectionPage(),
                                ),
                              ).then((_) {
                                // Refresh addresses when returning from location selection flow
                                _fetchAddresses();
                              });
                            },
                            isRTL: _isRTL,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          // ADD NEW ADDRESS button at the top
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: AddAddressButton(
                              text: _getText('addNewAddress'),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const AddAddressPage(),
                                  ),
                                ).then((_) {
                                  // Refresh addresses when returning from AddAddressPage
                                  _fetchAddresses();
                                });
                              },
                              isRTL: _isRTL,
                            ),
                          ),
                          // Address list
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ..._addresses.map((address) => _buildAddressCard(address)),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
            ),

        ],
      ),
    );
  }

  Widget _buildAddAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Text(
              _getText('addAddress'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _showAddForm = false;
                  _clearForm();
                });
              },
              child: Text(
                _getText('cancel'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Address Type Dropdown
        Text(
          _getText('type'),
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
            value: _selectedType,
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
            items: _addressTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(
                  _getAddressTypeLabel(type),
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedType = newValue;
                });
              }
            },
          ),
        ),
        const SizedBox(height: 24),

        // Street Address Field
        Text(
          _getText('street'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _streetController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: '123 Main St',
            hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 24),

        // City Field
        Text(
          _getText('city'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _cityController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: 'Kuwait City',
            hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 24),

        // State Field
        Text(
          _getText('state'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _stateController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: 'Al Asimah',
            hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 24),

        // Zip Code Field
        Text(
          _getText('zipCode'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _zipCodeController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: '12345',
            hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 24),

        // Country Field
        Text(
          _getText('country'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _countryController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: 'Kuwait',
            hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 24),

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

        // Save Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveAddress,
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
    );
  }
}

