import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/controllers/theme_controller.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/tools/tools.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spell_checker/spell_checker.dart';

class CardsController extends GetxController {
  ThemeContoller themeContoller = Get.find();
  var isSpellCheck = false.obs;
  var autoplaySpell = false.obs;
  var allSpellCheck = false.obs;
  var hasCardSpellCheck = false.obs;
  var showAnswer = false.obs;
  var tempSpallCheck = ''.obs;
  var selectedindex = 0.obs;

  var downloadLink = ''.obs;
  var percentage = 0.obs;
  var isDownloading = false.obs;
  var isImporting = false.obs;
  var dist = ''.obs;

  var textWidget = RichText(
      text: TextSpan(
    children: [],
  )).obs;
  final List<Box> boxes = <Box>[].obs;

  CardsController() {
    SharedPreferences.getInstance().then((prefs) {
      isSpellCheck(prefs.getBool(Preference.hasSpellCheck) ?? false);
      allSpellCheck(prefs.getBool(Preference.allSpellCheck) ?? false);
      autoplaySpell(prefs.getBool(Preference.autoplaySpell) ?? false);
    });

    rebind();
    const oneSec = Duration(seconds: 120);
    Timer.periodic(oneSec, (Timer t) => rebind());
  }

  var _cardItems = <TblCard>[].obs;
  List<TblCard> get cardItems => _cardItems;
  // Define a setter for the cardItems
  set cardItems(List<TblCard> value) {
    _cardItems(value);
  }

  var _cardsId = <int>[].obs;
  List<int> get cardsId => _cardsId;
  // Define a setter for the cardsId
  set cardsId(List<int> value) {
    _cardsId(value);
    // update(); // Update the state of the GetX object
  }

  var _isSelection = false.obs;
  bool get isSelection => _isSelection.value;
  // Define a setter for the isSelection
  set isSelection(bool value) {
    _isSelection(value);
    // update(); // Update the state of the GetX object
  }

  var _editCard = false.obs;
  bool get editCard => _editCard.value;
  // Define a setter for the editCard
  set editCard(bool value) {
    _editCard(value);
    // update(); // Update the state of the GetX object
  }

  var _isEditPosition = false.obs;
  bool get isEditPosition => _isEditPosition.value;
  // Define a setter for the isEditPosition
  set isEditPosition(bool value) {
    _isEditPosition(value);
    // update(); // Update the state of the GetX object
  }

  Future download_books(RootGroup rootgroup,
      {SubGroup? subgroup, bool useLastDownload = false, String? url}) async {
    isImporting(false);
    isDownloading(false);

    if (useLastDownload) {
      isImporting(true);
      try {
        if (subgroup != null) {
          await unzipFiles(
              rootGroup: rootgroup, subGroup: subgroup, givenPath: dist.value);
        } else
          await unzipFiles(rootGroup: rootgroup, givenPath: dist.value);
      } catch (e) {
        print(e);
        Get.snackbar('warning'.tr, 'File Not Found. Please download it again.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
      isImporting(false);

      return;
    }

    final dio = Dio();
    var tempDir = await getTemporaryDirectory();
    if (url != null) {
      this.downloadLink(url);
    }
    if (this.downloadLink.value.isEmpty) {
      isDownloading(false);
      return;
    }

    try {
      this.percentage.value = 0;
      isDownloading(true);
      final client = HttpClient();
      var uri = Uri.parse(this.downloadLink.value);
      this.dist.value = "${tempDir.path}/lastitem";
      final response = await dio.download(
        this.downloadLink.value,
        dist,
        onReceiveProgress: (count, total) {
          int percent = ((count) / 1000).floor();
          this.percentage.value = percent;
          if (percent > this.percentage.value + 1 || percent == 100) {}
        },
      );
      Get.back();
      if (rootgroup != null && subgroup != null) {
        Get.snackbar('Download Finished'.tr, 'Lessons has been downloaded.',
            backgroundColor: Colors.green, colorText: Colors.white);
        await unzipFiles(
            rootGroup: rootgroup, subGroup: subgroup, givenPath: dist.value);
      } else if (rootgroup != null) {
        Get.snackbar('Download Finished'.tr,
            'Book has been downloaded and Imported to the database',
            backgroundColor: Colors.green, colorText: Colors.white);
        await unzipFiles(rootGroup: rootgroup, givenPath: dist.value);
      } else {
        Get.snackbar('Download Finished'.tr,
            'Book has been downloaded and Imported to the database',
            backgroundColor: Colors.green, colorText: Colors.white);
        await unzipFiles(
            rootGroup: rootgroup, subGroup: subgroup, givenPath: dist.value);
      }
    } on DioError catch (e) {
      Get.snackbar('Download Error!',
          "Connection closed before full header was received. Check your internet connection and try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 10));
    } catch (e) {
      // Get.snackbar('warning'.tr, 'Check link or your internet connection',
      //     backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isDownloading(false);
    }
    // downloadLink('');
  }

  Future rebind() async {
    update();
    var temp = await calcBoxForCard();
    boxes.clear();
    boxes.addAll(temp);
  }

  void check({
    String input = '',
    String strAnswer = '',
    bool check = false,
    bool help = false,
    bool show = false,
  }) {
    final answer = strAnswer.toLowerCase().trim().split('');
    final words = input.toLowerCase().trim().split('');
    var temp = <TextSpan>[];
    // min answer.length and  words.length
    double lineHeight = 1;
    for (int i = 0; i < answer.length; i++) {
      if (['\n', ' ', ',', '"', '.', ':', '?', '!'].contains(answer[i])) {
        temp.add(TextSpan(
            text: answer[i],
            style: TextStyle(
              // decoration: TextDecoration.underline,
              letterSpacing: 5,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              height: lineHeight,
              color: themeContoller.themeData.value.primaryColor,
            )));
      } else {
        temp.add(TextSpan(
            text: '_',
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 25,
              height: lineHeight,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            )));
      }
    }
    textWidget(RichText(
        text: TextSpan(
      children: temp,
    )));
    bool isCorrect = true;
    if (show) {
      for (int i = 0; i < answer.length; i++) {
        temp[i] = TextSpan(
            text: answer[i],
            style: TextStyle(
                // letterSpacing: 3,
                fontSize: 25,
                height: lineHeight,
                fontWeight: FontWeight.bold,
                color: Colors.green));
      }
    } else if (words.length == answer.length || check || help) {
      for (int i = 0; i < min(answer.length, words.length); i++) {
        if (words[i] == answer[i]) {
          temp[i] = TextSpan(
              text: words[i],
              style: TextStyle(
                  // letterSpacing: 5,
                  fontSize: 25,
                  height: lineHeight,
                  fontWeight: FontWeight.bold,
                  color: Colors.green));
        } else {
          isCorrect = false;
          temp[i] = TextSpan(
              text: help ? answer[i] : words[i],
              style: TextStyle(
                // letterSpacing: 5,
                fontSize: 25,
                height: lineHeight,
                decoration:
                    help ? TextDecoration.underline : TextDecoration.none,
                fontWeight: FontWeight.bold,
                color: help ? Colors.green : Colors.red,
              ));
        }

        textWidget(RichText(
            text: TextSpan(
          children: temp,
        )));

        if (words.length == answer.length) showAnswer(isCorrect);
      }
    } else {
      for (int i = 0; i < min(answer.length, words.length); i++) {
        temp[i] = TextSpan(
            text: words[i],
            style: TextStyle(
              // letterSpacing: 5,
              height: lineHeight,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ));
      }
    }
  }

  void clearTextWidget() {
    textWidget(RichText(
        text: TextSpan(
      children: [],
    )));
  }

// optional distance parameter. Default is 1.0
  // var checker = SingleWordSpellChecker(distance: 1.0);

  // // var dictionary = ["apple", "apples", "pear", "ear"];
  // var dictionary = answer.split(',');
  // checker.addWords(dictionary);

  // List<Result> matches = checker.find("apple");
  // print(matches);
  // final c = input[0];
  // void rebind() {
  //   boxes.clear();
  //   calcBoxForCard().then((value) {
  //     boxes.addAll(value);
  //   });
  // }
}
