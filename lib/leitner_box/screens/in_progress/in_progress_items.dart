import 'dart:io';
import 'package:Fast_learning/card_view_page.dart';
import 'package:Fast_learning/leitner_box/customWidgets/circule_number.dart';
import 'package:Fast_learning/leitner_box/screens/in_progress/in_progress_subgroup.dart';
import 'package:Fast_learning/leitner_box/screens/myFolders2.dart';
import 'package:Fast_learning/pages/childs/downloads_page/download_view.dart';
import 'package:Fast_learning/controllers/inapp_purchase_controller.dart';
import 'package:Fast_learning/pages/buy_subscription/buy_subscription_page.dart';
import 'package:Fast_learning/tools/show_loading_widget.dart';
import 'package:Fast_learning/tools/tools.dart';
import 'package:Fast_learning/zcomponent/common_widget/buttons.dart';
import 'package:Fast_learning/zcomponent/common_widget/dottedbtn.dart';
import 'package:Fast_learning/zcomponent/common_widget/hintdialog.dart';
import 'package:Fast_learning/zcomponent/homepage/folder/controller/foldercontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/pages/childs/add_upload_page/upload_view.dart';
import 'package:Fast_learning/pages/show_hint.dart';
import 'package:Fast_learning/tools/export/subgroup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../../controllers/theme_controller.dart';

import 'dart:async';
// import 'package:Fast_learning/zcomponent/homepage/folder/zchild/view/booksview.dart';

import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:dotted_border/dotted_border.dart';

class InProgressPage extends StatefulWidget {
  final List<GlobalKey> keys;
  final Future<List<RootGroup>> Function()? function;
  InProgressPage(this.keys, {this.function, Key? key}) : super(key: key);

  @override
  InProgressPageState createState() => InProgressPageState();
}

class InProgressPageState extends State<InProgressPage> {
  ThemeContoller themeContoller = Get.find<ThemeContoller>();

  void refreshPage() {
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  dispose() {
    super.dispose();
  }

  init() async {
    bool isPremium =
        await Get.put(InAppPurchaseController()).updatePurchaseStatus();
    if (!isPremium) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirst =
          (prefs.getBool(Preference.show_hint_traning_page) ?? true) ||
              (prefs.getBool(Preference.show_hint_flashcard_page) ?? false);
      if (!isFirst) Get.to(BuySubscriptionPage());
    }
  }

  FolderController fc = Get.find();

  bool isSelection = false;
  @override
  Widget build(BuildContext context) {
    InAppPurchaseController controller = Get.find();
    return FutureBuilder(
      future: widget.function!(),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<RootGroup>> groups) {
        if (groups.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          padding: EdgeInsets.only(bottom: 150.0),
          children: [
            for (var index = 0; index < groups.data!.length; index++)
              Padding(
                key: ValueKey("$index"),
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    if (!controller.isPremium) {
                      Get.to(BuySubscriptionPage());
                    } else {
                      await Navigator.of(context).push(
                        CupertinoPageRoute<void>(
                          builder: (BuildContext context) {
                            return CupertinoPageScaffold(
                                child: InProgressSubGroupPage(
                              rootGroup: groups.data![index],
                              refreshParentPageFunc: fc.update,
                            ));
                          },
                        ),
                      );
                    }
                    fc.update();
                  },
                  child: bookItems(groups.data!, index),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget bookItems(List<RootGroup> groups, int index) {
    return Row(
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
                child: groups[index].imagePath!.isEmpty
                    ? Image.asset(
                        'assets/images/noimage.png',
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(
                          groups[index].imagePath!,
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
                  color: fc.foldersId.contains(index)
                      ? Color.fromARGB(52, 39, 24, 126)
                      : Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 100, spreadRadius: 1)
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
                        groups[index].title!.toString(),
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
                      FutureBuilder(
                        future: fc.getInfo(groups[index]),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, num>> info) {
                          if (info.data == null) {
                            return Container();
                          }
                          print(info.data.toString());
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${info.data!['books'].toString()} Books",
                                style: TextStyle(
                                  color: Color(0xff353535),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "${info.data!['lessons'].toString()} Lessons",
                                style: TextStyle(
                                  color: Color(0xff353535),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "${info.data!['cards'].toString()} Flashcards",
                                style: TextStyle(
                                  color: Color(0xff353535),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
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
                      future: getSubGroupsByRootId(
                        groups[index].id!,
                      ),
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
            ],
          ),
        ),
      ],
    );
  }

  Future<List<RootGroup>> getrootGroups() {
    return RootGroup().select().orderBy('serverId').toList();
  }

  Future<Widget?> getSubGroupsByRootId(
    int rootId,
  ) async {
    // var subGroups =await (await RootGroup().getById(rootId))!.getSubGroups()!.toList();
    // return Container();
    List<TblCard> cards = [];
    var subGroups = await SubGroup()
        .select(columnsToSelect: [SubGroupFields.id.toString()])
        .rootGroupId
        .equals(rootId)
        .toListObject();
    // print(subGroups); // [{id: 1}, {id: 2}]
    List<dynamic> lessons = [];
    for (var sg in subGroups) {
      lessons.addAll(await Lesson()
          .select(columnsToSelect: [LessonFields.id.toString()])
          .subGroupId
          .equals(sg['id'])
          .toListObject());
      // print(lessons);

      // lessons.addAll(sg.plLessons!.toList());
    }
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
    // int allCards = cards.length;
    // int cardsInLeiner = cards
    //     .where((x) => (x.reviewStart == true && x.examDone == false))
    //     .toList()
    //     .length;
    // int finishCard = cards.where((x) => x.examDone == true).toList().length;

    final widg = Wrap(spacing: 5, children: [
      rounded_icon_folder_info(Color(0xffe04318), reviewStart),
      rounded_icon_folder_info(Colors.blue[800]!, allcount),
      rounded_icon_folder_info(Colors.green[800]!, examDone),
    ]);
    return widg;
  }
}
