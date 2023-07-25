import 'dart:async';
import 'dart:io';
import 'package:Fast_learning/card_view_page.dart';
import 'package:Fast_learning/controllers/book_controller.dart';
import 'package:Fast_learning/leitner_box/customWidgets/circule_number.dart';
import 'package:Fast_learning/leitner_box/customWidgets/percentageCircle.dart';
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

import '../../add_token.dart';
import '../../controllers/cards_controller.dart';
import '../../controllers/theme_controller.dart';
import '../download_dialog.dart';
import '../helper.dart';

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

  List<SubGroup>? allSubgroups = [];

  double appBarOptionScaleFactor = 0.145;
  @override
  void dispose() {
    // indicatorLoadingController.close();
    super.dispose();
  }

  @override
  void initState() {
    bc.bookId.clear();
    bc.isSelection = false;
    bc.editBook = false;
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

  MainBookController bc = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                await Get.to(() => SubGroupAdd(SubGroup(
                    rootGroupId: widget.rootGroup.id!,
                    ratio: 1.2,
                    countTime: 5,
                    boxCount: 5)));
                setState(() {});
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
                    "Add book",
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
      resizeToAvoidBottomInset: false,
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

        actions: [
          Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              child: new PopupMenuButton(
                child: Icon(Icons.more_vert, color: Color(0xff353535)),
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
                      Future.delayed(Duration(seconds: 1), () {
                        widget.refreshParentPageFunc!();
                        setState(() {});
                      });
                      Get.back();
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
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                createfolderdottedbtn("Import",
                    hint:
                        'You can import books that your friends or other users send to you, and use them.',
                    image: Image.asset('assets/images/import-icon.png'),
                    width: (Get.width / 2) - 30, onTap: () async {
                  await unzipFiles(rootGroup: widget.rootGroup);
                  Future.delayed(Duration(seconds: 1), () {
                    widget.refreshParentPageFunc!();
                    setState(() {});
                  });
                  Get.back();
                }),
                createfolderdottedbtn("Export",
                    hint: 'you can also Export all your books to other users.',
                    image: Image.asset('assets/images/export-icon.png'),
                    width: (Get.width / 2) - 30, onTap: () async {
                  // var subGroups =
                  //     await getSubGroupsByRootId(widget.rootGroup.id!);
                  // var subgroups = subGroups

                  await exportDialog(context);
                }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Wrap(
                    spacing: 5,
                    children: [
                      GetBuilder<MainBookController>(builder: (bc) {
                        return CustomSwitch(
                          clr: Color(0xff27187E),
                          imgPath: 'assets/images/arrow-3.png',
                          text1: 'Edit Position',
                          scale: appBarOptionScaleFactor,
                          isEnabled: !bc.isSelection,
                          value: bc.isEditPosition,
                          onChanged: ((value) {
                            bc.isEditPosition = !bc.isEditPosition;

                            setState(() {});
                          }),
                        );
                      }),
                      Obx(() {
                        return CustomSwitch(
                          scale: .14,
                          clr: Color(0xff27187E),
                          icon: bc.bookId.length == allSubgroups!.length
                              ? Icons.deselect_outlined
                              : Icons.library_add_check_outlined,
                          text1: bc.bookId.length == allSubgroups!.length &&
                                  bc.isSelection
                              ? "Deselect All"
                              : "Select All",
                          isEnabled: !bc.isEditPosition,
                          isPushBtn: true,
                          onChanged: bc.isEditPosition
                              ? null
                              : (value) {
                                  if (bc.bookId.length >=
                                      allSubgroups!.length) {
                                    bc.bookId.clear();
                                    bc.isSelection = false;
                                    bc.editBook = false;
                                  } else {
                                    bc.isSelection = true;
                                    bc.bookId.clear();
                                    for (var index = 0;
                                        index < allSubgroups!.length;
                                        index++) bc.bookId.add(index);
                                    bc.update();
                                  }
                                  setState(() {});
                                },
                        );
                      }),
                      Obx(() {
                        return CustomSwitch(
                            clr: Color(0xff27187E),
                            imgPath: 'assets/images/edit-icon.png',
                            text1: 'Edit Book',
                            scale: appBarOptionScaleFactor,
                            isPushBtn: true,
                            isEnabled: bc.editBook,
                            onChanged: bc.editBook
                                ? ((value) async {
                                    final book = allSubgroups![bc.bookId.first];

                                    if (book.password!.length > 0 &&
                                        book.passwordConfirmed != true) {
                                      //Get.snackbar('title', 'sfswf');
                                      var result = await Get.defaultDialog(
                                          content: PasswordDialog(
                                            password: book.password!,
                                          ),
                                          title: 'enter_password'.tr);
                                      if (result == true) {
                                        book.passwordConfirmed = true;
                                        int? id = await book.save();
                                        await Get.to(SubGroupAdd(book));
                                        setState(() {});
                                      }
                                    } else {
                                      await Get.to(SubGroupAdd(book));
                                      setState(() {});
                                    }
                                    print(allSubgroups!.length);
                                    // await Get.to(TblCardAdd(allSubgroups![cc.bookId.first]));
                                    _cardsController.rebind();
                                    bc.bookId.clear();
                                    bc.isSelection = false;
                                    bc.editBook = false;
                                    bc.update();
                                    setState(() {});
                                  })
                                : null);
                      }),
                      CustomSwitch(
                        clr: Color(0xff27187E),
                        imgPath: 'assets/images/note.png',
                        text1: 'Send To Training',
                        scale: appBarOptionScaleFactor,
                        isPushBtn: true,
                        onChanged: ((value) async {
                          for (var i in bc.bookId) {
                            final book =
                                await allSubgroups?[i].getLessons()!.toList();
                            book?.forEach((element) async {
                              final cards =
                                  await element.getTblCards()?.toList();
                              cards?.forEach((card) async {
                                card
                                  ..reviewStart = false
                                  ..save();
                              });
                            });
                          }
                          bc.bookId.clear();
                          bc.isSelection = false;
                          bc.editBook = false;
                          bc.update();
                          _cardsController.rebind();
                          setState(() {});
                        }),
                      ),
                      CustomSwitch(
                        clr: Color(0xff27187E),
                        imgPath: 'assets/images/repeat.png',
                        isPushBtn: true,
                        text1: 'Send To Review',
                        scale: appBarOptionScaleFactor,
                        onChanged: ((value) async {
                          for (var i in bc.bookId) {
                            final book =
                                await allSubgroups?[i].getLessons()!.toList();
                            book?.forEach((element) async {
                              final cards =
                                  await element.getTblCards()?.toList();
                              cards?.forEach((card) async {
                                card
                                  ..reviewStart = true
                                  ..save();
                              });
                            });
                          }
                          bc.bookId.clear();
                          bc.isSelection = false;
                          bc.editBook = false;
                          bc.update();
                          _cardsController.rebind();
                          setState(() {});
                        }),
                      ),
                      CustomSwitch(
                        clr: Color(0xff27187E),
                        imgPath: 'assets/images/lock.png',
                        isPushBtn: true,
                        text1: 'Lock',
                        scale: appBarOptionScaleFactor,
                        isEnabled: bc.editBook,
                        onChanged: bc.editBook
                            ? ((value) async {
                                final e = allSubgroups![bc.bookId.first];

                                if (e.password!.length > 0 &&
                                    e.passwordConfirmed != true) {
                                  //Get.snackbar('title', 'sfswf');
                                  var result = await Get.defaultDialog(
                                      content: PasswordDialog(
                                        password: e.password!,
                                      ),
                                      title: 'enter_password'.tr);
                                  if (result != true) {
                                    return;
                                  }
                                }
                                var result = await Get.defaultDialog(
                                  content: PasswordChange(
                                    subGroup: e,
                                  ),
                                  title: 'change_password'.tr,
                                );
                                if (result == true) {
                                  Get.snackbar('warning',
                                      'Your password changed successfully');
                                  e.passwordConfirmed = true;
                                  await e.save();
                                  setState(() {});
                                }
                                // for (var i in bc.bookId) {

                                //   final lessonss =
                                //       await allSubgroups?[i].getLessons()!.toList();
                                //   lessonss?.forEach((element) async {
                                //     final cards = await element.getTblCards()?.toList();
                                //     cards?.forEach((card) async {
                                //       card
                                //         ..reviewStart = false
                                //         ..save();
                                //     });
                                //   });
                                // }
                                bc.bookId.clear();
                                bc.isSelection = false;
                                bc.editBook = false;
                                bc.update();
                                _cardsController.rebind();
                                setState(() {});
                              })
                            : null,
                      ),
                      CustomSwitch(
                        clr: Color(0xff27187E),
                        imgPath: 'assets/images/trash.png',
                        text1: 'Delete Card',
                        scale: appBarOptionScaleFactor,
                        isEnabled: true,
                        isPushBtn: true,
                        onChanged: ((value) async {
                          await Get.defaultDialog(
                              title: "Delete",
                              middleText:
                                  "Do you want delete selected folders?",
                              textConfirm: "Delete",
                              textCancel: "Cancel",
                              confirmTextColor: Colors.black,
                              cancelTextColor: Colors.black,
                              buttonColor: Colors.red[400],
                              onConfirm: () async {
                                bc.bookId.sort((a, b) => b.compareTo(a));

                                for (var i in bc.bookId) {
                                  await allSubgroups?.removeAt(i).delete(true);
                                }
                                bc.bookId.clear();
                                bc.isSelection = false;
                                bc.editBook = false;
                                bc.update();
                                Get.back();
                              });
                          setState(() {});
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(height: 10),

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
                      ReorderableListView(
                          padding: EdgeInsets.only(bottom: 100.0),
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              final item = allSubgroups!.removeAt(oldIndex);
                              allSubgroups!.insert(newIndex, item);

                              for (var i = 0; i < allSubgroups!.length; i++) {
                                allSubgroups![i]
                                  ..orderIndex = i
                                  ..save();
                              }
                            });
                          },
                          children: getBooksItems(subgroups.data!)),
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

  Future select_book_page_zip_without_token() async {
    List<int> selectedIdGroups =
        bc.bookId.map<int>((int e) => allSubgroups![e].id!).toList();

    await zipAllFiles(widget.rootGroup, bookIds: selectedIdGroups)
        .then((value) {
      _cardsController.rebind();
      Get.back();
    });
  }

  Future select_book_page_zip_with_token(List<String>? tokens) async {
    List<int> selectedIdGroups =
        bc.bookId.map<int>((int e) => allSubgroups![e].id!).toList();

    print(tokens);
    if (tokens != null && tokens.length != 0) {
      await zipAllFiles(widget.rootGroup,
              bookIds: selectedIdGroups, tokens: tokens)
          .then((value) {
        _cardsController.rebind();
        Get.back();
      });
    } else {
      Get.back();
      Get.snackbar('warning', 'please add token',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> exportDialog(BuildContext context) async {
    if (bc.bookId.length == 0) {
      Get.snackbar('warning'.tr, 'Select at least one book',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    print(bc.bookId.map((e) => allSubgroups![e]).any((element) {
      return (element.passwordConfirmed == false);
    }));
    if (bc.bookId.map((e) => allSubgroups![e]).any((element) {
      return (element.passwordConfirmed == false);
    })) {
      Get.snackbar('warning',
          'The book is locked! and you have not permission to export');
      return;
    }
    await Get.defaultDialog(
        title: 'Warning',
        middleText: 'Do you want to add tokens?',
        confirmTextColor: Colors.white,
        actions: get_popup_widget(
            "Without Token",
            select_book_page_zip_without_token,
            "With Token",
            select_book_page_zip_with_token,
            "loading",
            context));
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
    return Padding(
      key: ValueKey(index),
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        return InkWell(
          onLongPress: bc.isEditPosition
              ? null
              : (() {
                  bc.selectionMethod(index);
                  setState(() {});
                }),
          onTap: bc.isEditPosition
              ? null
              : () async {
                  if (bc.isSelection) {
                    bc.selectionMethod(index);
                    setState(() {});
                    return;
                  }
                  viewItems.add(e.id!);
                  final prefs = await SharedPreferences.getInstance();
                  await Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (BuildContext context) {
                        return CupertinoPageScaffold(
                            resizeToAvoidBottomInset: true,
                            child: LessonPage(
                                subGroup: e,
                                radioSelected: prefs
                                        .getInt(Preference.reviewRadioOption) ??
                                    0));
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
            decoration: (viewItems.indexOf(e.id!) > -1)
                ? BoxDecoration(
                    color: bc.bookId.contains(index)
                        ? Color.fromARGB(52, 39, 24, 126)
                        : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 2, color: Color(0xff27187E)))
                : BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: bc.bookId.contains(index)
                        ? Color.fromARGB(52, 39, 24, 126)
                        : Colors.white,
                  ),
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
                    future: bc.getInfo(e),
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
                                color: bc.bookId.contains(index)
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
        );
      }),
    );
    return InkWell(
      key: ValueKey(index),
      onLongPress: bc.isEditPosition
          ? null
          : (() {
              bc.selectionMethod(index);
              setState(() {});
            }),
      onTap: () async {
        if (bc.isSelection) {
          bc.selectionMethod(index);
          setState(() {});
          return;
        }
        viewItems.add(e.id!);
        final prefs = await SharedPreferences.getInstance();
        await Get.to(() => LessonPage(
            subGroup: e,
            radioSelected: prefs.getInt(Preference.reviewRadioOption) ?? 0));
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(top: 2),
        decoration: (viewItems.indexOf(e.id!) > -1)
            ? BoxDecoration(border: Border.all(color: Colors.red))
            : BoxDecoration(),
        child: CustomWidgets.customListTile(context,
            //  selected: (viewItems.indexOf(e.id!) > -1),
            selectedTileColor:
                themeContoller.themeData.value.backgroundColor.withOpacity(0.5),
            leading: Container(
              width: 65,
              height: 100,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: themeContoller.themeData.value.primaryColor,
                  shape: BoxShape.circle,
                  image: e.imagePath!.isEmpty
                      ? DecorationImage(
                          image: AssetImage('assets/images/noimage.png'))
                      : DecorationImage(
                          image: FileImage(
                          File(
                            e.imagePath!,
                          ),
                        ))),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.title!,
                  style: themeContoller.themeData.value.textTheme.bodyText1,
                  // style: TextStyle(
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 18,
                  // ),
                ),
              ],
            ),
            subtitle: Container(
              padding: EdgeInsetsDirectional.only(start: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Index : ',
                          style: themeContoller
                              .themeData.value.textTheme.bodyText1!
                              .copyWith(fontSize: 12)),
                      Text(e.orderIndex.toString(),
                          style: themeContoller
                              .themeData.value.textTheme.bodyText1!
                              .copyWith(fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Position :',
                          style: themeContoller
                              .themeData.value.textTheme.bodyText1!
                              .copyWith(fontSize: 12)),
                      Text(
                        '${sorted.indexOf(e) + 1}/${sorted.length}',
                        style: themeContoller
                            .themeData.value.textTheme.bodyText1!
                            .copyWith(fontSize: 12),
                      )
                    ],
                  ),
                  FutureBuilder(
                    future: getStatisticWidget(e.id!),
                    //initialData: InitialData,
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return snapshot.data!;
                      //return ;
                    },
                  ),
                ],
              ),
            ),
            trailing: Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 2,
                children: [
                  InkWell(
                    onTap: () async {
                      e.orderIndex = e.orderIndex! - 1;
                      await e.save();
                      setState(() {});
                    },
                    child: Icon(Icons.remove,
                        color: themeContoller.themeData.value.primaryColor),
                  ),
                  InkWell(
                      onTap: () async {
                        e.orderIndex = e.orderIndex! + 1;
                        await e.save();
                        setState(() {});
                      },
                      child: Icon(Icons.add,
                          color: themeContoller.themeData.value.primaryColor)),
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
                          List<Lesson> lessons = await Lesson()
                              .select()
                              .subGroupId
                              .equals(e.id)
                              .toList();
                          UITools(context)
                              .showWaitScreen('Waiting', null, null);
                          for (Lesson lesson in e.plLessons ?? lessons) {
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
                          Navigator.of(context).pop();
                          setState(() {});
                        }
                      },
                      child: Icon(Icons.outbond,
                          color: themeContoller.themeData.value.primaryColor)),
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
                              .equals(e.id)
                              .toList();
                          UITools(context)
                              .showWaitScreen('Waiting', null, null);
                          for (Lesson lesson in e.plLessons ?? lessons) {
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
                          Navigator.of(context).pop();
                          setState(() {});
                        }
                      },
                      child: Icon(Icons.input,
                          color: themeContoller.themeData.value.primaryColor)),
                  Visibility(
                    visible: e.password!.isEmpty,
                    child: InkWell(
                      onTap: () async {
                        var result = await Get.defaultDialog(
                          content: PasswordChange(
                            subGroup: e,
                          ),
                          title: 'set_password'.tr,
                        );
                        if (result == true) {
                          Get.snackbar('warning'.tr,
                              'Your password created successfully');
                          e.passwordConfirmed = true;
                          await e.save();
                          setState(() {});
                        }
                      },
                      child: Icon(Icons.lock),
                    ),
                  ),
                  (e.password!.isNotEmpty)
                      ? InkWell(
                          onTap: () async {
                            if (e.password!.length > 0 &&
                                e.passwordConfirmed != true) {
                              //Get.snackbar('title', 'sfswf');
                              var result = await Get.defaultDialog(
                                  content: PasswordDialog(
                                    password: e.password!,
                                  ),
                                  title: 'enter_password'.tr);
                              if (result != true) {
                                return;
                              }
                            }
                            var result = await Get.defaultDialog(
                              content: PasswordChange(
                                subGroup: e,
                              ),
                              title: 'change_password'.tr,
                            );
                            if (result == true) {
                              Get.snackbar('warning',
                                  'Your password changed successfully');
                              e.passwordConfirmed = true;
                              await e.save();
                              setState(() {});
                            }
                          },
                          child: Icon(
                              (e.passwordConfirmed == true)
                                  ? Icons.lock_open
                                  : Icons.lock,
                              color:
                                  themeContoller.themeData.value.primaryColor))
                      : Container(),
                  InkWell(
                      onTap: () async {
                        uploadBook();
                      },
                      child: Icon(Icons.upload,
                          color: themeContoller.themeData.value.primaryColor)),
                  InkWell(
                    onTap: () async {
                      if (e.password!.length > 0 &&
                          e.passwordConfirmed != true) {
                        //Get.snackbar('title', 'sfswf');
                        var result = await Get.defaultDialog(
                            content: PasswordDialog(
                              password: e.password!,
                            ),
                            title: 'enter_password'.tr);
                        if (result == true) {
                          e.passwordConfirmed = true;
                          int? id = await e.save();
                          await Get.to(SubGroupAdd(e));
                          setState(() {});
                        }
                      } else {
                        await Get.to(SubGroupAdd(e));
                        setState(() {});
                      }
                    },
                    child: Icon(Icons.edit,
                        color: themeContoller.themeData.value.primaryColor),
                  ),
                  InkWell(
                      onTap: () async {
                        if (e.password!.length > 0 &&
                            e.passwordConfirmed != true) {
                          //Get.snackbar('title', 'sfswf');
                          var result = await Get.defaultDialog(
                              content: PasswordDialog(
                                password: e.password!,
                              ),
                              title: 'enter_password'.tr);
                          if (result == true) {
                            e.passwordConfirmed = true;
                            int? id = await e.save();
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
                          } else {
                            Get.snackbar('warning'.tr, 'denied_msg'.tr);
                          }
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
                        }
                      },
                      child: Icon(Icons.delete,
                          color: themeContoller.themeData.value.primaryColor)),
                ],
              ),
            )),
      ),
    );
  }
}
