import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:Fast_learning/card_view_page.dart';
import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:Fast_learning/controllers/inapp_purchase_controller.dart';
import 'package:Fast_learning/controllers/lessons_controller.dart';
import 'package:Fast_learning/controllers/theme_controller.dart';
import 'package:Fast_learning/leitner_box/customWidgets/circule_number.dart';
import 'package:Fast_learning/leitner_box/customWidgets/percentageCircle.dart';
import 'package:Fast_learning/pages/buy_subscription/buy_subscription_page.dart';
import 'package:Fast_learning/tools/download_dialog.dart';
import 'package:Fast_learning/tools/show_loading_widget.dart';
import 'package:Fast_learning/zcomponent/common_widget/buttons.dart';
import 'package:Fast_learning/zcomponent/common_widget/dottedbtn.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:Fast_learning/card_page.dart';
import 'package:Fast_learning/customcard_page.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/password_dialog.dart';
import 'package:Fast_learning/tools/export/select_lessons.dart';
import 'package:Fast_learning/tools/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InProgressLessonPage extends StatefulWidget {
  final SubGroup subGroup;
  final int radioSelected;

  InProgressLessonPage({
    Key? key,
    required this.subGroup,
    required this.radioSelected,
  }) : super(key: key);

  @override
  _InProgressLessonPageState createState() => _InProgressLessonPageState();
}

enum RadioOptions { All, Learned, Review }

class _InProgressLessonPageState extends State<InProgressLessonPage> {
  final _radioStream = BehaviorSubject.seeded(RadioOptions.All.index);

  Stream<int> get radioStream => _radioStream.stream;
  int? _value;

  @override
  void dispose() {
    _radioStream.close();
    super.dispose();
  }

  @override
  void initState() {
    _value = widget.radioSelected;
    _radioStream.add(widget.radioSelected);
    // lc.update();
    super.initState();
  }

  List<int> viewItems = [];
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  CardsController _cardsController = Get.find<CardsController>();
  MainLessonsController lc = Get.find();

  List<Lesson> filterdList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,

        // centerTitle: true,
        title: Text(
          widget.subGroup.title!,
          style: TextStyle(
            color: Color(0xff353535),
            fontSize: 18,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: Row(
          children: [
            Container(
              padding: EdgeInsetsDirectional.only(start: 10),
              child: InkWell(
                child: Icon(
                  CupertinoIcons.back,
                  color: Color(0xff353535),
                ),
                onTap: () {
                  // Get.back();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<int>(
                    stream: radioStream,
                    builder: (context, radioSnapshot) {
                      return FutureBuilder(
                        future: Lesson()
                            .select()
                            .subGroupId
                            .equals(widget.subGroup.id)
                            .orderBy('orderIndex')
                            .toList(loadParents: false, preload: false),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Lesson>> lessons) {
                          if (!lessons.hasData) {
                            return Container();
                          }
                          filterdList = lessons.data!;
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ReorderableListView(
                                padding: EdgeInsets.only(bottom: 100.0),
                                onReorder: (oldIndex, newIndex) {
                                  setState(() {
                                    if (newIndex < oldIndex) {
                                      int order =
                                          filterdList[newIndex].orderIndex!;
                                      final item =
                                          filterdList.removeAt(oldIndex);

                                      filterdList.insert(newIndex, item);
                                      filterdList[newIndex]
                                        ..orderIndex = order
                                        ..save();
                                      order++;
                                      print(order);
                                      for (var i = newIndex + 1;
                                          i < filterdList.length;
                                          i++) {
                                        filterdList[i]
                                          ..orderIndex = order
                                          ..save();
                                      }
                                    } else {
                                      newIndex -= 1;

                                      int order =
                                          filterdList[newIndex].orderIndex!;
                                      final item =
                                          filterdList.removeAt(oldIndex);

                                      filterdList.insert(newIndex, item);
                                      filterdList[newIndex]
                                        ..orderIndex = order
                                        ..save();
                                      order--;
                                      print(order);
                                      for (var i = newIndex - 1; i >= 0; i--) {
                                        filterdList[i]
                                          ..orderIndex = order
                                          ..save();
                                      }
                                    }
                                  });
                                },
                                children: lessonItemGenFiltered(
                                    lessons, radioSnapshot)),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> lessonItemGenFiltered(
      AsyncSnapshot<List<Lesson>> lessons, AsyncSnapshot<int> radioSnapshot) {
    List<Widget> lessonTiles = [];
    for (int i = 0; i < lessons.data!.length; i++) {
      var e = lessons.data![i];
      lessonTiles.add(FutureBuilder<List<TblCard>>(
        key: ValueKey("$i"),
        future: TblCard().select().lessonId.equals(e.id).toList(),
        builder: (context, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());

          // IF choose all cards
          if ((radioSnapshot.data! == RadioOptions.All.index) ||
              // IF choose review cards
              (snap.data!
                          .where((x) =>
                              (x.reviewStart == false && x.examDone == false))
                          .toList()
                          .length >
                      0 &&
                  radioSnapshot.data! == RadioOptions.Review.index) ||
              // IF choose not learned cards
              (snap.data!
                      .where((x) => x.examDone == true)
                      .toList()
                      .isNotEmpty &&
                  radioSnapshot.data! == RadioOptions.Learned.index)) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: LessonTile(e, radioSnapshot.data!, i),
            );
          } else {
            filterdList.removeWhere((item) => item.id == e.id);
            return Container();
          }
        },
      ));
    }
    return lessonTiles;
  }

  Widget LessonTile(
      Lesson e,
      // List<Lesson> filterdList,
      int radioSelected,
      int index) {
    return InkWell(
        onTap: () async {
          viewItems.add(e.id!);
          Lesson? lesson = await (Lesson().getById(e.id, preload: true));
          print(index);
          await Navigator.of(context).push(
            CupertinoPageRoute<void>(
              builder: (BuildContext context) {
                return CupertinoPageScaffold(
                    resizeToAvoidBottomInset: true,
                    child: CustomCardPage(
                        lesson: lesson!,
                        list_of_lessons: filterdList,
                        lesson_index: index,
                        radioSelected: radioSelected,
                        isEditable: false));
              },
            ),
          );
          // await Get.to(() => CustomCardPage(
          //     lesson: lesson!,
          //     list_of_lessons: filterdList,
          //     lesson_index: index,
          //     radioSelected: radioSelected));
          setState(() {});
        },
        child: lessonItem(e, index));
  }

  Widget lessonItem(Lesson e, int index) {
    return Container(
      decoration: (viewItems.indexOf(e.id!) > -1)
          ? BoxDecoration(
              color: lc.lessonId.contains(index)
                  ? Color.fromARGB(52, 39, 24, 126)
                  : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 2, color: Color(0xff27187E)))
          : BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: lc.lessonId.contains(index)
                  ? Color.fromARGB(52, 39, 24, 126)
                  : Colors.white,
            ),
      child: Row(
        children: [
          Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 100, spreadRadius: 1)
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  child: e.imagePath!.isEmpty
                      ? Image.asset(
                          'assets/images/noimage.png',
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(
                            e.imagePath!,
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
                    color: lc.lessonId.contains(index)
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
                        Container(
                          width: 200,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              e.title!.toString(),
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xff353535),
                                fontSize: 18,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                        FutureBuilder(
                          future: e.getTblCards()?.toList(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<TblCard>> subGroups) {
                            if (subGroups.data == null) {
                              return Container();
                            }
                            return Text(subGroups.data!.length.toString() +
                                " FlashCard");
                          },
                        ),
                        Container(
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FutureBuilder(
                        future: getStatisticWidgets(e.id!),
                        builder: (context, AsyncSnapshot<Widget?> snapshaot) {
                          if (snapshaot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: snapshaot.data!,
                            );
                          }
                          return Container();
                        }),
                  ),
                ),
                FutureBuilder(
                    future: lc.getinfo(e),
                    builder: (context, AsyncSnapshot<double?> snapshot) {
                      return Positioned(
                        right: 10,
                        top: 5,
                        child: (!snapshot.hasData)
                            ? CircularProgressIndicator()
                            : ownCircle(
                                percent: snapshot.data!,
                                percentage_text:
                                    '%${(snapshot.data! * 100).toInt()}',
                              ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> getStatisticWidgets(int lessonId) async {
    // return Container();

    int examDone = 0;
    int reviewStart = 0;
    int allcount = 0;
    var cardIDList = await TblCard()
        .select(columnsToSelect: [
          TblCardFields.examDone.toString(),
          TblCardFields.reviewStart.toString(),
          TblCardFields.lessonId.count("count")
        ])
        .groupBy([
          TblCardFields.examDone.toString(),
          TblCardFields.reviewStart.toString()
        ])
        .lessonId
        .equals(lessonId)
        .toListObject();
    // print(cardIDList);
    for (var item in cardIDList) {
      if (item['examDone'] == 0 && item['reviewStart'] == 0)
        allcount += item['count'] as int? ?? 0;
      else if (item['examDone'] == 0 && item['reviewStart'] == 1)
        reviewStart += item['count'] as int? ?? 0;
      else if (item['examDone'] == 1 && item['reviewStart'] == 0)
        examDone += item['count'] as int? ?? 0;
      else if (item['examDone'] == 1 && item['reviewStart'] == 1)
        examDone += item['count'] as int? ?? 0;
      // print(allcount);
    }
    return Wrap(spacing: 5, children: [
      rounded_icon_folder_info(Color(0xffe04318), reviewStart),
      rounded_icon_folder_info(Colors.green[800]!, examDone),
      rounded_icon_folder_info(Colors.blue[800]!, allcount),
    ]);
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        PopupMenuItem<String>(child: Text('add_lesson'.tr), value: '0'),
        PopupMenuItem<String>(child: Text('Lion'), value: 'Lion'),
      ],
      elevation: 8.0,
    );
  }
}
