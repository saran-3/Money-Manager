import 'package:flutter/material.dart';
import 'package:money_manager/screens/screen_home.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext context, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          currentIndex: updatedIndex,
          onTap: (newIndex) {
            ScreenHome.selectedIndexNotifier.value = newIndex;
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Transaction'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Categories'),
          ],
        );
      },
    );
  }
}
