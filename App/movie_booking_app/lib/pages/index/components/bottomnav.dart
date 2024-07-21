import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/Appdata.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final int selectedIndex;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        color: AppColors.transpanrent,
        borderRadius: ContainerRadius.radius20,
      ),
      child: ClipRRect(
        borderRadius: ContainerRadius.radius20,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
          ),
          child: BottomNavigationBar(
              backgroundColor: AppColors.backgroundColor,
              selectedItemColor: AppColors.iconThemeColor,
              unselectedItemColor: AppColors.grayTextColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              onTap: onItemTapped,
              items: List.generate(
                3,
                (index) => BottomNavigationBarItem(
                  backgroundColor: AppColors.backgroundColor,
                  icon: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Icon(
                        Appdata.getIconForIndex(index),
                      ),
                    ],
                  ),
                  label: Appdata.getLabelForIndex(context, index),
                ),
              ),
              selectedIconTheme: const IconThemeData(
                color: AppColors.iconThemeColor,
              ),
              unselectedIconTheme: const IconThemeData(
                color: AppColors.grayTextColor,
              ),
              selectedLabelStyle: AppStyle.smallText,
              unselectedLabelStyle: AppStyle.smallText),
        ),
      ),
    );
  }
}
