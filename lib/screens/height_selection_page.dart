import 'package:flutter/material.dart';
import '../services/language_service.dart';
import 'weight_selection_page.dart';

class HeightSelectionPage extends StatefulWidget {
  const HeightSelectionPage({super.key});

  @override
  State<HeightSelectionPage> createState() => _HeightSelectionPageState();
}

class _HeightSelectionPageState extends State<HeightSelectionPage> {
  final LanguageService _languageService = LanguageService();
  final ScrollController _scrollController = ScrollController();
  int _selectedHeight = 175; // Default height in cm
  static const int _minHeight = 100;
  static const int _maxHeight = 250;
  static const double _itemHeight = 4.0; // Height of each cm mark in pixels

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'What\'s your Height?',
      'subtitle': 'Set your height in cm, don\'t worry you can change it later.',
      'cm': 'CM',
      'next': 'NEXT',
    },
    'Arabic': {
      'title': 'ما هو طولك؟',
      'subtitle': 'حدد طولك بالسنتيمتر، لا تقلق يمكنك تغييره لاحقاً.',
      'cm': 'سم',
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
    // Scroll to default height position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToHeight(_selectedHeight);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  void _scrollToHeight(int height) {
    final double targetOffset = (_maxHeight - height) * _itemHeight;
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    final int newHeight = _maxHeight - (offset / _itemHeight).round();
    final int clampedHeight = newHeight.clamp(_minHeight, _maxHeight);
    if (clampedHeight != _selectedHeight) {
      setState(() {
        _selectedHeight = clampedHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: SafeArea(
        child: Column(
          children: [
            // Top section with back button and progress bar
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
                  // Progress bar
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: _isRTL ? Alignment.centerRight : Alignment.centerLeft,
                        widthFactor: 0.33, // 33% progress (1/3)
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title and subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    _getText('title'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getText('subtitle'),
                    style: const TextStyle(
                      color: Color(0xFF7A7A7A),
                      fontSize: 15,
                      height: 1.4,
                    ),
                    textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Height selection interface
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double centerY = constraints.maxHeight / 2;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ruler with fixed center indicator
                        SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: constraints.maxHeight,
                            child: Stack(
                              children: [
                                // Scrollable ruler
                                ListView.builder(
                                  controller: _scrollController,
                                  physics: const ClampingScrollPhysics(),
                                  reverse: false,
                                  padding: EdgeInsets.only(
                                    top: centerY - (_itemHeight / 2),
                                    bottom: centerY - (_itemHeight / 2),
                                  ),
                                  itemCount: _maxHeight - _minHeight + 1,
                                  itemBuilder: (context, index) {
                                    final int height = _maxHeight - index;
                                    final bool isFiveCmMark = height % 5 == 0;
                                    
                                    return Container(
                                      height: _itemHeight,
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                        children: [
                                          // Ruler line
                                          Container(
                                            width: isFiveCmMark ? 40 : 20,
                                            height: isFiveCmMark ? 2 : 1,
                                            color: isFiveCmMark ? Colors.white : const Color(0xFF7A7A7A),
                                          ),
                                          // Height label for 5cm marks
                                          if (isFiveCmMark) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              height.toString(),
                                              style: const TextStyle(
                                                color: Color(0xFF7A7A7A),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                // Fixed center indicator line (orange horizontal line extending from ruler)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: centerY - 1,
                                  child: Container(
                                    width: double.infinity,
                                    height: 2,
                                    color: const Color(0xFFFF6B35),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Selected height display
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: centerY - 24),
                            child: Text(
                              '$_selectedHeight ${_getText('cm')}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // NEXT button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WeightSelectionPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFF722D),
                        Color(0xFF99441B),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25.13),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getText('next').toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

