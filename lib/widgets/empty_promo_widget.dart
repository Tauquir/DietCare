import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyPromoWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isRTL;

  const EmptyPromoWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.isRTL = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Center(
              child: SizedBox(
                width: constraints.maxWidth,
                child: _buildIllustration(constraints.maxWidth),
              ),
            ),
            const SizedBox(height: 40),
            // Title
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIllustration(double screenWidth) {
    return SvgPicture.asset(
      'assets/svg/nopromo.svg',
      width: screenWidth,
      fit: BoxFit.contain,
    );
  }
}

