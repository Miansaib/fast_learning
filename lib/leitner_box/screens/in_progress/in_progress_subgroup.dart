import 'dart:async';
import 'dart:io';
import 'package:Fast_learning/card_view_page.dart';
import 'package:Fast_learning/controllers/book_controller.dart';
import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:Fast_learning/controllers/in_progress/in_progress_book_controller.dart';
import 'package:Fast_learning/controllers/theme_controller.dart';
import 'package:Fast_learning/leitner_box/customWidgets/circule_number.dart';
import 'package:Fast_learning/leitner_box/customWidgets/percentageCircle.dart';
import 'package:Fast_learning/leitner_box/screens/in_progress/in_progress_lesson.dart';
import 'package:Fast_learning/tools/download_dialog.dart';
import 'package:Fast_learning/tools/helper.dart';
import 'package:Fast_learning/zcomponent/common_widget/dottedbtn.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:badges/badges.dart';
import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/tools/export/lesson_page.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/password_change.dart';
import 'package:Fast_learning/password_dialog.dart';
import 'package:Fast_learning/tools/export/select_book.dart';
import 'package:Fast_learning/tools/custom_widgets.dart';
import 'package:Fast_learning/tools/show_loading_widget.dart';
import 'package:Fast_learning/tools/tools.dart';
import 'package:Fast_learning/voice_record.dart';
import 'package:Fast_learning/widgets/custom_progressive_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:darq/darq.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InProgressSubGroupPage extends StatefulWidget {
  final RootGroup rootGroup;
  final Function? refreshParentPageFunc;
  InProgressSubGroupPage(
      {Key? key, required this.rootGroup, this.refreshParentPageFunc})
      : super(key: key);

  @override
  _InProgressSubGroupPageState createState() => _InProgressSubGroupPageState();
}

class _InProgressSubGroupPageState extends State<InProgressSubGroupPage> {
  CardsController _cardsController = Get.find<CardsController>();
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  List<int> viewItems = [];

  List<SubGroup>? allSubgroups = [];

  double appBarOptionScaleFactor = 0.145;
  @override
  void dispose() {
    // indicatorLoadingController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,

        // centerTitle: true,
        title: Text(
          widget.rootGroup.title!,
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
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getSubGroupsByRootId(widget.rootGroup.id!,
                    preload: false, loadParents: false),
                builder: (BuildContext context,
                    AsyncSnapshot<List<SubGroup>> subgroups) {
                  if (subgroups.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  allSubgroups = subgroups.data;
                  return Stack(
                    children: [
                      // StreamBuilder<double>(
                      //     stream: indicatorLoadingController.stream,
                      //     // initialData: 0,
                      //     builder: (context, snapshot) {
                      //       if (snapshot.data == 0 || snapshot.data == 100) {
                      //         return Container();
                      //       }
                      //       return Center(
                      //         child: CircularProgressIndicator(
                      //             value: snapshot.data,
                      //             backgroundColor: Colors.grey,
                      //             valueColor:
                      //                 new AlwaysStoppedAnimation<Color>(Colors.red)),
                      //       );
                      //     }),
                      ListView(children: getBooksItems(subgroups.data!)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> getStatisticWidget(int bookId) async {
    // return Container();
    List<dynamic> lessons = [];

    lessons.addAll(await Lesson()
        .select(columnsToSelect: [LessonFields.id.toString()])
        .subGroupId
        .equals(bookId)
        .toListObject());
    // print(lessons);

    // lessons.addAll(sg.plLessons!.toList());

    int examDone = 0;
    int reviewStart = 0;
    int allcount = 0;
    for (var lesson in lessons) {
      // cards.addAll(await lesson.getTblCards()!.toList());
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
          .equals(lesson['id'])
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
    }
    // List<Lesson> lessons =
    //     await Lesson().select().subGroupId.equals(bookId).toList();
    // List<TblCard> cards = [];
    // for (var lesson in lessons) {
    //   cards.addAll(await lesson.getTblCards()!.toList());
    // }
    // int allCards = cards.length;
    // int cardsInLeiner = cards
    //     .where((x) => (x.reviewStart == true && x.examDone == false))
    //     .toList()
    //     .length;
    // int finishCard = cards.where((x) => x.examDone == true).toList().length;
    return Wrap(spacing: 5, children: [
      rounded_icon_folder_info(Color(0xFFC62828), reviewStart),
      rounded_icon_folder_info(Color(0xFF2E7D32), examDone),
      rounded_icon_folder_info(Color(0xFF1565C0), allcount),
    ]);
  }

  Future<Widget> getStatisticWidgets(List<Lesson>? lessons) async {
    List<TblCard> cards = [];
    for (var lesson in lessons!) {
      cards.addAll(await lesson.getTblCards()!.toList());
    }
    int allCards = cards.length;
    int cardsInLeiner = cards
        .where((x) => (x.reviewStart == true && x.examDone == false))
        .toList()
        .length;
    int finishCard = cards.where((x) => x.examDone == true).toList().length;
    return Wrap(spacing: 5, children: [
      Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red[800],
        ),
        child: Center(
            child: Text(
          cardsInLeiner.toString(),
          style: TextStyle(color: Colors.white, fontSize: 10),
        )),
      ),
      Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[800],
        ),
        child: Center(
            child: Text(
          allCards.toString(),
          style: TextStyle(color: Colors.white, fontSize: 10),
        )),
      ),
      Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green[800],
        ),
        child: Center(
            child: Text(
          finishCard.toString(),
          style: TextStyle(color: Colors.white, fontSize: 10),
        )),
      ),
    ]);
  }

  Future<List<SubGroup>> getSubGroupsByRootId(int rootId,
      {bool preload = true, bool loadParents = true}) async {
    var subGroups = await SubGroup()
        .select()
        .rootGroupId
        .equals(rootId)
        .orderBy('orderIndex')
        .toList(preload: preload, loadParents: loadParents);
    //     .toList(preloadFields: [
    //   'id,title,ratio,caseType,countTime,unitTime,languageItemOne,languageItemTwo,languageItemThree,rootGroupId,imagePath'
    // ]);
    if (subGroups.length == 0) {
      return [];
    }
    return subGroups;
  }

  Future<List<RootGroup>> getRootGroupsByRootId(
      {bool preload = true, bool loadParents = true}) async {
    var rootGroup = await RootGroup()
        .select()
        .orderBy('id')
        .toList(preload: preload, loadParents: loadParents);
    //     .toList(preloadFields: [
    //   'id,title,ratio,caseType,countTime,unitTime,languageItemOne,languageItemTwo,languageItemThree,rootGroupId,imagePath'
    // ]);
    if (rootGroup.length == 0) {
      return [];
    }
    return rootGroup;
  }

  List<Widget> getBooksItems(List<SubGroup> subgroups) {
    List<Widget> widgets = <Widget>[];
    for (var index = 0; index < subgroups.length; index++) {
      final e = subgroups[index];
      widgets.add(singleBookItem(index, e, subgroups));
    }
    return widgets;
  }

  Widget singleBookItem(int index, SubGroup e, List<SubGroup> sorted) {
    InProgressBookController ibc = Get.find();
    return Padding(
        key: ValueKey(index),
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            viewItems.add(e.id!);
            final prefs = await SharedPreferences.getInstance();
            await Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) {
                  return CupertinoPageScaffold(
                      resizeToAvoidBottomInset: true,
                      child: InProgressLessonPage(
                          subGroup: e,
                          radioSelected:
                              prefs.getInt(Preference.reviewRadioOption) ?? 0));
                },
              ),
            );
            // await Get.to(() => LessonPage(
            //     subGroup: e,
            //     radioSelected:
            //         prefs.getInt(Preference.reviewRadioOption) ?? 0));
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
                color: (viewItems.indexOf(e.id!) > -1)
                    ? Color.fromARGB(52, 39, 24, 126)
                    : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                    width: 2,
                    color: (viewItems.indexOf(e.id!) > -1)
                        ? Color(0xff27187E)
                        : Color.fromARGB(0, 255, 255, 255))),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 100,
                                spreadRadius: 1)
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
                    if (e.password!.isNotEmpty && e.passwordConfirmed == true)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 2)
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            'assets/images/lock.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
                FutureBuilder(
                    future: ibc.getInfo(e),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, num>> info) {
                      if (!info.hasData) return CircularProgressIndicator();
                      return Expanded(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: Colors.white,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                    Text(info.data!['lessons']!.toString() +
                                        " Lessons"),
                                    Text(info.data!['cards']!.toString() +
                                        " Flashcards"),
                                    Container(
                                      height: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 5,
                              child: ownCircle(
                                  percent: info.data!['progress']!.toDouble(),
                                  percentage_text:
                                      '%${(info.data!['progress']! * 100).toInt()}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: FutureBuilder(
                                    future: getStatisticWidget(e.id!),
                                    builder: (context,
                                        AsyncSnapshot<Widget?> snapshaot) {
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
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        )
        // child: Obx(() {
        //   return }),
        );
  }
}
