import 'dart:io';

import 'package:Fast_learning/card_revview.dart';
import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/model.dart';

class ReviewBooks extends StatefulWidget {
  ReviewBooks({Key? key}) : super(key: key);

  @override
  _ReviewBooksState createState() => _ReviewBooksState();
}

class _ReviewBooksState extends State<ReviewBooks> {
  CardsController _cardsController = Get.find<CardsController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: SubGroup().select().toList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SubGroup>> subgroups) {
          if (subgroups.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: subgroups.data!.map((e) {
              return GestureDetector(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  Get.to(() => CardReviewPage(
                        subGroupId: e.id!,
                        prefs: prefs,
                      ));
                },
                child: Card(
                    child: ListTile(
                  leading: (e.imagePath == null || e.imagePath!.isEmpty)
                      ? SizedBox(
                          height: 80,
                          width: 80,
                        )
                      : SizedBox(
                          height: 80,
                          width: 80,
                          child: Image.file(
                            File(e.imagePath!),
                            height: 80,
                            width: 80,
                          )),
                  title: Text(e.title!),
                  subtitle: Obx(
                    () => Text('card_ready_count'.tr +
                        ' : ' +
                        _cardsController.boxes
                            .where((element) => element.subGroup!.id == e.id!)
                            .length
                            .toString()),
                  ),
                  // trailing: Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     InkWell(
                  //       onTap: () async {},
                  //       child: Icon(Icons.edit),
                  //     ),
                  //     Container(
                  //       width: 8,
                  //     ),
                  //     InkWell(
                  //       onTap: () async {
                  //         // await Get.to(LessonAdd(Lesson(subGroupId: e.id)));
                  //         // Get.to(AudioRecorder());
                  //         // Get.to(VoiceRecord());
                  //       },
                  //       child: Icon(Icons.add),
                  //     ),
                  //   ],
                  // ),
                )),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
