import 'package:flutter/material.dart';
import 'package:mycard/card.dart';
import 'package:mycard/contact.dart';
import 'package:mycard/profile.dart';
import 'package:mycard/settings.dart';

class HomePage extends StatefulWidget {
  final String? scannedUid;
  const HomePage({Key? key, this.scannedUid}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _updateScreens();
  }

  void _updateScreens() {
    _screens = [
      CardPage(),
      ContactPage(uid: widget.scannedUid ?? ''),
      ProfilePage(),
      SettingsPage(),
    ];
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        children: _screens, // Use _screens here
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedFontSize: 20,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xffECECEB),
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _selectedIndex == 0
                    ? Color(0xff030ff6)
                    : Color(0xffB4B4B3),
                size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group,
                color: _selectedIndex == 1
                    ? Color(0xff030ff6)
                    : Color(0xffB4B4B3),
                size: 30),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _selectedIndex == 2
                    ? Color(0xff030ff6)
                    : Color(0xffB4B4B3),
                size: 30),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,
                color: _selectedIndex == 3
                    ? Color(0xff030ff6)
                    : Color(0xffB4B4B3),
                size: 30),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }
}