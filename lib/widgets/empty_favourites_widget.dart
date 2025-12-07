import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyFavouritesWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool isRTL;

  const EmptyFavouritesWidget({
    super.key,
    this.title,
    this.subtitle,
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
      'assets/svg/nofav.svg',
      width: screenWidth,
      fit: BoxFit.contain,
    );
  }
}

