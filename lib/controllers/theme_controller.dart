import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/model/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeContoller extends GetxController {
  String themeName = "Default";
  var mainContentFontSize = 14.0.obs;
  var mainContentFontWeightBold = FontWeight.bold.obs;
  TextStyle get mainContentStyle =>
      themeData.value.textTheme.bodyText1!.copyWith(
          fontSize: mainContentFontSize.value,
          fontWeight: mainContentFontWeightBold.value);

  var currentTheme = AppTheme("", null).obs;
  var themeData = ThemeData(
    primarySwatch: Colors.blue,
  ).obs;
  var themeIndex = 1.obs;
  ThemeContoller() {
    SharedPreferences.getInstance().then((prefs) {
      mainContentFontSize(
          prefs.getDouble(Preference.mainContentFontSize) ?? 14);
      mainContentFontWeightBold(
          (prefs.getBool(Preference.mainContentFontWeightISBold) ?? true)
              ? FontWeight.bold
              : FontWeight.normal);
      update();
      var temp = prefs.getInt(Preference.theme);
      if (temp != null) {
        themeIndex.value = temp;
      } else {
        prefs.setInt(Preference.theme, themeIndex.value);
      }
      buildThemeData();
    });

    // buildThemeData();
  }
  void buildThemeData({int? themeIndex}) {
    if (themeIndex != null) {
      SharedPreferences.getInstance().then((prefs) {
        var temp = prefs.getInt(Preference.theme);
        prefs.setInt(Preference.theme, themeIndex);
      });
      this.themeIndex.value = themeIndex;
    }
    currentTheme.value = myThemes(index: this.themeIndex.value);
    themeData(ThemeData(
        brightness: currentTheme.value.theme?.brightness,
        primarySwatch: currentTheme.value.theme?.primarySwatch,
        primaryColor: currentTheme.value.theme?.primaryColor,
        tabBarTheme: currentTheme.value.theme?.tabBarTheme,
        textTheme: currentTheme.value.theme?.textTheme,
        buttonTheme: currentTheme.value.theme?.buttonThemeData,
        inputDecorationTheme: currentTheme.value.theme?.inputDecorationTheme));
    update();
    // themeData.update((x) {
    //   x = ThemeData(
    //       brightness: currentTheme.value.theme.brightness,
    //       primarySwatch: currentTheme.value.theme.primarySwatch,
    //       primaryColor: currentTheme.value.theme.primaryColor,
    //       tabBarTheme: currentTheme.value.theme.tabBarTheme,
    //       textTheme: currentTheme.value.theme.textTheme,
    //       buttonTheme: currentTheme.value.theme.buttonThemeData,
    //       inputDecorationTheme: currentTheme.value.theme.inputDecorationTheme);
    // });
    //themeData.refresh();
  }
}
