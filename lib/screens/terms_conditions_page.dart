import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
    );
  }
}

