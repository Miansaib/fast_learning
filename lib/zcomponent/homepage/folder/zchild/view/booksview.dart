import 'dart:async';
import 'dart:io';
import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:Fast_learning/controllers/theme_controller.dart';
import 'package:Fast_learning/tools/download_dialog.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class SubgroupPage extends StatefulWidget {
  final RootGroup rootGroup;
  final Function? refreshParentPageFunc;
  SubgroupPage({Key? key, required this.rootGroup, this.refreshParentPageFunc})
      : super(key: key);

  @override
  _SubgroupPageState createState() => _SubgroupPageState();
}

class _SubgroupPageState extends State<SubgroupPage> {
  CardsController _cardsController = Get.find<CardsController>();
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  List<int> viewItems = [];
  @override
  void dispose() {
    // indicatorLoadingController.close();
    super.dispose();
  }

  @override
  void initState() {
    // indicatorLoadingController.sink.add(0.0);
    super.initState();
  }

  Future subgroup_page_zip_without_token() async {
    await zipAllFiles(widget.rootGroup).then((value) {
      _cardsController.rebind();
      Get.back();
    });
  }

  Future subgroup_page_zip_with_token(List<String>? tokens) async {
    print(tokens);
    if (tokens != null && tokens.length != 0) {
      await zipAllFiles(widget.rootGroup, tokens: tokens).then((value) {
        _cardsController.rebind();
        Get.back();
      });
    } else {
      Get.back();
      Get.snackbar('warning', 'please add token',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.rootGroup.title!,
          style: Get.theme.textTheme.headline1!.copyWith(color: Colors.white),
        ),
        leading: InkWell(
          child: Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onTap: () {
            Get.back();
          },
        ),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              child: new PopupMenuButton(
                child: Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (_) => <PopupMenuItem<int>>[
                  new PopupMenuItem<int>(
                      child: new Text('add_book'.tr), value: 0),
                  new PopupMenuItem<int>(
                      child: new Text('import_books'.tr), value: 1),
                  new PopupMenuItem<int>(
                      child: new Text('import_books_from_link'.tr), value: 4),
                  new PopupMenuItem<int>(
                      child: new Text('export_all_books'.tr), value: 2),
                  new PopupMenuItem<int>(
                      child: new Text('export_selected_books'.tr), value: 3),
                ],
// ignore: top_level_function_literal_block
                onSelected: (value) async {
                  switch (value) {
                    case 0:
                      await Get.to(() => SubGroupAdd(SubGroup(
                          rootGroupId: widget.rootGroup.id!,
                          ratio: 1.2,
                          countTime: 5,
                          boxCount: 5)));
                      setState(() {});
                      break;
                    case 1:
                      await unzipFiles(rootGroup: widget.rootGroup);
                      Get.back();
                      Future.delayed(Duration(seconds: 1), () {
                        widget.refreshParentPageFunc!();
                        setState(() {});
                      });
                      break;
                    case 4:
                      await download_dialog(onPressed: () {
                        _cardsController.download_books(widget.rootGroup);
                      }, onPressedUseLastDownload: () {
                        _cardsController.download_books(widget.rootGroup,
                            useLastDownload: true);
                      });
                      Future.delayed(Duration(seconds: 1), () {
                        widget.refreshParentPageFunc!();
                        setState(() {});
                      });
                      break;
                    case 2:
                      // await zipAllFiles(widget.rootGroup);
                      // _cardsController.rebind();
                      // setState(() {});
                      // showDialog(context: context, builder: (context)=>AddTokens());
                      await Get.defaultDialog(
                          // title: 'Warning',
                          title: 'Subgroup_page.dart',
                          middleText: 'Do you want to add tokens?',
                          confirmTextColor: Colors.white,
                          actions: get_popup_widget(
                              "Without Token",
                              subgroup_page_zip_without_token,
                              "With Token",
                              subgroup_page_zip_with_token,
                              "Loading",
                              context));

                      break;
                    case 3:
                      var subGroups =
                          await getSubGroupsByRootId(widget.rootGroup.id!);
                      Get.dialog(SelectBook(
                        subGroups: subGroups,
                        rootGroup: widget.rootGroup,
                      ));
                      break;
                  }
                },
              )),
        ],
      ),
      // body:
    );
  }

  Future<double> uploadBook() async {
    StreamController<double> indicatorLoadingController =
        StreamController<double>();
    File file = File((await getFile()));
    double currentValue = 0;
    fileUploadMultipart(
        file: file,
        onUploadProgress: (sentBytes, totalBytes) {
          print(sentBytes / totalBytes);
          currentValue = sentBytes / totalBytes;
          if (!indicatorLoadingController.isClosed) {
            indicatorLoadingController.sink.add(currentValue);
          }
        });
    await Get.defaultDialog(
        title: 'Upload in progress',
        content: CustomProgressiveIndicator(
            indicatorValueController: indicatorLoadingController));
    indicatorLoadingController.close();
    return 0.0;
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
      Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red[800],
        ),
        child: Center(
            child: Text(
          reviewStart.toString(),
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
          allcount.toString(),
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
          examDone.toString(),
          style: TextStyle(color: Colors.white, fontSize: 10),
        )),
      ),
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
}
