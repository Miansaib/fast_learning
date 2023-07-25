import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './tab_item.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation(
      {super.key, required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    CardsController _cardsController = Get.find<CardsController>();

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Image.asset("assets/images/home-icon-active.png",
                color: Get.theme.accentColor, width: 24, height: 24),
          ),
          label: "Home",
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Image.asset("assets/images/home-icon.png",
                width: 24, height: 24),
          ),
        ),
        BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Icon(
                Icons.auto_awesome_motion,
                size: 24,
                color: Get.theme.accentColor,
              ),
            ),
            label: "In Progress",
            icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  Icons.auto_awesome_motion,
                  size: 24,
                )
                // Image.asset(
                //   "assets/images/courses-icon.png",
                //   width: 24,
                //   height: 24,
                // ),
                )),
        BottomNavigationBarItem(
            activeIcon: Badge(
              badgeColor: Get.theme.accentColor,
              padding: EdgeInsets.all(5),
              toAnimate: true,
              badgeContent:
                  Obx(() => Text(_cardsController.boxes.length.toString())),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Image.asset(
                  "assets/images/courses-active-icon.png",
                  color: Get.theme.accentColor,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            label: "Review",
            icon: Badge(
              badgeColor: Get.theme.accentColor,
              padding: EdgeInsets.all(5),
              toAnimate: true,
              badgeContent:
                  Obx(() => Text(_cardsController.boxes.length.toString())),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Image.asset(
                  "assets/images/courses-icon.png",
                  width: 24,
                  height: 24,
                ),
              ),
            )),
        BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/images/settings-icon-active.png",
                color: Get.theme.accentColor,
                width: 24,
                height: 24,
              ),
            ),
            label: "Settings",
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/images/setting-icon.png",
                width: 24,
                height: 24,
              ),
            )),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
      currentIndex: currentTab.index,
    );
  }
}
