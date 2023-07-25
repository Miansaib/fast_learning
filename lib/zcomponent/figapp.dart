import 'package:Fast_learning/leitner_box/languagebook.dart';
import 'package:Fast_learning/leitner_box/main.dart';
import 'package:Fast_learning/leitner_box/navBar.dart';
import 'package:Fast_learning/leitner_box/screens/leitner5.dart';
import 'package:Fast_learning/leitner_box/screens/myFolders.dart';
import 'package:Fast_learning/leitner_box/screens/myFolders2.dart';
import 'package:Fast_learning/nested_navigator/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';
import '../main.dart';
import 'homepage/bottom_navigation.dart';
import 'homepage/folder/controller/foldercontroller.dart';
import 'homepage/homepage.dart';

class FigApp extends StatelessWidget {
  final Locale currentLocal;
  final themeController = Get.put(ThemeContoller());
  FigApp(this.currentLocal);

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: Messages(), // your translations
          locale: currentLocal, // translations will be displayed in that locale
          fallbackLocale: Locale('en', 'UK'),
          title: 'Fast Learning',
          theme: themeController.themeData.value,
          // home: Home()
          // home: HomePageWarperButtomNav(),
          // home: CustomNavBarMain(),
          home: NastedApp(),
          // home: TabScaffoldApp(),
          // home: myFolders(),
          // home: languagebook(),
        ));
  }
}
