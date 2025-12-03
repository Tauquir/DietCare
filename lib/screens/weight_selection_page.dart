import 'package:flutter/material.dart';
import '../services/language_service.dart';
import 'activity_level_page.dart';

class WeightSelectionPage extends StatefulWidget {
  const WeightSelectionPage({super.key});

  @override
  State<WeightSelectionPage> createState() => _WeightSelectionPageState();
}

class _WeightSelectionPageState extends State<WeightSelectionPage> {
  final LanguageService _languageService = LanguageService();
  final ScrollController _scrollController = ScrollController();
  int _selectedWeight = 75; // Default weight in kg
  static const int _minWeight = 30;
  static const int _maxWeight = 200;
  static const double _itemWidth = 4.0; // Width of each kg mark in pixels

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'What\'s your Weight?',
      'subtitle': 'Set your weight in kg, don\'t worry you can change it later.',
      'kg': 'KG',
      'next': 'NEXT',
    },
    'Arabic': {
      'title': 'ما هو وزنك؟',
      'subtitle': 'حدد وزنك بالكيلوجرام، لا تقلق يمكنك تغييره لاحقاً.',
      'kg': 'كجم',
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
    // Scroll to default weight position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToWeight(_selectedWeight);
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

  void _scrollToWeight(int weight) {
    final double targetOffset = (weight - _minWeight) * _itemWidth;
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    final int newWeight = _minWeight + (offset / _itemWidth).round();
    final int clampedWeight = newWeight.clamp(_minWeight, _maxWeight);
    if (clampedWeight != _selectedWeight) {
      setState(() {
        _selectedWeight = clampedWeight;
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
            // Selected weight display
            Center(
              child: Text(
                '$_selectedWeight ${_getText('kg')}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Horizontal ruler interface
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // Horizontal scrollable ruler
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          reverse: _isRTL,
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth / 2 - (_itemWidth / 2) - 20,
                          ),
                          itemCount: _maxWeight - _minWeight + 1,
                          itemBuilder: (context, index) {
                            final int weight = _minWeight + index;
                            final bool isFiveKgMark = weight % 5 == 0;
                            
                            return Container(
                              width: _itemWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Weight label for 5kg marks (above the line)
                                  if (isFiveKgMark)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        weight.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  // Ruler line (vertical)
                                  Container(
                                    width: isFiveKgMark ? 2 : 1,
                                    height: isFiveKgMark ? 20 : 10,
                                    color: isFiveKgMark ? Colors.white : const Color(0xFF7A7A7A),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Fixed center indicator line (orange vertical line extending above and below)
                      Positioned(
                        left: constraints.maxWidth / 2 - 1,
                        top: constraints.maxHeight / 2 - 30,
                        child: Container(
                          width: 2,
                          height: 60,
                          color: const Color(0xFFFF6B35),
                        ),
                      ),
                    ],
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
                      builder: (context) => const ActivityLevelPage(),
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

