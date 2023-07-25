import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Fast_learning/card_view_page.dart';
import 'package:Fast_learning/controllers/theme_controller.dart';
import 'package:Fast_learning/leitner_box/audio_player.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:Fast_learning/leitner_box/customWidgets/headerButtons.dart';
import 'package:Fast_learning/leitner_box/customWidgets/percentageCircle.dart';
import 'package:Fast_learning/leitner_box/screens/makeNewFlashcard.dart';
import 'package:Fast_learning/music.dart';
import 'package:Fast_learning/password_dialog.dart';
import 'package:Fast_learning/zcomponent/common_widget/translation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'constants/preference.dart';
import 'controllers/cards_controller.dart';
import 'date.dart';
import 'history_card_review_complete.dart';
import 'model/model.dart';
import 'package:get/get.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_quill/flutter_quill.dart' as qu;

import 'tools/export/lesson_page.dart';

class CustomCardPage extends StatefulWidget {
  final Lesson lesson;
  final bool auto_open_first;
  final List<Lesson>? list_of_lessons;
  final int lesson_index;
  final int radioSelected;
  final int cardIndex;
  final bool isEditable;
  CustomCardPage({
    Key? key,
    required this.lesson,
    this.auto_open_first = false,
    this.list_of_lessons,
    required this.lesson_index,
    this.radioSelected = 0,
    this.cardIndex = 0,
    this.isEditable = true,
  }) : super(key: key);

  @override
  _CustomCardPageState createState() => _CustomCardPageState();
}

class _CustomCardPageState extends State<CustomCardPage> {
  List<int> viewItems = [];
  CardsController _cardsController = Get.find<CardsController>();
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  qu.QuillController storyDescController = qu.QuillController.basic();
  qu.QuillController descController = qu.QuillController.basic();
  final AudioPlayer _player = AudioPlayer();
  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    try {
      await _player.setFilePath(widget.lesson.storyVoicePathOne!);
      //  await _player.setAudioSource(AudioSource.uri(Uri.parse(
      //     "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void initState() {
    if (widget.lesson.storyDesc != null) {
      final doc = qu.Document()..insert(0, widget.lesson.storyDesc);
      try {
        storyDescController = qu.QuillController(
            document:
                qu.Document.fromJson(jsonDecode(widget.lesson.storyDesc!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        storyDescController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
    if (widget.lesson.descriptionDesc != null) {
      final doc = qu.Document()..insert(0, widget.lesson.descriptionDesc);
      try {
        descController = qu.QuillController(
            document: qu.Document.fromJson(
                jsonDecode(widget.lesson.descriptionDesc!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        descController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
    _init();
    super.initState();
    cc.cardsId.clear();
    cc.isSelection = false;
    cc.editCard = false;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  final CardsController cc = Get.find();
  List<TblCard> cards = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          // appBar: AppBar(
          //   // actions: [
          //   //   Container(
          //   //     margin: EdgeInsets.only(right: 20, left: 20),
          //   //     child: Row(
          //   //       children: [
          //   //         GestureDetector(
          //   //           onTap: () async {
          //   //             if (widget.lesson.plSubGroup!.password!.length > 0 &&
          //   //                 widget.lesson.plSubGroup!.passwordConfirmed !=
          //   //                     true) {
          //   //               //Get.snackbar('title', 'sfswf');
          //   //               var result = await Get.defaultDialog(
          //   //                   content: PasswordDialog(
          //   //                     password: widget.lesson.plSubGroup!.password!,
          //   //                   ),
          //   //                   title: 'enter_password'.tr);
          //   //               if (result == true) {
          //   //                 await Get.to(TblCardAdd(TblCard(
          //   //                     lessonId: widget.lesson.id,
          //   //                     ratio: widget.lesson.plSubGroup?.ratio)));
          //   //                 setState(() {});
          //   //               }
          //   //             } else {
          //   //               await Get.to(TblCardAdd(TblCard(
          //   //                   lessonId: widget.lesson.id,
          //   //                   ratio: widget.lesson.plSubGroup?.ratio)));
          //   //               setState(() {});
          //   //             }
          //   //             // await Get.to(TblCardAdd(TblCard(
          //   //             //     lessonId: widget.lessson.id,
          //   //             //     ratio: widget.lessson.plSubGroup?.ratio)));
          //   //             // _cardsController.rebind();
          //   //             // setState(() {});
          //   //           },
          //   //           child: Icon(Icons.add, color: Colors.white),
          //   //         ),
          //   //         Container(
          //   //           width: 15,
          //   //         ),
          //   //         InkWell(
          //   //           onTap: () {
          //   //             Navigator.of(context)
          //   //                 .popUntil((route) => route.isFirst);
          //   //           },
          //   //           child: Icon(Icons.home, color: Colors.white),
          //   //         )
          //   //       ],
          //   //     ),
          //   //   ),
          //   // ],
          //   // centerTitle: true,
          //   title: Text(
          //     ((widget.list_of_lessons != null)
          //             ? '${widget.lesson_index + 1}/${widget.list_of_lessons?.length} - '
          //             : '') +
          //         ((widget.lesson.title != null)
          //             ? widget.lesson.title!
          //             : 'cards'.tr),
          //     style:
          //         Get.theme.textTheme.headline1!.copyWith(color: Colors.white),
          //   ),
          //   leading: InkWell(
          //     child: Icon(
          //       CupertinoIcons.back,
          //       color: Colors.white,
          //     ),
          //     onTap: () {
          //       Get.back();
          //     },
          //   ),
          // ),
          body: Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 45),
            child: Column(
              children: [
                app_Bar(
                  title_text: ((widget.list_of_lessons != null)
                          ? '${widget.lesson_index + 1}/${widget.list_of_lessons?.length} - '
                          : '') +
                      ((widget.lesson.title != null)
                          ? widget.lesson.title!
                          : 'cards'.tr),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Stack(
                    children: [
                      Container(
                        height: 48,
                        child: TabBar(
                          // controller: _tabController,
                          labelColor: Color(0xff27187E),
                          unselectedLabelColor: Color(0xff8A8A8A),
                          indicator: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xff27187E), width: 5))),
                          //unselectedLabelColor: Colors.black87,
                          tabs: [
                            Tab(
                                child: Text('cards'.tr!,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16))),
                            Tab(
                                child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(widget.lesson.storyTitle!,
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            )),
                            Tab(
                                child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(widget.lesson.descriptionTitle!,
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            )),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 0.8,
                          child: Container(
                            height: 2.5,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black26,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    // Tab 1: cards
                    Container(
                        padding: EdgeInsets.all(8), child: getTabViewOne()),
                    // Tab 2: Story
                    generateLessonDescription(
                      storyDescController,
                      title: widget.lesson.storyTitle!,
                      imagePath: widget.lesson.storyImagePath!,
                      voicePathOne: widget.lesson.storyVoicePathOne!,
                      voicePathTwo: widget.lesson.storyVoicePathTwo!,
                    ),
                    // Tab 3: Description
                    generateLessonDescription(
                      descController,
                      title: widget.lesson.descriptionTitle!,
                      imagePath: widget.lesson.descriptionImagePath!,
                      voicePathOne: widget.lesson.descriptionVoicePathOne!,
                      voicePathTwo: widget.lesson.descriptionVoicePathTwo!,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }

  Widget generateLessonDescription(
    qu.QuillController quillController, {
    String? title,
    String? imagePath,
    String? voicePathOne,
    String? voicePathTwo,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 256,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 100, spreadRadius: 0.5)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 1 / 2,
                child: Container(
                  padding: EdgeInsets.all(8),
                  // child: Text(widget.lessson.storyDesc ?? '')
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: qu.QuillEditor.basic(
                          controller: quillController,
                          readOnly: true, // true for view only mode
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                            onPressed: () {
                              String text =
                                  quillController.document.toPlainText();
                              translationDialog(text);
                            },
                            icon: Icon(Icons.translate_rounded)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          imagePath != null && imagePath.isNotEmpty
              ? Image.file(
                  File(imagePath),
                  height: 275,
                )
              : Container(),
          SizedBox(height: 20),
          voicePathOne != null && voicePathOne.isNotEmpty
              ? Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("First Voice",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                                color: Color(0xff353535)))),
                    SizedBox(height: 10),
                    CustomAudioPlayerV2(audio_url: voicePathOne!),
                    SizedBox(height: 20),
                  ],
                )
              : Container(),
          voicePathTwo != null && voicePathTwo.isNotEmpty
              ? Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Second Voice",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              color: Color(0xff353535)),
                        )),
                    SizedBox(height: 10),
                    CustomAudioPlayerV2(audio_url: voicePathTwo!),
                    SizedBox(height: 30),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Container generateLessonDescription1(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 8, left: 8),
      child: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 1 / 2,
            child: Card(
                child: Container(
              padding: EdgeInsets.all(8),
              // child: Text(widget.lessson.storyDesc ?? '')
              child: qu.QuillEditor.basic(
                controller: storyDescController,
                readOnly: true, // true for view only mode
              ),
            )),
          ),
          (widget.lesson.storyVoicePathOne == null ||
                  widget.lesson.storyVoicePathOne!.isEmpty)
              ? Container()
              : ControlButtonsOld(path: widget.lesson.storyVoicePathOne),
          (widget.lesson.storyVoicePathTwo == null ||
                  widget.lesson.storyVoicePathTwo!.isEmpty)
              ? Container()
              : ControlButtonsOld(path: widget.lesson.storyVoicePathTwo),
          widget.lesson.storyImagePath == null
              ? Container()
              : Image.file(File(widget.lesson.storyImagePath!)),
        ],
      ),
    );
  }

  Widget getTabViewOne() {
    return Scaffold(
      floatingActionButton: widget.isEditable ? createCardBtn() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          if (widget.isEditable) topAppBar(),
          // SizedBox(height: 10),
          Expanded(
              child: FutureBuilder(
                  future: TblCard()
                      .select()
                      .lessonId
                      .equals(widget.lesson.id)
                      .orderBy('orderIndex')
                      .toList(loadParents: true),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TblCard>> cardsSnapshot) {
                    if (cardsSnapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (widget.radioSelected == RadioOptions.All.index)
                      cards = cardsSnapshot.data!;
                    // IF choose learned cards

                    if (widget.radioSelected == RadioOptions.Review.index)
                      cards = cardsSnapshot.data!
                          .where((x) =>
                              (x.reviewStart == false && x.examDone == false))
                          .toList();
                    // IF choose not learned cards
                    if (widget.radioSelected == RadioOptions.Learned.index)
                      cards = cardsSnapshot.data!
                          .where((x) => x.examDone == true)
                          .toList();

                    if (widget.auto_open_first) {
                      viewItems.add(cards!.first.id!);
                      SharedPreferences.getInstance().then((prefs) {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (BuildContext context) {
                              return CupertinoPageScaffold(
                                  resizeToAvoidBottomInset: true,
                                  child: CardViewPage(
                                      cards: cards!,
                                      currentCard: cards!.first,
                                      lesson: widget.lesson,
                                      lesson_index: widget.lesson_index,
                                      list_of_lessons: widget.list_of_lessons,
                                      autoOpenCardView: true,
                                      cardIndex: widget.cardIndex,
                                      prefs: prefs,
                                      isEditable: widget.isEditable));
                            },
                          ),
                        );
                      });
                    }
                    qu.QuillController questionController =
                        qu.QuillController.basic();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ReorderableListView(
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex < oldIndex) {
                                int order = cards![newIndex].orderIndex!;
                                final item = cards!.removeAt(oldIndex);

                                cards!.insert(newIndex, item);
                                cards![newIndex]
                                  ..orderIndex = order
                                  ..save();
                                order++;
                                print(order);
                                for (var i = newIndex + 1;
                                    i < cards!.length;
                                    i++) {
                                  cards![i]
                                    ..orderIndex = order
                                    ..save();
                                }
                              } else {
                                newIndex -= 1;

                                int order = cards![newIndex].orderIndex!;
                                final item = cards!.removeAt(oldIndex);

                                cards!.insert(newIndex, item);
                                cards![newIndex]
                                  ..orderIndex = order
                                  ..save();
                                order--;
                                print(order);
                                for (var i = newIndex - 1; i >= 0; i--) {
                                  cards![i]
                                    ..orderIndex = order
                                    ..save();
                                }
                              }
                            });
                          },
                          children: [
                            for (var index = 0; index < cards!.length; index++)
                              Builder(
                                key: ValueKey("$index"),
                                builder: (context) {
                                  final e = cards![index];
                                  if (e.question != null) {
                                    final doc = qu.Document()
                                      ..insert(0, e.question);
                                    try {
                                      questionController = qu.QuillController(
                                          document: qu.Document.fromJson(
                                              jsonDecode(e.question!)),
                                          selection: TextSelection.collapsed(
                                              offset: 0));
                                    } catch (e) {
                                      questionController = qu.QuillController(
                                          document: doc,
                                          selection:
                                              const TextSelection.collapsed(
                                                  offset: 0));
                                    }
                                  }

                                  var json = jsonEncode(questionController
                                      .document
                                      .toDelta()
                                      .toJson());
                                  final CardsController cc = Get.find();
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, top: 8.0),
                                    child: InkWell(
                                      onLongPress: cc.isEditPosition
                                          ? null
                                          : (() {
                                              selectionMethod(index);
                                              setState(() {});
                                            }),
                                      onTap: cc.isEditPosition
                                          ? null
                                          : () async {
                                              if (cc.isSelection) {
                                                selectionMethod(index);
                                                return;
                                              }
                                              setState(() {});

                                              viewItems.add(e.id!);
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();

                                              await Navigator.of(context).push(
                                                CupertinoPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoPageScaffold(
                                                        resizeToAvoidBottomInset:
                                                            true,
                                                        child: CardViewPage(
                                                          cards: cards!,
                                                          currentCard: e,
                                                          lesson: widget.lesson,
                                                          list_of_lessons: widget
                                                              .list_of_lessons,
                                                          lesson_index: widget
                                                              .lesson_index,
                                                          prefs: prefs,
                                                          isEditable:
                                                              widget.isEditable,
                                                        ));
                                                  },
                                                ),
                                              );

                                              setState(() {});
                                            },
                                      child: Container(
                                        decoration: (viewItems.indexOf(e.id!) >
                                                -1)
                                            ? BoxDecoration(
                                                color:
                                                    cc.cardsId.contains(index)
                                                        ? Color.fromARGB(
                                                            52, 39, 24, 126)
                                                        : Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color(0xff27187E)))
                                            : BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color:
                                                    cc.cardsId.contains(index)
                                                        ? Color.fromARGB(
                                                            52, 39, 24, 126)
                                                        : Colors.white,
                                              ),
                                        child: cardItem(
                                            e, questionController, cards),
                                      ),
                                    ),
                                  );
                                },
                              )
                          ]),
                    );
                  })),
        ],
      ),
    );
  }

  SingleChildScrollView topAppBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Wrap(
          spacing: 5,
          children: [
            GetBuilder<CardsController>(builder: (cc) {
              return CustomSwitch(
                clr: Color(0xff27187E),
                scale: .14,
                imgPath: 'assets/images/arrow-3.png',
                text1: 'Edit Position',
                isEnabled: !cc.isSelection,
                value: cc.isEditPosition,
                onChanged: ((value) {
                  cc.isEditPosition = !cc.isEditPosition;

                  setState(() {});
                }),
              );
            }),
            GetBuilder<CardsController>(builder: (cc) {
              return CustomSwitch(
                scale: .14,
                clr: Color(0xff27187E),
                icon: cc.cardsId.length == cards.length
                    ? Icons.deselect_outlined
                    : Icons.library_add_check_outlined,
                text1: cc.cardsId.length == cards.length && cc.isSelection
                    ? "Deselect All"
                    : "Select All",
                isEnabled: !cc.isEditPosition,
                isPushBtn: true,
                onChanged: cc.isEditPosition
                    ? null
                    : (value) {
                        if (cc.cardsId.length >= cards!.length) {
                          cc.cardsId.clear();
                          cc.isSelection = false;
                        } else {
                          cc.isSelection = true;
                          cc.cardsId.clear();
                          for (var index = 0; index < cards!.length; index++)
                            cc.cardsId.add(index);
                        }
                        cc.editCard = cc.cardsId.length == 1;
                        cc.update();
                        setState(() {});
                      },
              );
            }),
            Obx(() {
              return CustomSwitch(
                  clr: Color(0xff27187E),
                  imgPath: 'assets/images/edit-icon.png',
                  text1: 'Edit Card',
                  scale: .14,
                  isPushBtn: true,
                  isEnabled: cc.editCard,
                  onChanged: cc.editCard
                      ? ((value) async {
                          await Get.to(TblCardAdd(cards![cc.cardsId.first]));
                          _cardsController.rebind();
                          setState(() {});
                        })
                      : null);
            }),
            CustomSwitch(
              clr: Color(0xff27187E),
              imgPath: 'assets/images/note.png',
              text1: 'Send To Training',
              scale: .14,
              isPushBtn: true,
              onChanged: ((value) {
                for (var i in cc.cardsId) {
                  cards?[i].reviewStart = false;
                  cards?[i].save();
                }
                cc.cardsId.clear();
                cc.isSelection = false;
                cc.editCard = false;
                cc.update();
                _cardsController.rebind();
                setState(() {});
              }),
            ),
            CustomSwitch(
              clr: Color(0xff27187E),
              scale: .14,
              imgPath: 'assets/images/repeat.png',
              isPushBtn: true,
              text1: 'Send To Review',
              onChanged: ((value) {
                for (var i in cc.cardsId) {
                  cards?[i].reviewStart = true;
                  cards?[i].save();
                }
                cc.cardsId.clear();
                cc.isSelection = false;
                cc.editCard = false;
                cc.update();
                _cardsController.rebind();
                setState(() {});
              }),
            ),
            CustomSwitch(
              clr: Color(0xff27187E),
              scale: .14,
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
                      cc.cardsId.sort((a, b) => b.compareTo(a));

                      for (var i in cc.cardsId) {
                        await cards?.removeAt(i).delete(true);
                      }
                      cc.cardsId.clear();
                      cc.isSelection = false;
                      cc.editCard = false;
                      cc.update();
                      Get.back();
                    });
                setState(() {});
              }),
            ),
          ],
        ),
      ),
    );
  }

  DottedBorder createCardBtn() {
    return DottedBorder(
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
              if (widget.lesson.plSubGroup!.password!.length > 0 &&
                  widget.lesson.plSubGroup!.passwordConfirmed != true) {
                //Get.snackbar('title', 'sfswf');
                var result = await Get.defaultDialog(
                    content: PasswordDialog(
                      password: widget.lesson.plSubGroup!.password!,
                    ),
                    title: 'enter_password'.tr);
                if (result == true) {
                  await Get.to(TblCardAdd(TblCard(
                      lessonId: widget.lesson.id,
                      ratio: widget.lesson.plSubGroup?.ratio)));
                  setState(() {});
                }
              } else {
                await Get.to(TblCardAdd(TblCard(
                    lessonId: widget.lesson.id,
                    ratio: widget.lesson.plSubGroup?.ratio)));
                setState(() {});
              }
            },
            backgroundColor: Color(0xffF1F2F6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Color(0xff8A8A8A), size: 24),
                SizedBox(width: 5),
                Text(
                  "Make New Flashcard",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff8A8A8A)),
                ),
              ],
            ),
          )),
    );
  }

  void selectionMethod(int index) {
    CardsController cc = Get.find();
    if (cc.cardsId.contains(index)) {
      cc.cardsId.remove(index);
    } else {
      cc.cardsId.add(index);
    }
    if (cc.cardsId.length > 0)
      cc.isSelection = true;
    else
      cc.isSelection = false;

    if (cc.cardsId.length == 1)
      cc.editCard = true;
    else
      cc.editCard = false;

    cc.update();
    setState(() {});
  }

  void cardInfoDialog(BuildContext context, TblCard e) {
    Get.dialog(Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: themeContoller.themeData.value.primaryColor,
                  borderRadius: BorderRadius.circular(25)),
              margin: EdgeInsets.only(top: 0, bottom: 5, right: 10, left: 10),
              height: 300,
              //color: Colors.
              width: MediaQuery.of(context).size.width - 50,
              //  height: 350,
              //margin: EdgeInsets.only(right:10,left:10,top:30,bottom:30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Text('date_created'.tr),
                    title: Text(
                        miladiToShamsiDateTimeFormat(e.dateCreated.toString())),
                  ),
                  ListTile(
                    leading: Text('time_question'.tr),
                    title: Text(miladiToShamsiDateTimeFormat(
                        e.boxVisibleDate.toString())),
                  ),
                  ListTile(
                    leading: Text('box_number'.tr),
                    title: Text(e.boxNumber.toString()),
                  ),
                  ListTile(
                    leading: Text('position'.tr),
                    title: Text(e.orderIndex.toString()),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 10,
              child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: themeContoller.themeData.value.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.close, color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    ));
  }

  Widget cardItem(
      TblCard e, qu.QuillController questionController, List<TblCard>? cards) {
    return percetageCircle(
      percentage_text:
          '%${((e.boxNumber! / e.plLesson!.plSubGroup!.boxCount!) * 100).toInt()}',
      percent_progress_color: Color(0xff4daf15),
      percent_bg_color: Color(0x20E04318),
      image_widget: (e.imagePath != null && e.imagePath!.isNotEmpty)
          ? Image.file(
              File(e.imagePath!),
              fit: BoxFit.cover,
            )
          : Image.asset('assets/images/noimage.png', fit: BoxFit.cover),
      txt1: questionController.document
              .toPlainText()
              .toString()
              .substring(
                  0, min(questionController.document.toPlainText().length, 30))
              .trim() +
          '\r\n',
      txt2: '${cards!.indexOf(e) + 1}/${cards.length}',
      percent: e.boxNumber!.toDouble() /
          e.plLesson!.plSubGroup!.boxCount!.toDouble(),
    );
  }

  Widget cardItem2(
      TblCard e, qu.QuillController questionController, List<TblCard>? cards) {
    return Card(
      child: Stack(
        children: [
          e.examDone == true
              ? Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Transform(
                        transform: Matrix4.rotationZ(18),
                        alignment: FractionalOffset.center,
                        child: Text(
                          'learned'.tr,
                          style: Get.theme.textTheme.headline1!
                              .copyWith(color: Colors.red[800], fontSize: 24),
                        ),
                      ),
                    ),
                  ))
              : Container(),
          ListTile(
            //selected: (viewItems.indexOf(e.id!) > -1),
            selectedTileColor:
                themeContoller.themeData.value.backgroundColor.withOpacity(0.5),
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            dense: true,
            tileColor: (e.reviewStart == true)
                ? themeContoller.themeData.value.primaryColor
                : Colors.transparent,
            leading: Container(
              width: 80,
              height: 80,
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
            //  title: Text(e.question!),
            title: Container(
              // height:80,
              child: Text(
                questionController.document
                        .toPlainText()
                        .toString()
                        .substring(
                            0,
                            min(
                                questionController.document
                                    .toPlainText()
                                    .length,
                                30))
                        .trim() +
                    '\r\n' +
                    '${cards!.indexOf(e) + 1}/${cards.length}',
                overflow: TextOverflow.fade,
                maxLines: 4,
                style: e.reviewStart == true || e.examDone == true
                    ? themeContoller.themeData.value.textTheme.bodyText1!
                        .copyWith(color: Colors.white)
                    : themeContoller.themeData.value.textTheme.bodyText1!
                        .copyWith(),
              ),
            ),
            subtitle: Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.all(20),
                child: LinearProgressIndicator(
                  valueColor: (e.reviewStart == true)
                      ? new AlwaysStoppedAnimation<Color>(Colors.white)
                      : new AlwaysStoppedAnimation<Color>(
                          themeContoller.themeData.value.primaryColor),
                  backgroundColor: Colors.grey,
                  value: (e.boxNumber! / widget.lesson.plSubGroup!.boxCount!),
                )),

            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () async {
                          e.orderIndex = e.orderIndex! - 1;
                          await e.save();
                          setState(() {});
                        },
                        child: Icon(Icons.remove,
                            color: (e.reviewStart == true || e.examDone == true)
                                ? Colors.white
                                : themeContoller.themeData.value.primaryColor)),
                    Container(
                      width: 8,
                    ),
                    InkWell(
                        onTap: () async {
                          e.orderIndex = e.orderIndex! + 1;
                          await e.save();
                          setState(() {});
                        },
                        child: Icon(Icons.add,
                            color: (e.reviewStart == true || e.examDone == true)
                                ? Colors.white
                                : themeContoller.themeData.value.primaryColor)),
                    Container(
                      width: 8,
                    ),
                    (e.reviewStart == false)
                        ? InkWell(
                            onTap: () async {
                              e.reviewStart = true;
                              await e.save();
                              _cardsController.rebind();
                              setState(() {});
                            },
                            child: Icon(Icons.input,
                                color: (e.reviewStart == true ||
                                        e.examDone == true)
                                    ? Colors.white
                                    : themeContoller
                                        .themeData.value.primaryColor))
                        : InkWell(
                            onTap: () async {
                              e.reviewStart = false;
                              await e.save();
                              _cardsController.rebind();
                              setState(() {});
                            },
                            child: Icon(Icons.outbond,
                                color: (e.reviewStart == true)
                                    ? Colors.white
                                    : themeContoller
                                        .themeData.value.primaryColor)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (widget.lesson.plSubGroup!.password!.length > 0 &&
                            widget.lesson.plSubGroup!.passwordConfirmed !=
                                true) {
                          //Get.snackbar('title', 'sfswf');
                          var result = await Get.defaultDialog(
                              content: PasswordDialog(
                                password: widget.lesson.plSubGroup!.password!,
                              ),
                              title: 'enter_password'.tr);
                          if (result == true) {
                            await Get.to(TblCardAdd(e));
                            _cardsController.rebind();
                            setState(() {});
                          }
                        } else {
                          await Get.to(TblCardAdd(e));
                          _cardsController.rebind();
                          setState(() {});
                        }

                        // await Get.to(TblCardAdd(e));
                        // _cardsController.rebind();
                        // setState(() {});
                      },
                      child: Icon(Icons.edit,
                          color: (e.reviewStart == true || e.examDone == true)
                              ? Colors.white
                              : themeContoller.themeData.value.primaryColor),
                    ),
                    Container(
                      width: 8,
                    ),
                    InkWell(
                        onTap: () async {
                          if (widget.lesson.plSubGroup!.password!.length > 0 &&
                              widget.lesson.plSubGroup!.passwordConfirmed !=
                                  true) {
                            //Get.snackbar('title', 'sfswf');
                            var result = await Get.defaultDialog(
                                content: PasswordDialog(
                                  password: widget.lesson.plSubGroup!.password!,
                                ),
                                title: 'enter_password'.tr);
                            if (result != true) {
                              return;
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
                            //await  e.delete(true);
                            setState(() {});
                          }
                        },
                        child: Icon(Icons.delete,
                            color: (e.reviewStart == true || e.examDone == true)
                                ? Colors.white
                                : themeContoller.themeData.value.primaryColor)),
                    Container(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(HistoryCardReviewComplete(cardId: e.id!));
                      },
                      child: Icon(Icons.history,
                          color: (e.reviewStart == true || e.examDone == true)
                              ? Colors.white
                              : themeContoller.themeData.value.primaryColor),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
