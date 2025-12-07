import 'package:flutter/material.dart';
import 'home_page.dart';
import 'calendar_page.dart';
import 'account_page.dart';
import '../widgets/bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final GlobalKey<CalendarPageState> _calendarKey = GlobalKey<CalendarPageState>();
  
  // Keep all pages in memory to preserve state
  late final List<Widget> _pages = [
    const HomePage(),
    CalendarPage(key: _calendarKey),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Reload calendar data when calendar tab is selected
    if (index == 1) {
      _calendarKey.currentState?.reloadCalendarData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        initialIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

