import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyAddressWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool isRTL;

  const EmptyAddressWidget({
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
            child: SvgPicture.asset(
              'assets/svg/noaddress.svg',
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}

class AddAddressButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isRTL;

  const AddAddressButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isRTL = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFF722D),
            Color(0xFFFF6B35),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

