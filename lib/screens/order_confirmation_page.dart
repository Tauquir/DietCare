import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
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
                const Text(
                  'HI ABDUL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Success Message
                const Text(
                  'Subscription Purchased Successfully!',
                  style: TextStyle(
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
                                    const Text(
                                      'Zen Meal Plan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'For steady, visible progress.',
                                      style: TextStyle(
                                        color: Color(0xFF9E9E9E),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '1 Breakfast, 2 Main course, 1 Salad & Drinks, 1 Soup',
                                      style: TextStyle(
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
                          _buildInfoRow('Package Type', 'Lunch + Dinner'),
                          const SizedBox(height: 12),
                          _buildInfoRow('Calories', '1200 - 1600 Kcal'),
                          const SizedBox(height: 12),
                          _buildInfoRow('Package Duration', '80 days (40 days left)'),
                          
                          const SizedBox(height: 20),
                          
                          // Nutrition Breakdown
                          const Text(
                            'Nutrition Breakdown',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _buildNutritionBox('Protein', '81-100g', Colors.green),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildNutritionBox('Carbs', '162-197g', const Color(0xFFFF6B35)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildNutritionBox('Fat', '39-75g', Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Payment Summary Section
                    const Text(
                      'Payment Summary',
                      style: TextStyle(
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
                          _buildPaymentRow('Payment Date', 'Knet'),
                          const SizedBox(height: 12),
                          _buildPaymentRow('Transaction ID', '#12145656565'),
                          const SizedBox(height: 12),
                          _buildPaymentRow('Result', 'Captured'),
                          const SizedBox(height: 12),
                          _buildPaymentRow('Payment Method', 'Knet'),
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
            child: const Text(
              'ADD MEALS',
              style: TextStyle(
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

  void _handleAddMeals() {
    // Navigate back to home page
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
