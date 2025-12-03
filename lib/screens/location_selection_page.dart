import 'package:flutter/material.dart';
import '../services/language_service.dart';
import 'add_address_page.dart';

class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({super.key});

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final LanguageService _languageService = LanguageService();
  final GlobalKey _mapKey = GlobalKey();
  Offset _pinPosition = const Offset(0.5, 0.5); // Normalized position (0 to 1)
  double? _selectedLatitude;
  double? _selectedLongitude;
  String _selectedAddress = 'Hawally, Kuwait';
  String _selectedStreet = 'Block 3, Street 18 House 12';
  String _selectedFullAddress = 'Salmiya Area 22014 Hawali, Kuwait';

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Select Your Location',
      'deliveringTo': 'Delivering healthy meals to',
      'mealsDeliveredHere': 'Meals will be delivered here',
      'placePinExact': 'Place pin in exact location',
      'change': 'CHANGE',
      'confirmLocation': 'CONFIRM LOCATION',
    },
    'Arabic': {
      'title': 'اختر موقعك',
      'deliveringTo': 'توصيل الوجبات الصحية إلى',
      'mealsDeliveredHere': 'سيتم توصيل الوجبات هنا',
      'placePinExact': 'ضع الدبوس في الموقع الدقيق',
      'change': 'تغيير',
      'confirmLocation': 'تأكيد الموقع',
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
    // Default location (Kuwait coordinates)
    _selectedLatitude = 29.3759;
    _selectedLongitude = 47.9774;
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  void _updatePinPosition(Offset localPosition, Size mapSize) {
    // Clamp position to map bounds
    final clampedX = localPosition.dx.clamp(0.0, mapSize.width);
    final clampedY = localPosition.dy.clamp(0.0, mapSize.height);
    
    // Normalize position (0 to 1)
    final normalizedX = clampedX / mapSize.width;
    final normalizedY = clampedY / mapSize.height;
    
    setState(() {
      _pinPosition = Offset(normalizedX, normalizedY);
      // Convert normalized position to approximate coordinates
      // This is a placeholder - real implementation would use map projection
      _selectedLatitude = 29.3759 + (normalizedY - 0.5) * 0.1;
      _selectedLongitude = 47.9774 + (normalizedX - 0.5) * 0.1;
    });
  }

  void _onMapTap(TapDownDetails details, Size mapSize) {
    _updatePinPosition(details.localPosition, mapSize);
  }

  void _onPinDrag(DragUpdateDetails details, Size mapSize) {
    // Get the RenderBox of the map container using GlobalKey
    final RenderBox? renderBox = _mapKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      // Convert global position to local position relative to the map
      final localPosition = renderBox.globalToLocal(details.globalPosition);
      _updatePinPosition(localPosition, mapSize);
    }
  }

  void _confirmLocation() {
    if (_selectedLatitude != null && _selectedLongitude != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddAddressPage(
            latitude: _selectedLatitude!,
            longitude: _selectedLongitude!,
            address: _selectedAddress,
            street: _selectedStreet,
            fullAddress: _selectedFullAddress,
          ),
        ),
      );
    }
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
            // Map Section
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final mapSize = Size(constraints.maxWidth, constraints.maxHeight);
                  
                  return Stack(
                    children: [
                      // Map placeholder (dark blue background with street grid)
                      GestureDetector(
                        onTapDown: (details) => _onMapTap(details, mapSize),
                        child: Container(
                          key: _mapKey,
                          width: double.infinity,
                          height: double.infinity,
                          color: const Color(0xFF1E3A5F), // Dark blue map color
                          child: CustomPaint(
                            painter: MapGridPainter(),
                            child: Stack(
                              children: [
                                // Street labels (simplified)
                                Positioned(
                                  top: 50,
                                  left: 20,
                                  child: Text(
                                    '160 St',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 100,
                                  left: 20,
                                  child: Text(
                                    '155 St',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Draggable Location pin
                      Positioned(
                        left: _pinPosition.dx * mapSize.width - 15, // Center pin horizontally
                        top: _pinPosition.dy * mapSize.height - 45, // Position pin vertically (accounting for tooltip)
                        child: GestureDetector(
                          onPanUpdate: (details) => _onPinDrag(details, mapSize),
                          child: Column(
                            children: [
                              // Tooltip
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getText('mealsDeliveredHere'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _getText('placePinExact'),
                                      style: const TextStyle(
                                        color: Color(0xFF9E9E9E),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Orange pin
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF6B35),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1B1B1B),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              // Pin tail
                              Container(
                                width: 2,
                                height: 15,
                                color: const Color(0xFFFF6B35),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Bottom section with address details
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getText('deliveringTo'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  const SizedBox(height: 12),
                  // Address card
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1B1B),
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
                            color: const Color(0xFF2A2A2A),
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
                                _selectedAddress,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedStreet,
                                style: const TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 12,
                                ),
                                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _selectedFullAddress,
                                style: const TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 12,
                                ),
                                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Change button
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
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
                  const SizedBox(height: 20),
                  // Confirm Location button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _confirmLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.13),
                        ),
                      ),
                      child: Text(
                        _getText('confirmLocation'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for map grid
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw vertical grid lines
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

