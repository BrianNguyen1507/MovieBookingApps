import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/Appdata.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  final int selectedIndex;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: AppColors.iconThemeColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.shifting,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: List.generate(
        5,
        (index) => BottomNavigationBarItem(
          backgroundColor: AppColors.backgroundColor,
          icon: Stack(
            children: [
              Icon(
                Appdata.getIconForIndex(index),
              ),
            ],
          ),
          label: Appdata.getLabelForIndex(index),
        ),
      ),
      selectedIconTheme: const IconThemeData(
        color: AppColors.primaryColor,
      ),
    );
  }
}
