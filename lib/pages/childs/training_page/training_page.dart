import 'dart:convert';
import 'dart:io';
import 'package:Fast_learning/pages/childs/downloads_page/download_view.dart';
import 'package:Fast_learning/controllers/inapp_purchase_controller.dart';
import 'package:Fast_learning/pages/buy_subscription/buy_subscription_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/pages/childs/add_upload_page/upload_view.dart';
import 'package:Fast_learning/pages/show_hint.dart';
import 'package:Fast_learning/tools/export/subgroup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Fast_learning/tools/tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../controllers/theme_controller.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TrainingPage extends StatefulWidget {
  final List<GlobalKey> keys;
  TrainingPage(this.keys, {Key? key}) : super(key: key);

  @override
  TrainingPageState createState() => TrainingPageState();
}

class TrainingPageState extends State<TrainingPage> {
  ThemeContoller themeContoller = Get.find<ThemeContoller>();

  void refreshPage() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    SharedPreferences.getInstance().then((prefs) {
      final doShow = prefs.getBool(Preference.show_hint_traning_page) ?? true;
      show_hint(
          context,
          widget.keys +
              [
                _1_add_group,
                _5_website,
                _2_review_count,
                _3_not_reviewd_nor_learned,
                _4_in_leitner,
              ],
          doShow);
    });
    init();
    super.initState();
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

  bool is_first = true;
  final GlobalKey _1_add_group = GlobalKey();
  final GlobalKey _2_review_count = GlobalKey();
  final GlobalKey _3_not_reviewd_nor_learned = GlobalKey();
  final GlobalKey _4_in_leitner = GlobalKey();
  final GlobalKey _5_website = GlobalKey();
  @override
  Widget build(BuildContext context) {
    InAppPurchaseController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        // title: Text(
        //   'training'.tr,
        //   style: Get.theme.textTheme.headline!.copyWith(color: Colors.white),
        // ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0), // here the desired height
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Text(
                    'training'.tr,
                    style: Get.theme.textTheme.headline1!
                        .copyWith(color: Colors.white, fontSize: 22),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () =>
                          launchUrl(Uri.parse('https://mojiapplication.com/')),
                      child: Text(
                        'Tutorial',
                        style: Get.theme.textTheme.headline1!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ), //bottom: 10),
                      child: Showcase(
                        overlayPadding: const EdgeInsets.all(1),
                        key: _5_website,
                        description:
                            'Tap to visit the website and see more hints',
                        child: GestureDetector(
                          onTap: () async {
                            // var x = await .getById(2);
                            if (!controller.isPremium) {
                              Get.to(() => BuySubscriptionPage());
                            } else {
                              // var x = await .getById(2);
                              await Get.to(DownloadsView());
                            }
                          },
                          child: Text(
                            "Downloads",
                            style: Get.theme.textTheme.headline1!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          // child: Icon(
                          //   Icons.lightbulb_outline_sharp,
                          //   color: Colors.white,
                          // ),
                        ),
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.only(
                      //   left: 15,
                      //   right: 15,
                      // ), //bottom: 10),
                      child: Showcase(
                        overlayPadding: const EdgeInsets.all(1),
                        key: _1_add_group,
                        description: 'Tap to create new Group',
                        child: GestureDetector(
                          onTap: () async {
                            if (!controller.isPremium) {
                              Get.to(() => BuySubscriptionPage());
                            } else {
                              // var x = await .getById(2);
                              await Get.to(() => RootGroupAdd(RootGroup()),
                                  fullscreenDialog: true,
                                  transition: Transition.zoom,
                                  duration: Duration(seconds: 1));
                              setState(() {
                                print('rebuild now');
                              });
                            }
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 20, left: 20),
                        child: new PopupMenuButton(
                            child: Icon(Icons.more_vert, color: Colors.white),
                            itemBuilder: (_) => <PopupMenuItem<int>>[
                                  // PopupMenuItem<int>(
                                  //     child: new Text('Show hint'.tr),
                                  //     value: 0),
                                  PopupMenuItem<int>(
                                      child: new Text(
                                          'See more hints from website'.tr),
                                      value: 1),
                                ],
// ignore: top_level_function_literal_block
                            onSelected: (value) async {
                              switch (value) {
                                // case 0:
                                //   // await SharedPreferences.getInstance()
                                //   //     .then((prefs) {
                                //   //   prefs.setBool(
                                //   //       Preference.show_hint_traning_page,
                                //   //       !(prefs.getBool(Preference
                                //   //               .show_hint_traning_page) ??
                                //   //           true));

                                //   //   if ((prefs.getBool(Preference
                                //   //           .show_hint_traning_page) ??
                                //   //       true)) {}
                                //   // });
                                //   (WidgetsBinding.instance)
                                //       .addPostFrameCallback(
                                //     (_) => ShowCaseWidget.of(context)
                                //         .startShowCase(widget.keys +
                                //                 [
                                //                   _1_add_group,
                                //                   _5_website,
                                //                   _2_review_count,
                                //                   _3_not_reviewd_nor_learned,
                                //                   _4_in_leitner,
                                //                 ] ??
                                //             []),
                                //   );
                                //   break;
                                case 1:
                                  final _url =
                                      'https://mojiapplication.com/help.html';
                                  if (!await launch(_url)) {
                                    throw 'Could not launch $_url';
                                  }
                                  break;
                              }
                            }))
                  ],
                ),
              ],
            ),
          ),
        ),
        // actions: [
        //   Container(
        //     margin: EdgeInsets.only(right: 20, left: 20,top: 20),
        //     child: GestureDetector(
        //       onTap: () async {
        //         // var x = await .getById(2);
        //         await Get.to(() => RootGroupAdd(RootGroup()),
        //             fullscreenDialog: true,
        //             transition: Transition.zoom,
        //             duration: Duration(seconds: 1));
        //         setState(() {
        //           print('rebuild now');
        //         });
        //       },
        //       child: Icon(
        //         Icons.add,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getrootGroups(),
          //initialData: InitialData,
          builder:
              (BuildContext context, AsyncSnapshot<List<RootGroup>> groups) {
            if (groups.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              padding: EdgeInsets.all(5),
              children: groups.data!
                  .map((e) => GestureDetector(
                        onTap: () async {
                          if (!controller.isPremium) {
                            Get.to(BuySubscriptionPage());
                          } else {
                            await Get.to(SubgroupPage(
                              rootGroup: e,
                              refreshParentPageFunc: refreshPage,
                            ));
                          }
                          refreshPage();
                          //***********start upload */
                          //  File file = File((await getFile()));

                          //    double currentValue = 0.0;
                          //  Get.defaultDialog(
                          //       title: 'Upload in progress',
                          //       content: CircularProgressIndicator(
                          //         semanticsLabel: currentValue.toString(),
                          //         value: currentValue,
                          //         backgroundColor: Colors.grey,
                          //       ));
                          //   fileUploadMultipart(file: file,onUploadProgress: (sentBytes,totalBytes){
                          //             print(sentBytes*100/totalBytes);
                          //              currentValue = sentBytes*100/totalBytes;

                          //   });

                          //*********************** */
                        },
                        child: Card(
                            elevation: 5,
                            child: Container(
                              child: ListTile(
                                leading: Container(
                                  width: 80,
                                  height: 80,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: themeContoller
                                          .themeData.value.primaryColor,
                                      shape: BoxShape.circle,
                                      image: e.imagePath!.isEmpty
                                          ? DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/noimage.png'))
                                          : DecorationImage(
                                              image: FileImage(
                                              File(
                                                e.imagePath!,
                                              ),
                                            ))),
                                ),
                                title: Column(
                                  //mainAxisSize:MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.title!.toString(),
                                      style: themeContoller
                                          .themeData.value.textTheme.bodyText1,
                                    ),
                                    Container(
                                      height: 5,
                                    ),
                                    FutureBuilder(
                                        future: getSubGroupsByRootId(
                                          e.id!,
                                          this.is_first,
                                        ),
                                        builder: (context,
                                            AsyncSnapshot<Widget?> snapshaot) {
                                          if (snapshaot.hasData) {
                                            return snapshaot.data!;
                                          }
                                          return Container();
                                        }),
                                    Container(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                //subtitle:   Text('تعداد زیر گروه : '+e.getSubGroups()!.toList().);,
                                subtitle: FutureBuilder(
                                  future: e.getSubGroups()?.toList(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<SubGroup>> subGroups) {
                                    if (subGroups.data == null) {
                                      return Container();
                                    }
                                    return Text('number_subgroup'.tr +
                                        ': ' +
                                        subGroups.data!.length.toString());
                                  },
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          if (!controller.isPremium) {
                                            Get.to(() => BuySubscriptionPage());
                                          } else {
                                            await Get.to(() => RootGroupAdd(e));
                                            setState(() {});
                                          }
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: themeContoller
                                              .themeData.value.primaryColor,
                                        )),
                                    Container(
                                      width: 8,
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          if (!controller.isPremium) {
                                            Get.to(() => BuySubscriptionPage());
                                          } else {
                                            var result = Get.defaultDialog(
                                                onConfirm: () async {
                                                  await e.delete(true);
                                                  Get.back();
                                                  setState(() {});
                                                },
                                                confirmTextColor: Colors.white,
                                                onCancel: () => print('cancel'),
                                                middleText: "delete_msg".tr);
                                            //await  e.delete(true);
                                            setState(() {});
                                          }
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: themeContoller
                                              .themeData.value.primaryColor,
                                        )),
                                  ],
                                ),
                              ),
                            )),
                      ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Future<List<RootGroup>> getrootGroups() {
    return RootGroup().select().toList();
  }

  Future<Widget?> getSubGroupsByRootId(int rootId, bool flagFirst) async {
    bool shit = false;
    if (flagFirst) {
      shit = true;
      this.is_first = false;
    }
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
      Showcase(
        key: shit ? _2_review_count : GlobalKey(),
        description: 'Number of flash cards in Review section',
        child: Container(
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
      ),
      Showcase(
        key: shit ? this._3_not_reviewd_nor_learned : GlobalKey(),
        description: 'Number of flash cards you have not learned yet',
        child: Container(
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
      ),
      Showcase(
        key: shit ? _4_in_leitner : GlobalKey(),
        description: 'Number of flash cards you have learned',
        child: Container(
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
      ),
    ]);
    return widg;
  }
}
