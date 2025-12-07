import 'package:flutter/material.dart';
import 'terms_conditions_page.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

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
                        'About App',
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
            child: ListView(
        children: [
          _buildMenuItem('Terms & Condition', () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const TermsConditionsPage(),
              ),
            );
          }),
          _buildMenuItem('Privacy Policy', () {
            // Navigate to privacy page
          }),
          _buildMenuItem('Data Deletion Policy', () {
            // Navigate to data deletion page
          }),
          _buildMenuItem('Cancellation Policy', () {
            // Navigate to cancellation page
          }),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Color(0xFF3A3A3A),
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}

