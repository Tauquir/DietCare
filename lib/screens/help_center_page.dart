import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          // Custom Header
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
                        'Help Center',
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
            const SizedBox(height: 20),
            SizedBox(
              width: 364,
              height: 29,
              child: const Text(
                'We\'re Here to Help!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Onest',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 28.72 / 22, // line-height / font-size
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 364,
              height: 40,
              child: const Text(
                'Got a question or need support? Reach out and we\'ll get back to you soon.',
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontFamily: 'Onest',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 18.94 / 13, // line-height / font-size
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Call Us Card
            _buildContactCard(
              svgPath: 'assets/svg/call.svg',
              decorativeSvgPath: 'assets/svg/callora.svg',
              iconBackground: Colors.brown.withValues(alpha: 0.1),
              label: 'CALL US ON',
              contact: '+965 88775544',
              onTap: () {
                // Handle call action
              },
            ),
            const SizedBox(height: 20),
            
            // Message Us Card
            _buildContactCard(
              svgPath: 'assets/svg/whatsapp.svg',
              decorativeSvgPath: 'assets/svg/whatsappora.svg',
              iconBackground: Colors.brown.withValues(alpha: 0.1),
              label: 'MESSAGE US ON',
              contact: 'WhatsApp',
              isWhatsApp: true,
              onTap: () {
                // Handle message action
              },
            ),
          ],
        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    IconData? icon,
    String? svgPath,
    String? decorativeSvgPath,
    required Color iconBackground,
    required String label,
    required String contact,
    required VoidCallback onTap,
    bool isWhatsApp = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 372,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12.63),
        ),
        child: Row(
          children: [
            svgPath != null
                ? SvgPicture.asset(
                    svgPath,
                    width: 50,
                    height: 50,
                  )
                : Icon(
                    icon,
                    color: const Color(0xFFFF6B35),
                    size: 28,
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontFamily: 'Onest',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 22.09 / 13, // line-height / font-size
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Onest',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 22.09 / 17, // line-height / font-size
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    top: -10,
                    child: decorativeSvgPath != null
                        ? SvgPicture.asset(
                            decorativeSvgPath,
                            width: 80,
                            height: 80,
                          )
                        : Icon(
                            isWhatsApp ? Icons.phone_iphone : Icons.phone,
                            color: iconBackground,
                            size: 80,
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

