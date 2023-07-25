import 'package:Fast_learning/leitner_box/screens/Books.dart';
import 'package:Fast_learning/leitner_box/screens/addNewLesson.dart';
import 'package:Fast_learning/leitner_box/screens/cardReview.dart';
import 'package:Fast_learning/leitner_box/screens/cardReview2.dart';
import 'package:Fast_learning/leitner_box/screens/home.dart';
import 'package:Fast_learning/leitner_box/screens/leitner1.dart';
import 'package:Fast_learning/leitner_box/screens/leitner5.dart';
import 'package:Fast_learning/leitner_box/screens/leitner84.dart';
import 'package:Fast_learning/leitner_box/screens/makeNewFlashcard.dart';
import 'package:Fast_learning/pages/childs/review_page/review_page.dart';
import 'package:Fast_learning/pages/childs/setting_page/setting_page.dart';
import 'package:Fast_learning/pages/home/home.dart';

import 'package:Fast_learning/zcomponent/homepage/bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/screens/course.dart';
import 'package:Fast_learning/leitner_box/screens/profile.dart';
import 'package:Fast_learning/leitner_box/screens/settings.dart';

class MakeAlive extends StatefulWidget {
  Widget widget;
  MakeAlive(this.widget);
  @override
  _MakeAliveState createState() => _MakeAliveState(widget);
}

class _MakeAliveState extends State<MakeAlive>
    with AutomaticKeepAliveClientMixin<MakeAlive> {
  @override
  bool get wantKeepAlive => true;
  _MakeAliveState(this.mywidget);
  final Widget mywidget;
  @override
  Widget build(BuildContext context) {
    super.build(
        context); // This line is important to ensure the mixin works correctly
    return mywidget;
  }
}

class CustomNavBarMain extends StatefulWidget {
  CustomNavBarMain({Key? key}) : super(key: key);

  @override
  State<CustomNavBarMain> createState() => _CustomNavBarMainState();
}

class _CustomNavBarMainState extends State<CustomNavBarMain> {
  int _currentIndex = 0;
  List _screens = [
    // {"screen": Home()},
    {"screen": Leitner5(key: PageStorageKey("Home"))},
    {"screen": ReviewPage(key: PageStorageKey("ReviewPage"))},
    {"screen": SettingPage(key: PageStorageKey("SettingPage"))},
    // {"screen": Profile(key: PageStorageKey("Profile"))},
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: CupertinoTabScaffold(
            // body: bottomNavbar1(),
            // body: PageStorage(
            //   bucket: bucket,
            //   child: _screens[_currentIndex]["screen"],
            // ),
            tabBuilder: (context, index) {
              return CupertinoTabView(
                builder: (context) {
                  return CupertinoPageScaffold(
                    child: _screens[index]["screen"],
                  );
                },
              );
            },
            tabBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Image.asset("assets/images/home-icon-active.png",
                        width: 24, height: 24),
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
                      child: Image.asset(
                        "assets/images/courses-active-icon.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                    label: "Courses",
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Image.asset(
                        "assets/images/courses-icon.png",
                        width: 24,
                        height: 24,
                      ),
                    )),
                BottomNavigationBarItem(
                    activeIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Image.asset(
                        "assets/images/settings-icon-active.png",
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
            )),
      ),
    );
  }

  Widget bottomNavbar1() {
    return HomePageWarperButtomNav();
  }

  BottomNavigationBar bottomNavbar2() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xff27187E),
      selectedLabelStyle: TextStyle(fontSize: 10, fontFamily: "Poppins"),
      unselectedLabelStyle: TextStyle(fontSize: 10, fontFamily: "Poppins"),
      unselectedItemColor: Color(0xff8a8a8a),
      currentIndex: _currentIndex,
      onTap: (value) {
        setState(() => _currentIndex = value);
      },
      items: [
        // for (var item in _screens)
        //   BottomNavigationBarItem(
        //     tooltip:
        //         "howhow how howhow how howhow how howhow how howhow how howhow how howhow how howhow how howhow how howhow how howhow how howhow how howhow how ",
        //     activeIcon: Padding(
        //       padding: const EdgeInsets.only(bottom: 3),
        //       child: Image.asset("assets/images/home-icon-active.png",
        //           width: 24, height: 24),
        //     ),
        //     label: "Home",
        //     icon: Padding(
        //       padding: const EdgeInsets.only(bottom: 3),
        //       child: Image.asset("assets/images/home-icon.png",
        //           width: 24, height: 24),
        //     ),
        //   ),
        BottomNavigationBarItem(
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Image.asset("assets/images/home-icon-active.png",
                width: 24, height: 24),
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
              child: Image.asset(
                "assets/images/courses-active-icon.png",
                width: 24,
                height: 24,
              ),
            ),
            label: "Courses",
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset(
                "assets/images/courses-icon.png",
                width: 24,
                height: 24,
              ),
            )),
        BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/images/settings-icon-active.png",
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
        // BottomNavigationBarItem(
        //     activeIcon: Padding(
        //       padding: const EdgeInsets.only(bottom: 2),
        //       child: Image.asset(
        //         "assets/images/profile-icon-active.png",
        //         width: 24,
        //         height: 24,
        //       ),
        //     ),
        //     label: "Profile",
        //     icon: Padding(
        //       padding: const EdgeInsets.only(bottom: 2),
        //       child: Image.asset(
        //         "assets/images/profile-icon.png",
        //         width: 24,
        //         height: 24,
        //       ),
        //     )),
      ],
    );
  }
}
