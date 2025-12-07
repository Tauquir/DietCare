import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;
  final Function(int)? onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    this.initialIndex = 0,
    this.onItemTapped,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Always call the callback if provided
    if (widget.onItemTapped != null) {
      widget.onItemTapped!(index);
    }
  }

  Widget _buildBottomNavItem(String label, int index) {
    final isSelected = _selectedIndex == index;
    
    // Get the appropriate SVG asset based on label
    String svgAsset;
    if (label == 'PLANS') {
      svgAsset = 'assets/svg/plans.svg';
    } else if (label == 'CALENDAR') {
      svgAsset = 'assets/svg/calender.svg';
    } else if (label == 'ACCOUNT') {
      svgAsset = 'assets/svg/account.svg';
    } else {
      svgAsset = 'assets/svg/plans.svg'; // Default fallback
    }
    
    Widget iconWidget = isSelected
        ? SvgPicture.asset(
            svgAsset,
            width: 24,
            height: 24,
            // No color filter when selected - show original SVG colors
          )
        : SvgPicture.asset(
      svgAsset,
      width: 24,
      height: 24,
            colorFilter: const ColorFilter.mode(
              Color(0xFF9E9E9E),
        BlendMode.srcIn,
      ),
    );
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF9E9E9E),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomNavItem('PLANS', 0),
          _buildBottomNavItem('CALENDAR', 1),
          _buildBottomNavItem('ACCOUNT', 2),
        ],
      ),
    );
  }
}

