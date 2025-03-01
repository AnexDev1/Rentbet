// dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rentbet/views/inbox/inbox_page.dart';
import 'package:rentbet/views/profile/profile_page.dart';
import 'package:rentbet/views/wishlist/wishlist_page.dart';
import '../listings/listings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          ListingsPage(),
          InboxPage(),
          WishlistPage(),
          ProfileScreen()
        ],
      ),
      // dart
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Icon(Icons.home_rounded,size: 35,)
                : Icon(Icons.home_outlined,size: 35, ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? FaIcon(FontAwesomeIcons.solidEnvelope)
                : FaIcon(FontAwesomeIcons.envelope),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? FaIcon(FontAwesomeIcons.solidHeart)
                : FaIcon(FontAwesomeIcons.heart),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? FaIcon(FontAwesomeIcons.solidUser)
                : FaIcon(FontAwesomeIcons.user),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}