import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyPlansWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onExplorePlans;
  final bool isRTL;

  const EmptyPlansWidget({
    super.key,
    this.title,
    this.subtitle,
    this.buttonText,
    this.onExplorePlans,
    this.isRTL = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: SizedBox(
            width: constraints.maxWidth,
            child: _buildIllustration(constraints.maxWidth),
          ),
        );
      },
    );
  }

  Widget _buildIllustration(double screenWidth) {
    return SvgPicture.asset(
      'assets/svg/noactiveplan.svg',
      width: screenWidth,
      fit: BoxFit.contain,
    );
  }
}

