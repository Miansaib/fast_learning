import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future<void> download_dialog(
    {Function()? onPressed,
    onPressedUseLastDownload,
    bool showUrlSection = true}) async {
  CardsController _cardsController = Get.find();
  await Get.defaultDialog(

      // cancel: ,
      actions: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.only(left: 8.0, right: 8),
                      backgroundColor: Get.theme.backgroundColor,
                    ),
                    child: Text("Minimize",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                  // useLastDownload(onPressedUseLastDownload, _cardsController)
                ],
              ),
              Container(
                // width: Get.width,
                child: ElevatedButton(
                  onPressed: () => onPressed != null ? onPressed() : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.only(left: 8.0, right: 8),
                    backgroundColor: Get.theme.primaryColor,
                  ),
                  child: Obx(() {
                    if (_cardsController.isDownloading.value) {
                      var formatter = NumberFormat('###,###');
                      return Text(
                          "Downloading: ${formatter.format(_cardsController.percentage.value)} KB");
                    }
                    return Text("Download",
                        style: TextStyle(fontSize: 15, color: Colors.white));
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
      // confirm: ,
      // barrierDismissible: false,
      title: showUrlSection ? "Insert Download Link" : "Download Options",
      content: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: [
              Visibility(
                visible: showUrlSection,
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    initialValue: _cardsController.downloadLink.value,
                    enabled: true,
                    // controller: txtReply,
                    autocorrect: false,
                    enableSuggestions: false,
                    autofocus: false,
                    onChanged: (value) {
                      _cardsController.downloadLink(value);
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    minLines: 1,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Your Link'),
                  ),
                ),
              ),
              Obx(() {
                if (_cardsController.isDownloading.value)
                  return Column(
                    children: [
                      LinearProgressIndicator(
                          // value: _cardsController.percentageValue.value,
                          ),
                    ],
                  );
                return Container();
              }),
            ],
          )));
}

ElevatedButton useLastDownload(
    onPressedUseLastDownload, CardsController _cardsController) {
  return ElevatedButton(
    onPressed: () {
      if (onPressedUseLastDownload != null &&
          _cardsController.dist.value.isNotEmpty) onPressedUseLastDownload();
    },
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.only(left: 8.0, right: 8),
      backgroundColor: Get.theme.backgroundColor,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        if (_cardsController.isImporting.value) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Use Last Download",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  )),
              CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ],
          );
        }
        return Text("Use Last Download", style: TextStyle(fontSize: 15));
      }),
    ),
  );
}
