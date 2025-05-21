import 'package:english_learning_app/models/viewmodel_base.dart';
import 'package:english_learning_app/pages/menu_profile/menu_profile.dart';
import 'package:english_learning_app/pages/ranking_screen.dart';
import 'package:english_learning_app/pages/topics/topic_screen.dart';
import 'package:flutter/material.dart';

import '../pages/pronounciation/pronunciation_page.dart';

class HomePageViewModel extends ViewModelBase {
  final List<Widget> _pages = [
    TopicScreen(),
    RankingScreen(),
    PronunciationScreen(),
    const MenuProfilePage(),
  ];

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final PageController pageController = PageController();

  List<Widget> get pages => _pages;

  static BottomNavigationBarItem getBottomNavItem(String imageIcon, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(5),
        child: Image.asset(
          imageIcon,
          height: 30,
        ),
      ),
      label: '',
      activeIcon: Container(
        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), border: Border.all(color: Colors.blue, width: 3), borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(5),
        child: Image.asset(
          imageIcon,
          height: 30,
        ),
      ),
    );
  }

  final List<BottomNavigationBarItem> bottomnavigationBarItems = [
    getBottomNavItem('images/house.png', 0),
    getBottomNavItem('images/trophy.png', 1),
    getBottomNavItem('images/mouth.png', 2),
    getBottomNavItem('images/woman.png', 3),
  ];

  void onItemTapped(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    if ((index - _currentIndex).abs() > 1) {
      pageController.jumpToPage(index);
    } else {
      pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    notifyListeners();
  }

  void onPageChanged(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }
}
