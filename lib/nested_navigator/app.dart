import 'package:Fast_learning/zcomponent/homepage/folder/view/allfolder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../leitner_box/screens/in_progress/inProgress.dart';
import '../leitner_box/screens/leitner5.dart';
import '../pages/childs/review_page/review_page.dart';
import '../pages/childs/setting_page/setting_page.dart';
import '../zcomponent/homepage/folder/controller/foldercontroller.dart';
import './bottom_navigation.dart';
import './tab_item.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class NastedApp extends StatefulWidget {
  const NastedApp({super.key});

  @override
  State<StatefulWidget> createState() => NastedAppState();
}

class NastedAppState extends State<NastedApp> {
  var _currentTab = TabItem.home;
  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.inProgress: GlobalKey<NavigatorState>(),
    TabItem.review: GlobalKey<NavigatorState>(),
    TabItem.setting: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.home) {
            // select 'main' tab
            _selectTab(TabItem.home);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          Offstage(
              offstage: _currentTab != TabItem.home,
              child: Navigator(
                key: _navigatorKeys[TabItem.home],
                initialRoute: TabNavigatorRoutes.root,
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => Leitner5(),
                  );
                },
              )),
          Offstage(
              offstage: _currentTab != TabItem.inProgress,
              child: Navigator(
                key: _navigatorKeys[TabItem.inProgress],
                initialRoute: TabNavigatorRoutes.root,
                onGenerateRoute: (routeSettings) {
                  FolderController fc = Get.find();
                  return MaterialPageRoute(
                    builder: (context) => InProgressScreen(),
                  );
                },
              )),
          Offstage(
              offstage: _currentTab != TabItem.review,
              child: Navigator(
                key: _navigatorKeys[TabItem.review],
                initialRoute: TabNavigatorRoutes.root,
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => ReviewPage(),
                  );
                },
              )),
          Offstage(
              offstage: _currentTab != TabItem.setting,
              child: Navigator(
                key: _navigatorKeys[TabItem.setting],
                initialRoute: TabNavigatorRoutes.root,
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => SettingPage(),
                  );
                },
              )),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }
}
