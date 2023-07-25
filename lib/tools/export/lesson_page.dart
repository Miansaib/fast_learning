import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:Fast_learning/card_view_page.dart';
import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/controllers/inapp_purchase_controller.dart';
import 'package:Fast_learning/controllers/lessons_controller.dart';
import 'package:Fast_learning/leitner_box/customWidgets/circule_number.dart';
import 'package:Fast_learning/leitner_box/customWidgets/percentageCircle.dart';
import 'package:Fast_learning/pages/buy_subscription/buy_subscription_page.dart';
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

import '../../add_token.dart';
import '../../controllers/cards_controller.dart';
import '../../controllers/theme_controller.dart';
import '../download_dialog.dart';
import '../show_loading_widget.dart';

class LessonPage extends StatefulWidget {
  final SubGroup subGroup;
  final int radioSelected;

  LessonPage({
    Key? key,
    required this.subGroup,
    required this.radioSelected,
  }) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

enum RadioOptions { All, Learned, Review }

class _LessonPageState extends State<LessonPage> {
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
    lc.lessonId.clear();
    lc.isSelection = false;
    lc.editLesson = false;
    // lc.update();
    super.initState();
  }

  List<int> viewItems = [];
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  CardsController _cardsController = Get.find<CardsController>();
  MainLessonsController lc = Get.find();

  List<Lesson> filterdList = [];

  Future lesson_page_zip_without_token() async {
    await zipLessons(widget.subGroup).then((value) {
      _cardsController.rebind();
      Get.back();
    });
  }

  Future lesson_page_zip_with_token(List<String>? tokens) async {
    print(tokens);
    if (tokens != null && tokens.length != 0) {
      zipLessons(widget.subGroup, tokens: tokens).then((value) {
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
        actions: [
          Container(
            // margin: EdgeInsets.only(right: 20, left: 20),
            child: Row(
              children: [
                // GestureDetector(
                //   onTap: () async {
                //     if (widget.subGroup.password!.length > 0 &&
                //         widget.subGroup.passwordConfirmed != true) {
                //       //Get.snackbar('title', 'sfswf');
                //       var result = await Get.defaultDialog(
                //           content: PasswordDialog(
                //             password: widget.subGroup.password!,
                //           ),
                //           title: 'enter_password'.tr);
                //       if (result == true) {
                //         await Get.to(
                //             LessonAdd(Lesson(subGroupId: widget.subGroup.id)));
                //         setState(() {});
                //       }
                //     } else {
                //       await Get.to(
                //           LessonAdd(Lesson(subGroupId: widget.subGroup.id)));
                //       setState(() {});
                //     }
                //   },
                //   child: Icon(
                //     Icons.add,
                //     color: Colors.white,
                //   ),
                // ),
                // Container(
                //   width: 15,
                // ),
                InkWell(
                  child: Icon(
                    Icons.filter_alt_outlined,
                    color: Color(0xff353535),
                  ),
                  onTap: () {
                    Get.defaultDialog(
                        title: "Filter List",
                        content: StreamBuilder<Object>(
                            stream: radioStream,
                            builder: (context, snapshot) {
                              return Column(
                                // mainAxisSize: MainAxisSize.min,
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RadioListTile<int>(
                                    // dense: true,
                                    title: Text("All Cards"),
                                    value: RadioOptions.All.index,
                                    groupValue: _value,
                                    onChanged: (int? value) {
                                      // Update map value on tap
                                      _value = value!;
                                      _radioStream.add(value);
                                      // setState(() {
                                      // });
                                      SharedPreferences.getInstance()
                                          .then((prefs) async {
                                        prefs.setInt(
                                            Preference.reviewRadioOption,
                                            value);
                                      });
                                    },
                                  ),
                                  RadioListTile<int>(
                                    title: Text("Just Learned"),
                                    value: RadioOptions.Learned.index,
                                    groupValue: _value,
                                    onChanged: (int? value) {
                                      _value = value!;
                                      _radioStream.add(value);
                                      // setState(() {
                                      // });
                                      SharedPreferences.getInstance()
                                          .then((prefs) async {
                                        prefs.setInt(
                                            Preference.reviewRadioOption,
                                            value);
                                      });
                                    },
                                  ),
                                  RadioListTile<int>(
                                    title: Text("Don't Added to Leitner"),
                                    value: RadioOptions.Review.index,
                                    groupValue: _value,
                                    onChanged: (int? value) {
                                      // Update map value on tap
                                      _value = value!;
                                      _radioStream.add(value);
                                      // setState(() {
                                      // });
                                      SharedPreferences.getInstance()
                                          .then((prefs) async {
                                        prefs.setInt(
                                            Preference.reviewRadioOption,
                                            value);
                                      });
                                    },
                                  ),
                                ],
                              );
                            }));
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Icon(
                    Icons.home,
                    color: Color(0xff353535),
                  ),
                ),

                Container(
                    margin: EdgeInsets.only(right: 20, left: 20),
                    child: new PopupMenuButton(
                      child: Icon(
                        Icons.more_vert,
                        color: Color(0xff353535),
                      ),
                      itemBuilder: (_) => <PopupMenuItem<int>>[
                        new PopupMenuItem<int>(
                            child: new Text('add_lesson'.tr), value: 0),
                        new PopupMenuItem<int>(
                            child: new Text('import_lessons'.tr), value: 1),
                        new PopupMenuItem<int>(
                            child: new Text('import_lessons_from_link'.tr),
                            value: 4),
                        new PopupMenuItem<int>(
                            child: new Text('export_all_lessons'.tr), value: 2),
                        new PopupMenuItem<int>(
                            child: new Text('export_selected_lessons'.tr),
                            value: 3),
                      ],
// ignore: top_level_function_literal_block
                      onSelected: (value) async {
                        switch (value) {
                          case 0:
                            if (widget.subGroup.password!.length > 0 &&
                                widget.subGroup.passwordConfirmed != true) {
                              //Get.snackbar('title', 'sfswf');
                              var result = await Get.defaultDialog(
                                  content: PasswordDialog(
                                    password: widget.subGroup.password!,
                                  ),
                                  title: 'enter_password'.tr);
                              if (result == true) {
                                await Get.to(LessonAdd(
                                    Lesson(subGroupId: widget.subGroup.id)));
                                setState(() {});
                              }
                            } else {
                              await Get.to(LessonAdd(
                                  Lesson(subGroupId: widget.subGroup.id)));
                              setState(() {});
                            }
                            setState(() {});
                            break;
                          case 1:
                            await unzipFiles(
                                rootGroup: RootGroup(),
                                subGroup: widget.subGroup);
                            Get.back();
                            Future.delayed(Duration(seconds: 1), () {
                              // widget.refreshParentPageFunc!();
                              setState(() {});
                            });
                            break;
                          case 4:
                            await download_dialog(
                              onPressed: () {
                                _cardsController.download_books(RootGroup(),
                                    subgroup: widget.subGroup);
                              },
                              onPressedUseLastDownload: () {
                                _cardsController.download_books(RootGroup(),
                                    subgroup: widget.subGroup,
                                    useLastDownload: true);
                              },
                            );
                            break;
                          case 2:
                            if (widget.subGroup.password!.isNotEmpty &&
                                widget.subGroup.passwordConfirmed == false) {
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
                                    lesson_page_zip_without_token,
                                    "With Token",
                                    lesson_page_zip_with_token,
                                    "Loading",
                                    context));

                            break;
                          case 3:
                            if (widget.subGroup.password!.isNotEmpty &&
                                widget.subGroup.passwordConfirmed == false) {
                              Get.snackbar('warning',
                                  'The book is locked! and you have not permission to export');
                              return;
                            }
                            var lessons = await Lesson()
                                .select()
                                .subGroupId
                                .equals(widget.subGroup.id)
                                .orderBy('orderIndex')
                                .toList(loadParents: true);
                            Get.dialog(SelectLessons(
                                lessons: lessons, subGroup: widget.subGroup));
                            break;
                        }
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
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
                if (widget.subGroup.password!.length > 0 &&
                    widget.subGroup.passwordConfirmed != true) {
                  //Get.snackbar('title', 'sfswf');
                  var result = await Get.defaultDialog(
                      content: PasswordDialog(
                        password: widget.subGroup.password!,
                      ),
                      title: 'enter_password'.tr);
                  if (result == true) {
                    await Get.to(
                        LessonAdd(Lesson(subGroupId: widget.subGroup.id)));
                    setState(() {});
                  }
                } else {
                  await Get.to(
                      LessonAdd(Lesson(subGroupId: widget.subGroup.id)));
                  setState(() {});
                }
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
                    "Make New Lesson",
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
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createfolderdottedbtn("Import",
                      hint:
                          'You can import lessons that your friends or other users send to you, and use them.',
                      image: Image.asset('assets/images/import-icon.png'),
                      width: (Get.width / 2) - 30, onTap: () async {
                    await unzipFiles(
                        rootGroup: RootGroup(), subGroup: widget.subGroup);
                    Get.back();
                    // Future.delayed(Duration(seconds: 1), () {
                    //   // widget.refreshParentPageFunc!();
                    //   setState(() {});
                    // });
                  }),
                  createfolderdottedbtn("Export",
                      hint:
                          'you can also Export all your lessons to other users.',
                      image: Image.asset('assets/images/export-icon.png'),
                      width: (Get.width / 2) - 30, onTap: () async {
                    await exportDialog(context);
                    setState(() {});
                  }),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  Obx(() {
                    return CustomSwitch(
                      clr: Color(0xff27187E),
                      imgPath: 'assets/images/arrow-3.png',
                      text1: 'Edit Position',
                      isEnabled: !lc.isSelection,
                      value: lc.isEditPosition,
                      onChanged: lc.isSelection
                          ? null
                          : (value) {
                              lc.isEditPosition = !lc.isEditPosition;
                              setState(() {});
                            },
                    );
                  }),
                  Spacer(),
                  Obx(() {
                    return CustomSwitch(
                        clr: Color(0xff27187E),
                        imgPath: 'assets/images/edit-icon.png',
                        text1: 'Edit Lesson',
                        isPushBtn: true,
                        isEnabled: lc.editLesson,
                        onChanged: lc.editLesson
                            ? (value) async {
                                if (widget.subGroup.password!.length > 0 &&
                                    widget.subGroup.passwordConfirmed != true) {
                                  //Get.snackbar('title', 'sfswf');
                                  var result = await Get.defaultDialog(
                                      content: PasswordDialog(
                                        password: widget.subGroup.password!,
                                      ),
                                      title: 'enter_password'.tr);
                                  if (result == true) {
                                    await Get.to(LessonAdd(
                                        filterdList[lc.lessonId.first]));
                                    setState(() {});
                                  }
                                } else {
                                  print(filterdList.length);
                                  print(lc.lessonId.first);
                                  await Get.to(LessonAdd(
                                      filterdList[lc.lessonId.first]));
                                  setState(() {});
                                }
                              }
                            : null);
                  }),
                  Spacer(),
                  Obx(() {
                    return CustomSwitch(
                      clr: Color(0xff27187E),
                      icon: lc.lessonId.length == filterdList.length
                          ? Icons.deselect_outlined
                          : Icons.library_add_check_outlined,
                      text1: lc.lessonId.length == filterdList.length &&
                              lc.isSelection
                          ? "Deselect All"
                          : "Select All",
                      isEnabled: !lc.isEditPosition,
                      isPushBtn: true,
                      onChanged: lc.isEditPosition
                          ? null
                          : (value) {
                              if (lc.lessonId.length >= filterdList.length &&
                                  lc.isSelection) {
                                lc.lessonId.clear();
                                lc.isSelection = false;
                              } else {
                                lc.isSelection = true;
                                lc.lessonId.clear();
                                for (var index = 0;
                                    index < filterdList.length;
                                    index++) lc.lessonId.add(index);
                              }
                              lc.editLesson = lc.lessonId.length == 1;
                              lc.update();
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
                          title: "Delete",
                          middleText: "Do you want delete selected folders?",
                          textConfirm: "Delete",
                          textCancel: "Cancel",
                          confirmTextColor: Colors.black,
                          cancelTextColor: Colors.black,
                          buttonColor: Colors.red[400],
                          onConfirm: () async {
                            lc.lessonId.sort((a, b) => b.compareTo(a));

                            for (var i in lc.lessonId) {
                              await filterdList.removeAt(i).delete();
                            }
                            lc.lessonId.clear();
                            lc.isSelection = false;
                            lc.editLesson = false;
                            lc.update();
                            Get.back();
                          });
                      setState(() {});
                    }),
                  ),
                  Spacer(),
                ],
              ),
              Expanded(
                child: StreamBuilder<int>(
                    stream: radioStream,
                    builder: (context, radioSnapshot) {
                      //             List<TblCard> cards =
                      //     await TblCard().select().lessonId.equals(lessonId).toList();
                      // int allCards = cards.length;
                      // int cardsInLeiner = cards
                      //     .where((x) => (x.reviewStart == true && x.examDone == false))
                      //     .toList()
                      //     .length;
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

  Future select_lessons_page_zip_without_token() async {
    List<int> selectedIdGroups =
        lc.lessonId.map<int>((int e) => filterdList[e].id!).toList();

    await zipLessons(widget.subGroup, lessonIds: selectedIdGroups)
        .then((value) {
      _cardsController.rebind();
      Get.back();
    });
  }

  Future select_lessons_page_zip_with_token(List<String>? tokens) async {
    List<int> selectedIdGroups =
        lc.lessonId.map<int>((int e) => filterdList[e].id!).toList();

    if (tokens != null && tokens.length != 0) {
      await zipLessons(widget.subGroup,
          lessonIds: selectedIdGroups, tokens: tokens);
      _cardsController.rebind();
      Get.back();
    } else {
      Get.back();
      Get.snackbar('warning', 'please add token',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> exportDialog(BuildContext context) async {
    if (widget.subGroup.password!.isNotEmpty &&
        widget.subGroup.passwordConfirmed == false) {
      Get.snackbar('warning',
          'The book is locked! and you have not permission to export');
      return;
    }
    if (lc.lessonId.length == 0) {
      Get.snackbar('warning'.tr, 'Select at least one lesson',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    await Get.defaultDialog(
        title: 'Warning',
        middleText: 'Do you want to add tokens?',
        confirmTextColor: Colors.white,
        actions: get_popup_widget(
            "Without Token",
            select_lessons_page_zip_without_token,
            "With Token",
            select_lessons_page_zip_with_token,
            "loading",
            context));
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
        onLongPress: lc.isEditPosition
            ? null
            : (() {
                lc.selectionMethod(index);
                setState(() {});
              }),
        onTap: lc.isEditPosition
            ? null
            : () async {
                if (lc.isSelection) {
                  lc.selectionMethod(index);
                  setState(() {});
                  return;
                }
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
                              radioSelected: radioSelected));
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
