import 'package:Fast_learning/constants/preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

void show_hint(BuildContext context, List<GlobalKey> keys, bool do_show) {
  if (do_show) {
    // (WidgetsBinding.instance).addPostFrameCallback(
    //   (_) => ShowCaseWidget.of(context).startShowCase(keys),
    // );
  }
}
