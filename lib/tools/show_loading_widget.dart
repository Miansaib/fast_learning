import 'dart:async';

import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/tools/tools.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../add_token.dart';

class LoadingIndicatorDialog {
  LoadingIndicatorDialog._internal();

  static final LoadingIndicatorDialog _singleton =
      LoadingIndicatorDialog._internal();
  late BuildContext _context;

  factory LoadingIndicatorDialog() {
    return _singleton;
  }

  show(StreamSubscription dataSub, {String text = 'Loading...'}) async {
    await Get.defaultDialog(
      title: text,
      content: WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  onPressed: () {
                    dataSub.cancel();
                    Get.back();
                  },
                  child: Text("Cancle"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  dismiss(Function fun) {
    fun();
  }
}

List<Widget> get_popup_widget(
    String cancle_text,
    Future Function() cancle_func,
    String confrim_text,
    Future Function(List<String>?) confrim_func,
    String loadin_message,
    BuildContext context) {
  return [
    TextButton(
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(100)),
        ),
        onPressed: () async {
          Get.back();
          StreamSubscription dataSub;

          dataSub = cancle_func().asStream().listen((event) {
            Get.back();
          });
          await LoadingIndicatorDialog().show(dataSub, text: loadin_message);
        },
        child: Text(cancle_text)),
    TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // backgroundColor: Get.theme.backgroundColor,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(100)),
      ),
      child: Text(
        confrim_text,
      ),
      onPressed: () async {
        StreamSubscription dataSub;
        final tokens = await get_token(context);
        if (tokens == null) {
          Get.back();
          Get.snackbar('warning', 'please add token',
              backgroundColor: Colors.red, colorText: Colors.white);

          return;
        }
        dataSub = confrim_func(tokens).asStream().listen((event) async {
          Get.back();
        });
        await LoadingIndicatorDialog().show(dataSub, text: "loadin_message");
      },
    )
  ];
}

Future<List<String>?> get_token(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (_) => Material(
      type: MaterialType.transparency,
      child: Center(
        // Aligns the container to center
        child: Container(
          // A simplified version of dialog.
          width: 300.0,
          height: 400.0,
          decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.circular(15)),
          child: AddTokens(),
        ),
      ),
    ),
  );
}
