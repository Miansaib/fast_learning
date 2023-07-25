import 'package:Fast_learning/pages/childs/add_upload_page/upload_view.dart';
import 'package:Fast_learning/pages/childs/review_page/review_page.dart';
import 'package:Fast_learning/pages/childs/setting_page/setting_page.dart';
import 'package:Fast_learning/pages/childs/training_page/training_page.dart';
import 'package:Fast_learning/pages/show_hint.dart';
import 'package:Fast_learning/profile_page.dart';
import 'package:Fast_learning/zcomponent/homepage/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../constants/custom_color.dart';
import '../../controllers/cards_controller.dart';
import 'package:badges/badges.dart';

import '../../controllers/theme_controller.dart';

class HomePageWarperButtomNav extends StatefulWidget {
  HomePageWarperButtomNav({Key? key}) : super(key: key);

  @override
  _HomePageWarperButtomNavState createState() =>
      _HomePageWarperButtomNavState();
}

class _HomePageWarperButtomNavState extends State<HomePageWarperButtomNav> {
  CardsController _cardsController = Get.find<CardsController>();
  final themeController = Get.find<ThemeContoller>();
  PersistentTabController? _controller;
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();

  // final GlobalKey _five = GlobalKey();
  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);

    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      ReviewPage(),
      // ImageUpload(),
      SettingPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home_rounded,
          color: Colors.white,
        ),
        contentPadding: 0.8,
        title: ("Home".tr),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CustomColor.dark_grey,
      ),
      PersistentBottomNavBarItem(
        icon: Badge(
          padding: EdgeInsets.all(5),
          toAnimate: true,
          badgeContent:
              Obx(() => Text(_cardsController.boxes.length.toString())),
          child: Icon(
            Icons.reviews,
            color: Colors.white,
          ),
        ),
        title: ("review".tr),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CustomColor.dark_grey,
      ),
      // PersistentBottomNavBarItem(
      //   contentPadding: .2,
      //   icon: Icon(Icons.person, color: Colors.white,),
      //   title: ("profile".tr),
      //   activeColorPrimary: Colors.white,
      //   inactiveColorPrimary: CustomColor.dark_grey,
      // ),
      PersistentBottomNavBarItem(
        contentPadding: .2,
        icon: Icon(
          Icons.settings,
          color: Colors.white,
        ),
        title: ("setting".tr),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CustomColor.dark_grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: themeController
          .themeData.value.primaryColor, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      //9,14,19
      navBarStyle: NavBarStyle.style19,
      // Choose the nav bar style with this property.
    );
  }
}
