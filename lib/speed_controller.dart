import 'package:Fast_learning/constants/preference.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/base_music_speed_controller.dart';

class SpeedController extends BaseMusicSpeedController {
  SpeedController() {
    SharedPreferences.getInstance()
        .then((prefs) => speed(prefs.getDouble(Preference.speed) ?? 1.0));
  }
  void changeSpeed(double value) {
    speed(value);
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setDouble(Preference.speed, value));
  }
}

class QuestionReviewSpeedController extends BaseMusicSpeedController {
  QuestionReviewSpeedController() {
    SharedPreferences.getInstance().then((prefs) =>
        speed(prefs.getDouble(Preference.questionReviewSpeed) ?? 1.0));
  }
  void changeSpeed(double value) {
    print("change");
    SharedPreferences.getInstance().then((prefs) {
      speed(value);
      return prefs.setDouble(Preference.questionReviewSpeed, value);
    });
  }
}

class ReplyReviewSpeedController extends BaseMusicSpeedController {
  ReplyReviewSpeedController() {
    SharedPreferences.getInstance().then(
        (prefs) => speed(prefs.getDouble(Preference.replyReviewSpeed) ?? 1.0));
  }
  void changeSpeed(double value) {
    speed(value);
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setDouble(Preference.replyReviewSpeed, value));
  }
}

class DescriptionReviewSpeedController extends BaseMusicSpeedController {
  DescriptionReviewSpeedController() {
    SharedPreferences.getInstance().then((prefs) =>
        speed(prefs.getDouble(Preference.descriptionReviewSpeed) ?? 1.0));
  }
  void changeSpeed(double value) {
    speed(value);
    SharedPreferences.getInstance().then(
        (prefs) => prefs.setDouble(Preference.descriptionReviewSpeed, value));
  }
}
