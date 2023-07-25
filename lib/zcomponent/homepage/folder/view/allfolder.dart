import 'dart:io';
import 'package:Fast_learning/card_view_page.dart';
import 'package:Fast_learning/leitner_box/customWidgets/circule_number.dart';
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
import '../../../../controllers/theme_controller.dart';

import 'dart:async';
// import 'package:Fast_learning/zcomponent/homepage/folder/zchild/view/booksview.dart';

import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:dotted_border/dotted_border.dart';

class MyFolders extends StatefulWidget {
  const MyFolders({super.key});

  @override
  State<MyFolders> createState() => _MyFoldersState();
}

class _MyFoldersState extends State<MyFolders> {
  void initState() {
    init();
    super.initState();
  }

  FolderController fc = Get.find();

  CardsController _cardsController = Get.find<CardsController>();
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  List<int> viewItems = [];
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

  @override
  Widget build(BuildContext context) {
    FolderController fc = Get.find();

    InAppPurchaseController inappc = Get.find();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: [10, 4],
          strokeWidth: 2,
          padding: EdgeInsets.all(0),
          radius: Radius.circular(10),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(color: Color(0xff27187E), width: 1.5, style: BorderStyle.)
              ),
              width: MediaQuery.of(context).size.width - 100,
              height: 50,
              child: FloatingActionButton(
                onPressed: () async {
                  InAppPurchaseController inappc = Get.find();

                  if (!inappc.isPremium) {
                    Get.to(() => BuySubscriptionPage());
                  } else {
                    // var x = await .getById(2);
                    await Get.defaultDialog(
                      title: 'Add Folder',
                      content: RootGroupAdd(RootGroup()),
                    );
                    setState(() {});
                  }
                },
                backgroundColor: Color(0xffF1F2F6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Color(0xff8A8A8A), size: 24),
                    SizedBox(width: 5),
                    Text(
                      "Add a new folder",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff8A8A8A)),
                    ),
                  ],
                ),
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text(
            "My Folders",
            style: TextStyle(
              color: Color(0xff353535),
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              // Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xff353535),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
        ),
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              createfolderdottedbtn(
                "Import",
                hint:
                    'You can import folders that your friends or other users send to you, and use them.',
                image: Image.asset('assets/images/import-icon.png'),
                width: (Get.width / 2) - 30,
                onTap: () async {
                  await unzipFiles();
                  await fc.getrootGroups();
                },
              ),
              createfolderdottedbtn(
                "Export",
                hint: 'you can also Export all your folders to other users.',
                image: Image.asset('assets/images/export-icon.png'),
                width: (Get.width / 2) - 30,
                onTap: () {
                  exportDialog();
                },
              ),
            ],
          ),
          Row(
            children: [
              Spacer(),
              GetBuilder<FolderController>(builder: (fc) {
                return CustomSwitch(
                  clr: Color(0xff27187E),
                  imgPath: 'assets/images/arrow-3.png',
                  text1: 'Edit Position',
                  isEnabled: !fc.isSelection,
                  value: fc.isEditPosition,
                  onChanged: fc.isSelection
                      ? null
                      : (value) {
                          fc.isEditPosition = !fc.isEditPosition;
                          setState(() {});
                        },
                );
              }),
              Spacer(),
              Obx(() {
                return CustomSwitch(
                  clr: Color(0xff27187E),
                  imgPath: 'assets/images/edit-icon.png',
                  text1: 'Edit Folder',
                  isEnabled: fc.editFolder,
                  isPushBtn: true,
                  onChanged: fc.editFolder
                      ? (value) async {
                          InAppPurchaseController inappc = Get.find();

                          if (!inappc.isPremium) {
                            Get.to(() => BuySubscriptionPage());
                          } else {
                            await Get.defaultDialog(
                                title: 'Edit Folder',
                                content: RootGroupAdd(
                                    fc.foldersItem[fc.foldersId.first]));
                            setState(() {});
                          }
                        }
                      : null,
                );
              }),
              Spacer(),
              Obx(() {
                return CustomSwitch(
                  clr: Color(0xff27187E),
                  icon: fc.foldersId.length == fc.foldersItem.length
                      ? Icons.deselect_outlined
                      : Icons.library_add_check_outlined,
                  text1: fc.foldersId.length == fc.foldersItem.length &&
                          fc.isSelection
                      ? "Deselect All"
                      : "Select All",
                  isEnabled: !fc.isEditPosition,
                  isPushBtn: true,
                  onChanged: fc.isEditPosition
                      ? null
                      : (value) {
                          if (fc.foldersId.length >= fc.foldersItem.length) {
                            fc.foldersId.clear();
                            fc.isSelection = false;
                          } else {
                            fc.isSelection = true;
                            fc.foldersId.clear();
                            for (var index = 0;
                                index < fc.foldersItem.length;
                                index++) fc.foldersId.add(index);
                          }
                          fc.editFolder = fc.foldersId.length == 1;
                          fc.update();
                          setState(() {});
                        },
                );
              }),
              Spacer(),
              CustomSwitch(
                clr: Color(0xff27187E),
                imgPath: 'assets/images/trash.png',
                text1: 'Delete Card',
                isEnabled: true,
                isPushBtn: true,
                onChanged: ((value) async {
                  await Get.defaultDialog(
                      title: "Delete Folder",
                      middleText: "Do you want delete selected folders?",
                      textConfirm: "Delete",
                      textCancel: "Cancel",
                      confirmTextColor: Colors.black,
                      cancelTextColor: Colors.black,
                      buttonColor: Colors.red[400],
                      onConfirm: () async {
                        fc.foldersId.sort((a, b) => b.compareTo(a));

                        for (var i in fc.foldersId) {
                          await fc.foldersItem.removeAt(i).delete();
                        }
                        fc.foldersId.clear();
                        fc.isSelection = false;
                        fc.editFolder = false;
                        fc.update();
                        Get.back();
                      });
                  setState(() {});
                  setState(() {});
                }),
              ),
              Spacer(),
            ],
          ),
          Builder(builder: (context) {
            FolderController fc = Get.find();
            return Expanded(
                child: AllFolderPage([], function: fc.getrootGroups));
          }),
        ]),
      ),
    );
  }

  Future select_folder_page_zip_without_token() async {
    List<int> selectedRoot =
        fc.foldersId.map<int>((int e) => fc.foldersItem[e].id!).toList();

    await zipRootFiles(rootIds: selectedRoot).then((value) {
      _cardsController.rebind();
      Get.back();
    });
  }

  Future select_folder_page_zip_with_token(List<String>? tokens) async {
    List<int> selectedRoot =
        fc.foldersId.map<int>((int e) => fc.foldersItem[e].id!).toList();

    if (tokens != null && tokens.length != 0) {
      await zipRootFiles(rootIds: selectedRoot, tokens: tokens).then((value) {
        _cardsController.rebind();
        Get.back();
      });
    } else {
      Get.back();
      Get.snackbar('warning', 'please add token',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> exportDialog() async {
    if (fc.foldersId.length == 0) {
      Get.snackbar('warning'.tr, 'Select Folder is required',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    await Get.defaultDialog(
        title: 'Warning',
        middleText: 'Do you want to add tokens?',
        confirmTextColor: Colors.white,
        actions: get_popup_widget(
            "Without Token",
            select_folder_page_zip_without_token,
            "With Token",
            select_folder_page_zip_with_token,
            "loading",
            context));
  }
}

class AllFolderPage extends StatefulWidget {
  final List<GlobalKey> keys;
  final Future<List<RootGroup>> Function()? function;
  AllFolderPage(this.keys, {this.function, Key? key}) : super(key: key);

  @override
  AllFolderPageState createState() => AllFolderPageState();
}

class AllFolderPageState extends State<AllFolderPage> {
  ThemeContoller themeContoller = Get.find<ThemeContoller>();

  void refreshPage() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    SharedPreferences.getInstance().then((prefs) {
      final doShow = prefs.getBool(Preference.show_hint_traning_page) ?? true;
      // show_hint(
      //     context,
      //     widget.keys +
      //         [
      //           _1_add_group,
      //           _5_website,
      //           _2_review_count,
      //           _3_not_reviewd_nor_learned,
      //           _4_in_leitner,
      //         ],
      //     doShow);
    });
    init();
    super.initState();
  }

  dispose() {
    fc.foldersId.clear();
    fc.isEditPosition = false;
    fc.isSelection = false;
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
  bool is_first = true;

  bool isSelection = false;
  @override
  Widget build(BuildContext context) {
    InAppPurchaseController controller = Get.find();
    return FutureBuilder(
      future: fc.getrootGroups(),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<RootGroup>> groups) {
        if (groups.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ReorderableListView(
          padding: EdgeInsets.only(bottom: 150.0),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }

              final item = fc.foldersItem!.removeAt(oldIndex);
              fc.foldersItem!.insert(newIndex, item);

              for (var i = 0; i < fc.foldersItem!.length; i++) {
                fc.foldersItem![i]
                  ..serverId = i
                  ..save();
              }
            });
          },
          children: [
            for (var index = 0; index < groups.data!.length; index++)
              Padding(
                key: ValueKey("$index"),
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onLongPress: fc.isEditPosition
                      ? null
                      : (() {
                          fc.selectionMethod(index);
                          setState(() {});
                        }),
                  onTap: fc.isEditPosition
                      ? null
                      : () async {
                          if (fc.isSelection) {
                            fc.selectionMethod(index);
                            setState(() {});

                            return;
                          }
                          if (!controller.isPremium) {
                            Get.to(BuySubscriptionPage());
                          } else {
                            await Navigator.of(context).push(
                              CupertinoPageRoute<void>(
                                builder: (BuildContext context) {
                                  return CupertinoPageScaffold(
                                      child: SubgroupPage(
                                    rootGroup: groups.data![index],
                                    refreshParentPageFunc: fc.update,
                                  ));
                                },
                              ),
                            );
                            // await Get.to(SubgroupPage(
                            //   rootGroup: groups.data![index],
                            //   refreshParentPageFunc: fc.update,
                            // ));
                          }
                          fc.update();
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
                        this.is_first,
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
      rounded_icon_folder_info(Color(0xffe04318), reviewStart),
      rounded_icon_folder_info(Colors.blue[800]!, allcount),
      rounded_icon_folder_info(Colors.green[800]!, examDone),
    ]);
    return widg;
  }
}
