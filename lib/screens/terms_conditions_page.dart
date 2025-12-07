import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

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
                  children: [
                    IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
                    const Expanded(
                      child: Text(
          'Terms & Conditions',
                        textAlign: TextAlign.center,
          style: TextStyle(
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
            child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to our app! By using this platform, you agree to the following terms:',
              style: TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
            // Section 1: General Use
            const Text(
              '1. General Use',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '• This app connects users with restaurants, diet centres, and grocery providers for meal orders and delivery.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• You agree to use the app for lawful purposes and follow all applicable local regulations.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
            const Divider(color: Color(0xFF3A3A3A)),
            const SizedBox(height: 24),
            
            // Section 2: Account & Information
            const Text(
              '2. Account & Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '• You are responsible for maintaining the confidentiality of your account details.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Please ensure your personal and delivery information is accurate and up to date.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
            const Divider(color: Color(0xFF3A3A3A)),
            const SizedBox(height: 24),
            
            // Section 3: Orders & Payments
            const Text(
              '3. Orders & Payments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '• All orders placed through the app are confirmed once payment is successful.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Refunds and cancellations are subject to our refund policy and terms of service.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
            const Divider(color: Color(0xFF3A3A3A)),
            const SizedBox(height: 24),
            
            // Section 4: Delivery
            const Text(
              '4. Delivery',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '• Delivery times are estimates and may vary based on location and order volume.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• You must be available to receive your order at the specified delivery address.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
            ),
          ),
        ],
      ),
    );
  }
}

