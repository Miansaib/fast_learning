import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/model/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationController extends GetxController {
  TextEditingController fromLangController = TextEditingController();
  TextEditingController toLangController = TextEditingController();
  TranslationController() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getInt(Preference.fromLang) != null)
        fromLang = prefs.getInt(Preference.fromLang)!;
      else {
        prefs.setInt(Preference.fromLang, -1);
        fromLang = -1;
      }
      if (prefs.getInt(Preference.toLang) != null)
        toLang = prefs.getInt(Preference.toLang)!;
      else {
        prefs.setInt(Preference.toLang, 0);
        toLang = 0;
      }
      update();
    });

    // buildThemeData();
  }
  var _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading(value);
  }

  var _fromLang = (-1).obs;
  int get fromLang => _fromLang.value;
  set fromLang(int value) {
    _fromLang(value);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(Preference.fromLang, value);
    });
  }

  var _toLang = (0).obs;
  int get toLang => _toLang.value;
  set toLang(int value) {
    _toLang(value);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(Preference.toLang, value);
    });
  }

  var _sourceText = ''.obs;
  String get sourceText => _sourceText.value;
  set sourceText(String value) {
    _sourceText(value);
  }

  var _translated = ''.obs;
  String get translated => _translated.value;
  set translated(String value) {
    _translated(value);
  }

  translate(String? text) async {
    isLoading = true;
    try {
      final response =
          // await http.post(Uri.http("libretranslate.com", "/translate"),
          await http.post(Uri.http("51.222.106.104", "/translate"),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                "q": text,
                "source": fromLang == -1 ? 'auto' : keysOptions[fromLang],
                "target": keysOptions[toLang],
                "format": "text",
                "api_key": "c3de577b-8296-4772-b8fd-06fe9ad3d8b2",
              }));
      // print(response.body);
      translated = jsonDecode(response.body)['translatedText'];
    } catch (e) {
      Get.snackbar('warning'.tr, e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading = false;
    }
  }

  List<String> options = [
    "English",
    "Arabic",
    "Azerbaijani",
    "Catalan",
    "Chinese",
    "Czech",
    "Danish",
    "Dutch",
    "Esperanto",
    "Finnish",
    "French",
    "German",
    "Greek",
    "Hebrew",
    "Hindi",
    "Hungarian",
    "Indonesian",
    "Irish",
    "Italian",
    "Japanese",
    "Korean",
    "Persian",
    "Polish",
    "Portuguese",
    "Russian",
    "Slovak",
    "Spanish",
    "Swedish",
    "Turkish",
    "Ukranian"
  ];

  List<String> keysOptions = [
    "en",
    "ar",
    "az",
    "ca",
    "zh",
    "cs",
    "da",
    "nl",
    "eo",
    "fi",
    "fr",
    "de",
    "el",
    "he",
    "hi",
    "hu",
    "id",
    "ga",
    "it",
    "ja",
    "ko",
    "fa",
    "pl",
    "pt",
    "ru",
    "sk",
    "es",
    "sv",
    "tr",
    "uk",
  ];

  String getLang(int? langIndex) {
    String result = keysOptions[0];
    if (langIndex != null) result = keysOptions[langIndex];

    return result;
  }
}
