import 'package:Fast_learning/review_books.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

import 'package:Fast_learning/controllers/review_controller.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/tools/export/subgroup_page.dart';
import 'package:Fast_learning/tools/helper.dart';
import 'package:Fast_learning/zcomponent/common_widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../card_revview.dart';
import '../../../../constants/preference.dart';
import '../../../../controllers/cards_controller.dart';
import 'package:darq/darq.dart';

import '../../../../controllers/theme_controller.dart';
import 'childs/review_books_has_cards.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  CardsController _cardsController = Get.find<CardsController>();

  ThemeContoller themeContoller = Get.find<ThemeContoller>();

  List<SubGroup?> subgroups = [];

  final MainReviewController rc = Get.find();

  @override
  Future<List<SubGroup?>> boxfetcher() async {
    await _cardsController.rebind();
    rc.booksItem = _cardsController.boxes
        .map((i) {
          return i.subGroup!;
        })
        .toList()
        .distinct((r) {
          return r!.id!;
        })
        .toList();
    rc.update();
    subgroups = rc.booksItem;
    return subgroups;
  }

  Widget newBookTile({required SubGroup book, required int index}) {
    return InkWell(
        onLongPress: rc.isEditPosition
            ? null
            : (() {
                rc.selectionMethod(index);
                print(rc.booksId);
                setState(() {});
                rc.update();
              }),
        onTap: () async {
          if (rc.isSelection) {
            rc.selectionMethod(index);
            setState(() {});
            return;
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Navigator.of(context).push(
            CupertinoPageRoute<void>(
              builder: (BuildContext context) {
                return CupertinoPageScaffold(
                    child: CardReviewPage(
                  subGroupId: book.id!,
                  prefs: prefs,
                  caseType: book.caseType!,
                ));
              },
            ),
          );
          // Get.to(() => CardReviewPage(
          //       subGroupId: book.id!,
          //       prefs: prefs,
          //       caseType: book.caseType!,
          //     ));
          // Lesson? lesson = await (Lesson().getById(e.id, preload: true));
        },
        child: bookItm(book: book, index: index));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rc.booksId.clear();
    rc.isSelection = false;
    rc.editBook = false;
    boxfetcher();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          return Column(
            children: [
              app_Bar(
                title_text: "Review",
                canGoBack: false,
              ),
              Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton(
                      fontSize: 15,
                      width: Get.size.width / 2.5,
                      label: "Reset Selected Books",
                      image: Image.asset(
                        'assets/images/undo.png',
                        width: 40,
                        height: 40,
                      ),
                      // icon: Icons.change_circle_outlined,
                      borderColor: Color(0xff27187e),
                      iconColor: Color(0xff27187e),
                      isEnabled: rc.isSelection,
                      onPressed: !rc.isSelection
                          ? null
                          : () async {
                              bool? result = await Get.defaultDialog(
                                  title: 'warning'.tr,
                                  middleText:
                                      'Are you sure to pull out all card from review section?',
                                  confirmTextColor: Colors.white,
                                  onCancel: () {},
                                  onConfirm: () {
                                    Get.back(result: true);
                                  });
                              if (result == true) {
                                for (var item in rc.booksId) {
                                  final book = subgroups[item];
                                  UITools(Get.context!)
                                      .showWaitScreen('Waiting', null, null);
                                  List<Lesson> lessons = await Lesson()
                                      .select()
                                      .subGroupId
                                      .equals(book!.id)
                                      .toList();
                                  for (Lesson lesson in lessons) {
                                    List<TblCard> cards = await TblCard()
                                        .select()
                                        .lessonId
                                        .equals(lesson.id)
                                        .toList();
                                    for (int i = 0; i < cards.length; i++) {
                                      cards[i].reviewStart = false;
                                      await cards[i].save();
                                    }
                                    Get.back();
                                  }
                                }

                                await boxfetcher();
                                rc.booksId.clear();
                                rc.isSelection = false;
                                rc.editBook = false;
                                rc.update();
                                setState(() {});
                              }
                              // rc.isEditPosition = !rc.isEditPosition;
                            },
                    ),
                    // buildButton(
                    //         width: Get.size.width / 4,
                    //         label: "Send To Review",
                    //         image: Image.asset(
                    //           'assets/images/repeat.png',
                    //           width: 30,
                    //           height: 30,
                    //         ),
                    //         // icon: Icons.change_circle_outlined,
                    //         borderColor: Color(0xff27187e),
                    //         iconColor: Color(0xff27187e),
                    //         isEnabled: rc.isSelection,
                    //         onPressed: !rc.isSelection
                    //             ? null
                    //             : () async {
                    //                 bool? result = await Get.defaultDialog(
                    //                     title: 'warning'.tr,
                    //                     middleText:
                    //                         'Are you sure to push all card to review section?',
                    //                     confirmTextColor: Colors.white,
                    //                     onCancel: () {},
                    //                     onConfirm: () {
                    //                       Get.back(result: true);
                    //                     });
                    //                 print(result);

                    //                 if (result == true) {
                    //                   for (var item in rc.booksId) {
                    //                     final book = subgroups[item];
                    //                     // rc.isEditPosition = !rc.isEditPosition;
                    //                     List<Lesson> lessons = await Lesson()
                    //                         .select()
                    //                         .subGroupId
                    //                         .equals(book!.id)
                    //                         .toList();
                    //                     UITools(Get.context!)
                    //                         .showWaitScreen('Waiting', null,null);
                    //                     for (Lesson lesson in lessons) {
                    //                       List<TblCard> cards = await TblCard()
                    //                           .select()
                    //                           .lessonId
                    //                           .equals(lesson.id)
                    //                           .toList();
                    //                       for (int i = 0; i < cards.length; i++) {
                    //                         cards[i].reviewStart = true;
                    //                         await cards[i].save();
                    //                       }
                    //                     }
                    //                     Get.back();

                    //                     //
                    //                   }
                    //                 }
                    //                 await boxfetcher();
                    //                 rc.booksId.clear();
                    //                 rc.isSelection = true;
                    //                 rc.editBook = false;
                    //                 rc.update();
                    //                 setState(() {});
                    //               },
                    //       ),
                  ],
                ),
              ),
              Expanded(child: GetBuilder<CardsController>(builder: (cc) {
                return FutureBuilder(
                    future: boxfetcher(),
                    builder: (context, AsyncSnapshot<List<SubGroup?>> subg) {
                      if (!subg.hasData)
                        return Center(child: CircularProgressIndicator());

                      print(subg.data!.length);
                      return ListView(children: [
                        for (var index = 0; index < subg.data!.length; index++)
                          newBookTile(book: subg.data![index]!, index: index)
                        // oldBookTile(book: subg.data![index]!, index: index)
                      ]);
                    });
              })),
            ],
          );
        }),
      ),
    );
  }

  Widget bookItm({required SubGroup book, required int index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: rc.booksId.contains(index)
              ? Color.fromARGB(52, 39, 24, 126)
              : Colors.white,
        ),
        child: Row(
          children: [
            Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: rc.booksId.contains(index)
                      ? Color.fromARGB(52, 39, 24, 126)
                      : Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 100, spreadRadius: 1)
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: book.imagePath!.isEmpty
                        ? Image.asset(
                            'assets/images/noimage.png',
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(
                              book.imagePath!,
                            ),
                            fit: BoxFit.cover))),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: rc.booksId.contains(index)
                          ? Color.fromARGB(52, 39, 24, 126)
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            spreadRadius: .1)
                      ],
                    ),
                    height: 96,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        //mainAxisSize:MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title!.toString(),
                            style: TextStyle(
                              color: Color(0xff353535),
                              fontSize: 18,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            height: 5,
                          ),
                          // FutureBuilder(
                          //   future: e.getTblCards()?.toList(),
                          //   builder: (BuildContext context,
                          //       AsyncSnapshot<List<TblCard>> subGroups) {
                          //     if (subGroups.data == null) {
                          //       return Container();
                          //     }
                          //     return Text(subGroups.data!.length.toString() +
                          //         " FlashCard");
                          //   },
                          // ),
                          Text(_cardsController.boxes
                                  .where((element) =>
                                      element.subGroup!.id == book.id!)
                                  .length
                                  .toString() +
                              " Flashcards"),
                          Container(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 8.0),
                  //   child: Align(
                  //     alignment: Alignment.bottomRight,
                  //     child: FutureBuilder(
                  //         future: getStatisticWidgets(e.id!),
                  //         builder: (context, AsyncSnapshot<Widget?> snapshaot) {
                  //           if (snapshaot.hasData) {
                  //             return Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: snapshaot.data!,
                  //             );
                  //           }
                  //           return Container();
                  //         }),
                  //   ),
                  // ),
                  FutureBuilder(
                      future: rc.getinfo(book),
                      builder: (context, AsyncSnapshot<double?> snapshot) {
                        return Positioned(
                          right: 10,
                          top: 5,
                          child: (!snapshot.hasData)
                              ? CircularProgressIndicator()
                              : CircularPercentIndicator(
                                  radius: 22,
                                  backgroundColor: Color(0x20FF8600),
                                  progressColor: Color(0xffFF8600),
                                  percent: snapshot.data!,
                                  center: Text(
                                    '%${(snapshot.data! * 100).toInt()}',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                  ),
                                ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget oldBookTile({required SubGroup book, required int index}) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Get.to(() => CardReviewPage(
              subGroupId: book.id!,
              prefs: prefs,
              caseType: book.caseType!,
            ));
      },
      child: Card(
          child: ListTile(
        // leading: (e!.imagePath == null || e.imagePath!.isEmpty)
        //     ? SizedBox(
        //         height: 80,
        //         width: 80,
        //       )
        //     : SizedBox(
        //         height: 80,
        //         width: 80,
        //         child: Image.file(
        //           File(e.imagePath!),
        //           height: 80,
        //           width: 80,
        //         )),
        leading: Container(
          width: 80,
          height: 80,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: themeContoller.themeData.value.primaryColor,
              shape: BoxShape.circle,
              image: book.imagePath!.isEmpty
                  ? DecorationImage(
                      image: AssetImage('assets/images/noimage.png'))
                  : DecorationImage(
                      image: FileImage(
                      File(
                        book.imagePath!,
                      ),
                    ))),
        ),
        title: Text(book.title!),
        subtitle: Text('card_ready_count'.tr +
            ' : ' +
            _cardsController.boxes
                .where((element) => element.subGroup!.id == book.id!)
                .length
                .toString()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: () async {
                  bool? result = await Get.defaultDialog(
                      title: 'warning'.tr,
                      middleText:
                          'Are you sure to pull out all card from review section?',
                      confirmTextColor: Colors.white,
                      onCancel: () {},
                      onConfirm: () {
                        Get.back(result: true);
                      });
                  print(result);
                  if (result == true) {
                    UITools(Get.context!).showWaitScreen('Waiting', null, null);
                    List<Lesson> lessons = await Lesson()
                        .select()
                        .subGroupId
                        .equals(book.id)
                        .toList();
                    for (Lesson lesson in lessons) {
                      List<TblCard> cards = await TblCard()
                          .select()
                          .lessonId
                          .equals(lesson.id)
                          .toList();
                      for (int i = 0; i < cards.length; i++) {
                        cards[i].reviewStart = false;
                        await cards[i].save();
                      }
                    }
                    _cardsController.rebind();
                    //
                    Navigator.of(Get.context!).pop();
                  }
                  setState(() {});
                },
                child: Icon(Icons.outbond,
                    color: themeContoller.themeData.value.primaryColor)),
            Container(width: 5),
            InkWell(
                onTap: () async {
                  bool? result = await Get.defaultDialog(
                      title: 'warning'.tr,
                      middleText:
                          'Are you sure to push all card to review section?',
                      confirmTextColor: Colors.white,
                      onCancel: () {},
                      onConfirm: () {
                        Get.back(result: true);
                      });
                  print(result);
                  if (result == true) {
                    List<Lesson> lessons = await Lesson()
                        .select()
                        .subGroupId
                        .equals(book.id)
                        .toList();
                    UITools(Get.context!).showWaitScreen('Waiting', null, null);
                    for (Lesson lesson in lessons) {
                      List<TblCard> cards = await TblCard()
                          .select()
                          .lessonId
                          .equals(lesson.id)
                          .toList();
                      for (int i = 0; i < cards.length; i++) {
                        cards[i].reviewStart = true;
                        await cards[i].save();
                      }
                    }
                    _cardsController.rebind();
                    //
                    Navigator.of(Get.context!).pop();
                  }
                  setState(() {});
                },
                child: Icon(Icons.input,
                    color: themeContoller.themeData.value.primaryColor)),
          ],
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
  }
}
