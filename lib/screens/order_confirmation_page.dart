import 'package:flutter/material.dart';
import '../services/language_service.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'greeting': 'HI ABDUL',
      'successMessage': 'Subscription Purchased Successfully!',
      'zenMealPlan': 'Zen Meal Plan',
      'zenSubtitle': 'For steady, visible progress.',
      'mealDescription': '1 Breakfast, 2 Main course, 1 Salad & Drinks, 1 Soup',
      'packageType': 'Package Type',
      'packageTypeValue': 'Lunch + Dinner',
      'calories': 'Calories',
      'caloriesValue': '1200 - 1600 Kcal',
      'packageDuration': 'Package Duration',
      'packageDurationValue': '80 days (40 meals)',
      'nutritionalValues': 'Nutrition Breakdown',
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fat': 'Fat',
      'paymentSummary': 'Payment Summary',
      'paymentDate': 'Payment Date',
      'transactionId': 'Transaction ID',
      'result': 'Result',
      'resultValue': 'Captured',
      'paymentMethod': 'Payment Method',
      'addMeals': 'ADD MEALS',
    },
    'Arabic': {
      'greeting': 'مرحبا عبد الله',
      'successMessage': 'تم شراء الاشتراك بنجاح!',
      'zenMealPlan': 'خطة وجبات زن',
      'zenSubtitle': 'لتقدم صحي وطبيعي',
      'mealDescription': '1 إفطار, 2 طبق رئيسي, 1 سلطة ومشروب, 1 شوربة ووجبة خفيفة',
      'packageType': 'نوع الباقة',
      'packageTypeValue': 'غداء + عشاء',
      'calories': 'السعرات الحرارية',
      'caloriesValue': '1200 - 1600 سعرة حرارية',
      'packageDuration': 'مدة الباقة',
      'packageDurationValue': '80 يوم (40 وجبة)',
      'nutritionalValues': 'القيم الغذائية',
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'fat': 'دهون',
      'paymentSummary': 'ملخص الدفع',
      'paymentDate': 'تاريخ الدفع',
      'transactionId': 'رقم المعاملة',
      'result': 'تم التحصيل',
      'resultValue': 'Captured',
      'paymentMethod': 'طريقة الدفع',
      'addMeals': 'أضف الوجبات',
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
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Orange Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B35),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFFFF6B35),
                    size: 40,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Greeting
                Text(
                  _getText('greeting'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Success Message
                Text(
                  _getText('successMessage'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meal Plan Details Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Meal Plan Overview
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3A3A3A),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: Color(0xFF9E9E9E),
                                  size: 40,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getText('zenMealPlan'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _getText('zenSubtitle'),
                                      style: const TextStyle(
                                        color: Color(0xFF9E9E9E),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _getText('mealDescription'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Package Specifics
                          _buildInfoRow(_getText('packageType'), _getText('packageTypeValue')),
                          const SizedBox(height: 12),
                          _buildInfoRow(_getText('calories'), _getText('caloriesValue')),
                          const SizedBox(height: 12),
                          _buildInfoRow(_getText('packageDuration'), _getText('packageDurationValue')),
                          
                          const SizedBox(height: 20),
                          
                          // Nutrition Breakdown
                          Text(
                            _getText('nutritionalValues'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _buildNutritionBox(_getText('protein'), '81-100g', Colors.green),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildNutritionBox(_getText('carbs'), '162-197g', const Color(0xFFFF6B35)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildNutritionBox(_getText('fat'), '39-75g', Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Payment Summary Section
                    Text(
                      _getText('paymentSummary'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildPaymentRow(_getText('paymentDate'), ''),
                          const SizedBox(height: 12),
                          _buildPaymentRow(_getText('transactionId'), '#12145656565'),
                          const SizedBox(height: 12),
                          _buildPaymentRow(_getText('result'), _getText('resultValue')),
                          const SizedBox(height: 12),
                          _buildPaymentRow(_getText('paymentMethod'), 'Knet'),
                          const SizedBox(height: 12),
                          _buildPaymentRow('Knet', 'Knet'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 100), // Extra space for fixed button
                  ],
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
            onPressed: _handleAddMeals,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              _getText('addMeals'),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionBox(String nutrient, String range, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            nutrient,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            range,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 14,
          ),
        ),
        if (value.isNotEmpty)
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  void _handleAddMeals() {
    // Navigate back to home page
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
