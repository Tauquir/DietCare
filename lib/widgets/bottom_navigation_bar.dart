import 'package:flutter/material.dart';
import '../screens/calendar_page.dart';
import '../screens/account_page.dart';
import '../screens/home_page.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (widget.onItemTapped != null) {
      widget.onItemTapped!(index);
    } else {
      // Default navigation behavior
      if (index == 0) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else if (index == 1) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CalendarPage(),
          ),
        );
      } else if (index == 2) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AccountPage(),
          ),
        );
      }
    }
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    
    // Custom icon for PLANS - document with apple
    Widget iconWidget;
    if (label == 'PLANS') {
      iconWidget = Stack(
        alignment: Alignment.center,
        children: [
          // Document icon
          Icon(
            Icons.description,
            color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF9E9E9E),
            size: 24,
          ),
          // Apple icon positioned on top-right of document
          Positioned(
            top: -2,
            right: -4,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF9E9E9E),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  // Apple body
                  Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF9E9E9E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Leaf
                  Positioned(
                    top: -2,
                    left: 2,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      iconWidget = Icon(
        icon,
        color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF9E9E9E),
        size: 24,
      );
    }
    
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
          _buildBottomNavItem(Icons.assignment_outlined, 'PLANS', 0),
          _buildBottomNavItem(Icons.event, 'CALENDAR', 1),
          _buildBottomNavItem(Icons.person_outline, 'ACCOUNT', 2),
        ],
      ),
    );
  }
}

