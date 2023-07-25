import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Fast_learning/leitner_box/audio_player.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:Fast_learning/leitner_box/customWidgets/twostatewidget.dart';
import 'package:Fast_learning/leitner_box/screens/cardReview.dart';
import 'package:Fast_learning/voice_record_view_page.dart';
import 'package:Fast_learning/zcomponent/common_widget/buttons.dart';
import 'package:Fast_learning/zcomponent/common_widget/translation.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:Fast_learning/constants/custom_color.dart';
import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:Fast_learning/controllers/theme_controller.dart';
import 'package:Fast_learning/history_card_review_complete.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/music.dart';
import 'package:Fast_learning/speed_controller.dart';
import 'package:Fast_learning/stop_watch_timer.dart';
import 'package:Fast_learning/tools/tools.dart';
import 'package:Fast_learning/voice_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:flutter_quill/flutter_quill.dart' as qu;
import 'constants/preference.dart';
import 'history_card_review.dart';
import 'package:darq/darq.dart';

class CardReviewPage extends StatefulWidget {
  bool autoPlay;
  bool autoRecord;
  bool quesShowImage;
  bool ansShowImage;
  final int? subGroupId;
  final int? caseType;
  CardReviewPage({
    Key? key,
    this.subGroupId,
    SharedPreferences? prefs,
    this.caseType,
  })  : autoPlay = prefs?.getBool(Preference.autoPlayReview) ?? false,
        autoRecord = prefs?.getBool(Preference.autoRecord) ?? false,
        quesShowImage = prefs?.getBool(Preference.quesShowImage) ?? false,
        ansShowImage = prefs?.getBool(Preference.ansShowImage) ?? false,
        super(key: key);
  @override
  _CardReviewState createState() => _CardReviewState();
}

class _CardReviewState extends State<CardReviewPage> {
  //ایندکس کارتهایی که یک بار برای آنها ضبط خودکار فعال شده است برای جلوگیری از
  //ضبط مجدد در این لیست نگهداری می شود
  List<int> cardIdRecordedVoiceAutoStarted = [];
  // GlobalKey<ControlButtonsState> questionVoiceControlBtnKey =
  //     GlobalKey<ControlButtonsState>();
  GlobalKey<ControlButtonsOldState>? replyVoiceControlBtnKey;
  // GlobalKey<ControlButtonsState> replyVoiceControlBtnKey =
  //     GlobalKey<ControlButtonsState>();
  // GlobalKey<ControlButtonsState> descriptionVoiceControlBtnKey =
  //     GlobalKey<ControlButtonsState>();
  GlobalKey<ControlButtonsOldState>? descriptionVoiceControlBtnKey;
  GlobalKey<ControlButtonsOldState>? questionVoiceControlBtnKey;
  qu.QuillController questionController = qu.QuillController.basic();
  qu.QuillController replyController = qu.QuillController.basic();
  qu.QuillController descController = qu.QuillController.basic();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  GlobalKey<StopWatchTimerPageState> timerKey = GlobalKey();
  QuestionReviewSpeedController question_review_controler =
      Get.find<QuestionReviewSpeedController>();
  ReplyReviewSpeedController reply_review_controler =
      Get.find<ReplyReviewSpeedController>();
  DescriptionReviewSpeedController descriptions_review_controler =
      Get.find<DescriptionReviewSpeedController>();
  CardsController _cardsController = Get.find<CardsController>();
  final themeController = Get.find<ThemeContoller>();
  TextEditingController voiceReplyController = TextEditingController();
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  TextEditingController txtReply = TextEditingController();
  GlobalKey<VoiceRecordState> voiceRecordKey = GlobalKey<VoiceRecordState>();
  TextToSpeech tts = TextToSpeech();
  bool _isKeyboardVisible = false;
  bool? isFront = true;
  bool enableEdit = true;
  double? secondDifficult, secondDifficultForSaveInCardHistory;
  int? difficultLevel;
  int currentIndex = 0;
  int _seconds = 0;
  List<Box>? boxes;
  bool autoPlayReview = false;
  bool autoRecord = false;
  bool quesShowImage = false;
  bool ansShowImage = false;
  final autoRecordStream = BehaviorSubject.seeded(false);
  final autoplayStream = BehaviorSubject.seeded(false);
  final quesShowImageStream = BehaviorSubject.seeded(false);
  final ansShowImageStream = BehaviorSubject.seeded(false);

  @override
  void dispose() {
    autoRecordStream.close();
    autoplayStream.close();
    quesShowImageStream.close();
    ansShowImageStream.close();
    _cardsController.clearTextWidget();
    super.dispose();
  }

  @override
  void initState() {
    autoplayStream.add(widget.autoPlay);
    autoRecordStream.add(widget.autoRecord);
    quesShowImageStream.add(widget.quesShowImage);
    ansShowImageStream.add(widget.ansShowImage);
    // autoPlayReview = widget.autoPlay;
    // autoRecord = widget.autoRecord;
    // quesShowImage = false;
    // ansShowImage = false;
    fetchBoxes();
    editTextsPrepare();
    Future.delayed(
        Duration(
          milliseconds: 1,
        ), () {
      timerKey.currentState!.startTimer();
    });

    super.initState();
  }

  void editTextsPrepare() {
    //*******question */
    if (boxes![currentIndex].card!.question != null) {
      print(boxes![currentIndex].card!.question);
      qu.Document doc = qu.Document()
        ..insert(0, boxes![currentIndex].card!.question);

      try {
        questionController = qu.QuillController(
            document: qu.Document.fromJson(
                jsonDecode(boxes![currentIndex].card!.question!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        questionController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
    //*******reply */
    if (boxes![currentIndex].card!.reply != null) {
      qu.Document doc = qu.Document()
        ..insert(0, boxes![currentIndex].card!.reply);

      try {
        replyController = qu.QuillController(
            document: qu.Document.fromJson(
                jsonDecode(boxes![currentIndex].card!.reply!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        replyController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
//*********description */
    if (boxes![currentIndex].card!.description != null) {
      qu.Document doc = qu.Document()
        ..insert(0, boxes![currentIndex].card!.description);

      try {
        descController = qu.QuillController(
            document: qu.Document.fromJson(
                jsonDecode(boxes![currentIndex].card!.description!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        descController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
  }

  void calcDifficult(int seconds) {
    _seconds = seconds;
    if ((boxes?.length ?? 0) > 0) {
      secondDifficult = (boxes?[currentIndex].subGroup?.ratio ?? 1.2) *
          (boxes?[currentIndex].card!.reply?.length ?? 20);
      print(secondDifficult);
    }
  }

  void fetchBoxes() {
    voiceRecordKey.currentState?.timer?.cancel();
    replyVoiceControlBtnKey = GlobalKey<ControlButtonsOldState>();
    descriptionVoiceControlBtnKey = GlobalKey<ControlButtonsOldState>();
    questionVoiceControlBtnKey = GlobalKey<ControlButtonsOldState>();
    difficultLevel = null;
    voiceReplyController = TextEditingController();
    if (boxes == null || boxes!.length == 0) {
      if (widget.subGroupId != null) {
        boxes = _cardsController.boxes
            .where((element) => element.subGroup!.id == widget.subGroupId!)
            .orderBy((element) => element.startDate)
            .toList();
        print(boxes![currentIndex].card?.question);
        print(boxes![currentIndex].card?.question);
      } else {
        boxes = _cardsController.boxes
            .orderBy((element) => element.startDate)
            .toList();
      }
    } else {
      boxes!.removeAt(0);
    }

    setState(() {});
//در صورتی که در جعبه کارتی وجود داشت و کارت گزینه پلی اتومات داشت دستورات اجرا می شوند
    if (((boxes?.length ?? 0) > 0) &&
        autoplayStream.value == true &&
        boxes![currentIndex].card!.questionVoicePath!.isNotEmpty) {
      Future.delayed(Duration(seconds: 1), () {
        questionVoiceControlBtnKey!.currentState!.player.play();
      });
    }
    editTextsPrepare();
    String answer = replyController.document.toPlainText().trim().toLowerCase();
    _cardsController.check(strAnswer: answer, check: false);
    //****************** */
  }

  @override
  Widget build(BuildContext context) {
    // String text = replyController.document.toPlainText();
    // print(text);

    // _cardsController.check(input: txtReply.text, strAnswer: text);
    // replyVoiceControlBtnKey = GlobalKey<ControlButtonsState>();
    // descriptionVoiceControlBtnKey = GlobalKey<ControlButtonsState>();
    // questionVoiceControlBtnKey = GlobalKey<ControlButtonsState>();
    _isKeyboardVisible = MediaQuery.of(context).viewInsets.vertical > 0;
    if (boxes == null || boxes!.length == 0) {
      return Scaffold(
          body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Center(child: Text('card_end_message'.tr)),
            ),
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('back'.tr))
          ],
        ),
      ));
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            app_Bar(title_text: "Card Review"),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: "Settings",
                            content: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: SettingItem(
                                      'Auto Play',
                                      autoPlayReview,
                                      autoplayStream,
                                      (value) {
                                        widget.autoPlay = value;
                                        autoPlayReview = value;
                                        SharedPreferences.getInstance().then(
                                          (prefs) {
                                            prefs.setBool(
                                                Preference.autoPlayReview,
                                                value);
                                            // });
                                            if (((boxes?.length ?? 0) > 0) &&
                                                autoPlayReview == true &&
                                                boxes![currentIndex]
                                                    .card!
                                                    .questionVoicePath!
                                                    .isNotEmpty &&
                                                isFront == true) {
                                              Future.delayed(
                                                  Duration(seconds: 1), () {
                                                questionVoiceControlBtnKey!
                                                    .currentState!.player
                                                    .play();
                                              });
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: SettingItem(
                                      'Auto Record',
                                      autoRecord,
                                      autoRecordStream,
                                      (value) {
                                        autoRecord = value;
                                        SharedPreferences.getInstance()
                                            .then((prefs) {
                                          prefs.setBool(
                                              Preference.autoRecord, value);
                                          // });
                                        });
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: SettingItem(
                                      'Show Image (Question)',
                                      quesShowImageStream.value,
                                      quesShowImageStream,
                                      (value) {
                                        // autoRecord = value;
                                        SharedPreferences.getInstance()
                                            .then((prefs) {
                                          prefs.setBool(
                                              Preference.quesShowImage, value);
                                          // });
                                        });
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: SettingItem(
                                      'Show Image (Answer)',
                                      ansShowImageStream.value,
                                      ansShowImageStream,
                                      (value) {
                                        // autoRecord = value;
                                        SharedPreferences.getInstance()
                                            .then((prefs) {
                                          prefs.setBool(
                                              Preference.ansShowImage, value);
                                          // });
                                        });
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Show Spell Check',
                                      ),
                                      Obx(() {
                                        return Container(
                                          child: Transform.scale(
                                            scale: 0.6,
                                            child: CupertinoSwitch(
                                              value: _cardsController
                                                  .isSpellCheck.value,
                                              onChanged: (value) {
                                                _cardsController
                                                    .isSpellCheck(value);
                                                SharedPreferences.getInstance()
                                                    .then((prefs) {
                                                  prefs.setBool(
                                                      Preference.hasSpellCheck,
                                                      value);
                                                  if (value == false) {
                                                    _cardsController
                                                        .allSpellCheck(value);
                                                    prefs.setBool(
                                                        Preference
                                                            .allSpellCheck,
                                                        value);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                  Obx(() {
                                    return _cardsController.isSpellCheck.value
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text(
                                                  'Spell Check For All',
                                                ),
                                                Obx(() {
                                                  return Container(
                                                    child: Transform.scale(
                                                      scale: 0.6,
                                                      child: CupertinoSwitch(
                                                        value: _cardsController
                                                            .allSpellCheck
                                                            .value,
                                                        onChanged: (value) {
                                                          //setState(() {
                                                          _cardsController
                                                              .allSpellCheck(
                                                                  value);
                                                          // autoPlay = value;
                                                          SharedPreferences
                                                                  .getInstance()
                                                              .then((prefs) {
                                                            prefs.setBool(
                                                                Preference
                                                                    .allSpellCheck,
                                                                value);
                                                            // });
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                })
                                              ])
                                        : Container();
                                  }),
                                ],
                              ),
                            ));
                      },
                      icon: (Image.asset(
                        "assets/images/candle.png",
                      ))),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: StopWatchTimerPage(
                        key: timerKey, timerListenerFunc: calcDifficult),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _renderBg(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: _renderContent(context),
                      ),
                      Expanded(
                        flex: 2,
                        child: bottomButtons(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons() {
    return Column(
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: difficultLevel == 1 ? Colors.redAccent : null,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Color(0xff27187E))),
                  child: TextButton(
                    style: ButtonStyle(),
                    onPressed: () async {
                      int? historyId = await saveHistory(1);
                      if (boxes![currentIndex].card!.boxNumber == 0) {
                        zeroBox(1); //از خانه صفر فقط به خانه کی می توان رفت
                      } else {
                        await dontAskAgain();
                      }

                      //       final history =await  Tablehistory().select().id.equals(historyId).toSingle();
                      //   history!.nextBoxNumber = boxes![currentIndex].card!.boxNumber!;
                      //  await history.save();
                      emptyBoxCheck();

                      timerKey.currentState!.stopTimer(resets: true);
                      //  timerKey.currentState!.reset();
                      timerKey.currentState!.startTimer();
                    },
                    child: Center(
                      child: Text(
                        'dont_ask'.tr,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Poppins",
                            color: Color(0xff27187E)),
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: difficultLevel == 2 ? Colors.redAccent : null,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Color(0xff27187E))),
                  child: TextButton(
                    onPressed: () async {
                      await saveHistory(2);
                      if (boxes![currentIndex].card!.boxNumber == 0) {
                        zeroBox(2);
                      } else {
                        await simpleLevel(2);
                      }

                      emptyBoxCheck();
                      timerKey.currentState!.stopTimer(resets: true);
                      // timerKey.currentState!.reset();
                      timerKey.currentState!.startTimer();
                    },
                    child: Center(
                      child: Text(
                        'very_easy'.tr,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Poppins",
                            color: Color(0xff27187E)),
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: difficultLevel == 3 ? Colors.redAccent : null,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Color(0xff27187E))),
                  child: TextButton(
                    onPressed: () async {
                      await saveHistory(3);
                      if (boxes![currentIndex].card!.boxNumber == 0) {
                        zeroBox(1);
                      } else {
                        await simpleLevel(1);
                      }

                      emptyBoxCheck();
                      timerKey.currentState!.stopTimer(resets: true);
                      //timerKey.currentState!.reset();
                      timerKey.currentState!.startTimer();
                    },
                    child: Center(
                      child: Text(
                        'easy'.tr,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Poppins",
                            color: Color(0xff27187E)),
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: difficultLevel == 4 ? Colors.redAccent : null,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Color(0xff27187E))),
                  child: TextButton(
                    onPressed: () async {
                      await saveHistory(4);
                      if (boxes![currentIndex].card!.boxNumber == 0) {
                        zeroBox(0);
                      } else {
                        await simpleLevel(0);
                      }

                      emptyBoxCheck();
                      timerKey.currentState!.stopTimer(resets: true);
                      // timerKey.currentState!.reset();
                      timerKey.currentState!.startTimer();
                    },
                    child: Center(
                      child: Text(
                        'medium'.tr,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Poppins",
                            color: Color(0xff27187E)),
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: difficultLevel == 5 ? Colors.redAccent : null,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Color(0xff27187E))),
                  child: TextButton(
                    onPressed: () async {
                      await saveHistory(5);
                      if (boxes![currentIndex].card!.boxNumber == 0) {
                        zeroBox(-1);
                      } else {
                        await simpleLevel(-1);
                      }

                      emptyBoxCheck();
                      timerKey.currentState!.stopTimer(resets: true);
                      // timerKey.currentState!.reset();
                      timerKey.currentState!.startTimer();
                    },
                    child: Center(
                      child: Text(
                        'hard'.tr,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Poppins",
                            color: Color(0xff27187E)),
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: difficultLevel == 6 ? Colors.redAccent : null,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Color(0xff27187E))),
                  child: TextButton(
                    onPressed: () async {
                      await saveHistory(6);
                      if (boxes![currentIndex].card!.boxNumber == 0) {
                        zeroBox(6);
                      } else {
                        await hardLevel();
                      }

                      emptyBoxCheck();
                      timerKey.currentState!.stopTimer(resets: true);
                      //timerKey.currentState!.reset();
                      timerKey.currentState!.startTimer();
                      String answer = replyController.document
                          .toPlainText()
                          .trim()
                          .toLowerCase();
                      _cardsController.check(strAnswer: answer, check: false);
                    },
                    child: Center(
                      child: Text(
                        'dont_know'.tr,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Poppins",
                            color: Color(0xff27187E)),
                      ),
                    ),
                  )),
            ),
          ],
        ),
        SizedBox(height: 5),
        Center(
          child: Container(
            width: 300,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 2, color: Color(0xffF1F2F6))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {},
                    child:
                        Text(boxes != null ? boxes!.length.toString() : '0')),
                Container(
                  width: 2,
                  height: 25,
                  color: Color(0xffF1F2F6),
                ),
                InkWell(
                    onTap: () {
                      cardKey.currentState!.toggleCard();
                      voiceRecordKey.currentState?.stopRecord();
                      voiceRecordKey.currentState?.setStatusRecord(false);

                      isFront = false;
                      enableEdit = false;
                      timerKey.currentState!.stopTimer(resets: false);
                      if (_seconds <= secondDifficult! * 0.4) {
                        difficultLevel = 2;
                        setState(() {});
                        print('خیلی ساده');
                      } else if (_seconds > secondDifficult! * 0.4 &&
                          _seconds <= secondDifficult! * 0.7) {
                        difficultLevel = 3;
                        setState(() {});
                        difficultLevel = 3;
                        print('ساده');
                      } else if (_seconds > secondDifficult! * 0.7 &&
                          _seconds <= secondDifficult!) {
                        difficultLevel = 4;
                        setState(() {});
                        print('متوسط');
                      } else if (_seconds > secondDifficult! &&
                          _seconds <= secondDifficult! * 1.5) {
                        difficultLevel = 5;
                        setState(() {});
                        print('سخت');
                      } else if (_seconds > secondDifficult! * 1.5) {
                        difficultLevel = 6;
                        setState(() {});
                        print('بلد نیستم');
                      }
                      //شرط های لازم برای خوانش اتوماتیک پاسخ
                      if (autoPlayReview == true &&
                          isFront == false &&
                          boxes![currentIndex]
                              .card!
                              .questionVoicePath!
                              .isNotEmpty) {
                        Future.delayed(Duration(seconds: 1), () {
                          replyVoiceControlBtnKey!.currentState!.player.play();
                        });
                      }
                    },
                    child: Image.asset("assets/images/rotate-left.png",
                        width: 50, height: 50)),
                Container(
                  width: 2,
                  height: 25,
                  color: Color(0xffF1F2F6),
                ),
                InkWell(
                    onTap: () {
                      Get.to(
                          HistoryCardReviewComplete(
                              cardId: boxes![currentIndex].card!.id!),
                          fullscreenDialog: true,
                          transition: Transition.zoom,
                          duration: Duration(seconds: 1));
                    },
                    child: Image.asset("assets/images/refresh.png",
                        width: 30, height: 31)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget bottomButtons1() {
    return Column(
      children: [
        Wrap(spacing: 8,
            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        difficultLevel == 1
                            ? Colors.redAccent
                            : themeController.themeData.value.primaryColor),
                  ),
                  onPressed: () async {
                    int? historyId = await saveHistory(1);
                    if (boxes![currentIndex].card!.boxNumber == 0) {
                      zeroBox(1); //از خانه صفر فقط به خانه کی می توان رفت
                    } else {
                      await dontAskAgain();
                    }

                    //       final history =await  Tablehistory().select().id.equals(historyId).toSingle();
                    //   history!.nextBoxNumber = boxes![currentIndex].card!.boxNumber!;
                    //  await history.save();
                    emptyBoxCheck();

                    timerKey.currentState!.stopTimer(resets: true);
                    //  timerKey.currentState!.reset();
                    timerKey.currentState!.startTimer();
                  },
                  child: Text('dont_ask'.tr)),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        difficultLevel == 2
                            ? Colors.redAccent
                            : themeController.themeData.value.primaryColor),
                  ),
                  onPressed: () async {
                    await saveHistory(2);
                    if (boxes![currentIndex].card!.boxNumber == 0) {
                      zeroBox(2);
                    } else {
                      await simpleLevel(2);
                    }

                    emptyBoxCheck();
                    timerKey.currentState!.stopTimer(resets: true);
                    // timerKey.currentState!.reset();
                    timerKey.currentState!.startTimer();
                  },
                  child: Text('very_easy'.tr)),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        difficultLevel == 3
                            ? Colors.redAccent
                            : themeController.themeData.value.primaryColor),
                  ),
                  onPressed: () async {
                    await saveHistory(3);
                    if (boxes![currentIndex].card!.boxNumber == 0) {
                      zeroBox(1);
                    } else {
                      await simpleLevel(1);
                    }

                    emptyBoxCheck();
                    timerKey.currentState!.stopTimer(resets: true);
                    //timerKey.currentState!.reset();
                    timerKey.currentState!.startTimer();
                  },
                  child: Text('easy'.tr)),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        difficultLevel == 4
                            ? Colors.redAccent
                            : themeController.themeData.value.primaryColor),
                  ),
                  onPressed: () async {
                    await saveHistory(4);
                    if (boxes![currentIndex].card!.boxNumber == 0) {
                      zeroBox(0);
                    } else {
                      await simpleLevel(0);
                    }

                    emptyBoxCheck();
                    timerKey.currentState!.stopTimer(resets: true);
                    // timerKey.currentState!.reset();
                    timerKey.currentState!.startTimer();
                  },
                  child: Text('medium'.tr)),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        difficultLevel == 5
                            ? Colors.redAccent
                            : themeController.themeData.value.primaryColor),
                  ),
                  onPressed: () async {
                    await saveHistory(5);
                    if (boxes![currentIndex].card!.boxNumber == 0) {
                      zeroBox(-1);
                    } else {
                      await simpleLevel(-1);
                    }

                    emptyBoxCheck();
                    timerKey.currentState!.stopTimer(resets: true);
                    // timerKey.currentState!.reset();
                    timerKey.currentState!.startTimer();
                  },
                  child: Text('hard'.tr)),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        difficultLevel == 6
                            ? Colors.redAccent
                            : themeController.themeData.value.primaryColor),
                  ),
                  onPressed: () async {
                    await saveHistory(6);
                    if (boxes![currentIndex].card!.boxNumber == 0) {
                      zeroBox(6);
                    } else {
                      await hardLevel();
                    }

                    emptyBoxCheck();
                    timerKey.currentState!.stopTimer(resets: true);
                    //timerKey.currentState!.reset();
                    timerKey.currentState!.startTimer();
                    String answer = replyController.document
                        .toPlainText()
                        .trim()
                        .toLowerCase();
                    _cardsController.check(strAnswer: answer, check: false);
                  },
                  child: Text('dont_know'.tr)),
            ]),
      ],
    );
  }

  Future<int?> saveHistory(int? resultQuestion) async {
    // _cardsController.clearTextWidget();
    final history = Tablehistory()
      ..dateQuestion = DateTime.now()
      ..tblCardId = boxes?[currentIndex].card?.id
      ..replyVoicePath = voiceReplyController.text
      ..replyTimeInSecond = _seconds
      ..goodTimeInSecond = secondDifficult!.round()
      ..reply = txtReply.text
      ..beforeBoxNumber = boxes![currentIndex].card!.boxNumber
      ..nextBoxNumber = boxes![currentIndex].card!.boxNumber
      ..resultQuestion = resultQuestion;
    int? result = await history.save();
    return result;
  }

  // int getNextBoxNumber(int resultQuestion) {
  //   int result = 1;
  //   switch (resultQuestion) {
  //     case 1:
  //       result = boxes![currentIndex].subGroup!.boxCount!;
  //       break;
  //     case 2:
  //     result = boxes![currentIndex].card!.boxNumber! + 2;
  //      break;
  //      case 3:
  //       result = boxes![currentIndex].card!.boxNumber! + 1;
  //      break;
  //      case 4:
  //       result = boxes![currentIndex].card!.boxNumber! ;
  //      break;
  //      case 5:
  //       result = boxes![currentIndex].card!.boxNumber! - 1;
  //      break;
  //      case 6:
  //       result = 1;
  //      break;
  //   }
  // }

  Future hardLevel() async {
    boxes![currentIndex].card!.boxNumber = 1;
    var ratioAsMinute = (pow(2, (boxes![currentIndex].card!.boxNumber! - 1))) *
        boxes![currentIndex].subGroup!.countTime! *
        unittimeAsMinute();
    print('ratio----->$ratioAsMinute');
    print('dateBefor---->${boxes![currentIndex].card!.boxVisibleDate!}');
    var currentTime = DateTime.now()
        .add(Duration(minutes: int.parse(ratioAsMinute.toString())));
    print('date---->$currentTime');
    boxes![currentIndex].card!.boxVisibleDate = currentTime;
    int? cardId = await boxes![currentIndex].card!.save();
    // print(cardId);
    _cardsController.rebind();
    fetchBoxes();
  }

  Future zeroBox(int skip) async {
    boxes![currentIndex].card!.boxVisibleDate = DateTime.now();
    if (skip != 6) {
      var ratioAsMinute =
          (pow(2, (boxes![currentIndex].card!.boxNumber! - 1))) *
              boxes![currentIndex].subGroup!.countTime! *
              unittimeAsMinute();
      var currentTime = DateTime.now().add(Duration(
          seconds: int.parse((ratioAsMinute * 60).round().toString())));
      boxes![currentIndex].card!.boxVisibleDate = currentTime;
      boxes![currentIndex].card!.boxNumber = 1;
    }
    await boxes![currentIndex].card!.save();
    _cardsController.rebind();
    fetchBoxes();
  }

  Future simpleLevel(int skip) async {
    if (skip == 1 || skip == 2) {
      checkSkipBox();
    }

    if (boxes![currentIndex].card!.boxNumber! + skip >=
        boxes![currentIndex].subGroup!.boxCount!) {
      boxes![currentIndex].card!.boxNumber =
          boxes![currentIndex].subGroup!.boxCount;
      boxes![currentIndex].card!.examDone = true;
      await boxes![currentIndex].card!.save();
      _cardsController.rebind();
    } else {
      if (boxes![currentIndex].card!.boxNumber == 1 && skip == -1) {
        boxes![currentIndex].card!.boxNumber = 1;
      } else {
        boxes![currentIndex].card!.boxNumber =
            boxes![currentIndex].card!.boxNumber! + skip;
      }

      print('boxNumber------>${boxes![currentIndex].card!.boxNumber!}');
      // var ratioAsMinute = 2 ^
      //     (boxes![currentIndex].card!.boxNumber! - 1) *
      //         boxes![currentIndex].subGroup!.countTime! *
      //         unittimeAsMinute();

      var ratioAsMinute =
          (pow(2, (boxes![currentIndex].card!.boxNumber! - 1))) *
              boxes![currentIndex].subGroup!.countTime! *
              unittimeAsMinute();
      print('ratio----->$ratioAsMinute');
      print('dateBefor---->${boxes![currentIndex].card!.boxVisibleDate!}');
      // var currentTime = boxes![currentIndex]
      //     .card!
      //     .boxVisibleDate!
      //     .add(Duration(minutes: int.parse(ratioAsMinute.toString())));
      var currentTime = DateTime.now().add(Duration(
          seconds: int.parse((ratioAsMinute * 60).round().toString())));
      print('date---->$currentTime');
      boxes![currentIndex].card!.boxVisibleDate = currentTime;

      int? cardId = await boxes![currentIndex].card!.save();
      // print(cardId);
      _cardsController.rebind();
    }
    fetchBoxes();
  }

//اگر کاربر بعد از مدتی به برنامه سر زد
//و حالا کارتی را هنوز بلد بود خانه آن به اندازه
//غیبت او جلو می رود
  int checkSkipBox() {
    var temp = boxes![currentIndex].card!.boxNumber!;
    var time = boxes![currentIndex].card!.boxVisibleDate!;

    for (var i = boxes![currentIndex].card!.boxNumber!;
        i <= boxes![currentIndex].subGroup!.boxCount!;
        i++) {
      var ratioAsMinute = (pow((i - 1), 2)) *
          boxes![currentIndex].subGroup!.countTime! *
          unittimeAsMinute();
      time.add(Duration(minutes: int.parse(ratioAsMinute.toString())));
      if (DateTime.now().isBefore(time)) {
        temp = i;
      }
    }
    boxes![currentIndex].card!.boxNumber = temp;
    return temp;
  }

  void musicPlayCompleteCallBack() {
    if (voiceReplyController.text.isEmpty) {
      // cardIdRecordedVoiceAutoStarted.add(boxes![currentIndex].card!.id!);
      if (voiceRecordKey != null &&
          voiceRecordKey.currentState?.enableRecord == true &&
          autoRecord == true) {
        voiceRecordKey.currentState?.startRecord();
      }
    }
  }

  void automaticPlayDescription() {
    if (isFront == false && autoPlayReview == true) {
      Future.delayed(Duration(seconds: 1), () {
        if (descriptionVoiceControlBtnKey != null) {
          descriptionVoiceControlBtnKey?.currentState?.player.play();
        }
      });
    } else {
      // replyVoiceControlBtnKey!.currentState!.indexCallBackTriggers
      //     .remove(boxes![currentIndex].card!.id.toString() + 'reply');
    }
  }

  void emptyBoxCheck() {
    voiceRecordKey.currentState?.stopRecord();
    voiceRecordKey.currentState?.setStatusRecord(false);
    enableEdit = true;
    if (boxes!.length == 0) {
      Navigator.pop(context);
      Get.snackbar('warning'.tr, 'card_end_message'.tr);
    } else {
      //از آنجایی که با هر بار پاسخ این تابع صدا زده می شود
      //چک می شود که قبل از واکشی کارت بعدی جلوی کارت نمایش دادده شود
      if (isFront == false) {
        cardKey.currentState!.toggleCard();
        isFront = true;
      }
      txtReply = TextEditingController();
      setState(() {});
    }
  }

  int unittimeAsMinute() {
    var unitTimeAsMinute = 0;
    switch (boxes![currentIndex].subGroup!.unitTime!) {
      case 1:
        unitTimeAsMinute = 1;
        break;
      case 2:
        unitTimeAsMinute = 60;
        break;
      case 3:
        unitTimeAsMinute = 1440;
        break;
    }
    return unitTimeAsMinute;
  }

  Future dontAskAgain() async {
    boxes![currentIndex].card!
      ..boxNumber = boxes![currentIndex].subGroup!.boxCount!
      ..examDone = true;
    int? cardId = await boxes![currentIndex].card!.save();
    _cardsController.rebind();
    fetchBoxes();
  }

  _renderBg() {
    return Container(
        // decoration: BoxDecoration(color: const Color(0xFFFFFFFF)),
        );
  }

  _renderContent(context) {
    var tt = qu.DefaultStyles.getInstance(context);
    var quilTheme = qu.DefaultStyles.getInstance(context).merge(
        qu.DefaultStyles(
            h1: qu.DefaultTextBlockStyle(themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing, tt.paragraph!.verticalSpacing, null),
            h2: qu.DefaultTextBlockStyle(themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing, tt.paragraph!.verticalSpacing, null),
            h3: qu.DefaultTextBlockStyle(themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing, tt.paragraph!.verticalSpacing, null),
            paragraph: qu.DefaultTextBlockStyle(themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing, tt.paragraph!.verticalSpacing, null),
            bold: const TextStyle(fontWeight: FontWeight.bold),
            italic: const TextStyle(fontStyle: FontStyle.italic),
            small: const TextStyle(fontSize: 12, color: Colors.black45),
            underline: const TextStyle(decoration: TextDecoration.underline),
            strikeThrough:
                const TextStyle(decoration: TextDecoration.lineThrough),
            inlineCode: qu.InlineCodeStyle(
              style: TextStyle(
                color: Colors.blue.shade900.withOpacity(0.9),
                // fontFamily: fontFamily,
                fontSize: 13,
              ),
            ),
            link: TextStyle(
              // color: themeData.colorScheme.secondary,
              decoration: TextDecoration.underline,
            ),
            placeHolder: qu.DefaultTextBlockStyle(
                themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing,
                tt.paragraph!.verticalSpacing,
                null),
            lists: qu.DefaultListBlockStyle(
                themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing,
                tt.paragraph!.verticalSpacing,
                null,
                null),
            quote: qu.DefaultTextBlockStyle(themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing, tt.paragraph!.verticalSpacing, null),
            code: qu.DefaultTextBlockStyle(themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing, tt.paragraph!.verticalSpacing, null),
            indent: qu.DefaultTextBlockStyle(themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing, tt.paragraph!.verticalSpacing, null),
            align: qu.DefaultTextBlockStyle(themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing, tt.paragraph!.verticalSpacing, null),
            leading: qu.DefaultTextBlockStyle(themeContoller.mainContentStyle,
                tt.paragraph!.lineSpacing, tt.paragraph!.verticalSpacing, null),
            sizeSmall: const TextStyle(fontSize: 10),
            sizeLarge: const TextStyle(fontSize: 18),
            sizeHuge: const TextStyle(fontSize: 22)));

    var align2 = Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
            onTap: () {
              if (autoPlayReview == true &&
                  isFront == false &&
                  boxes![currentIndex].card!.replyVoicePath!.isNotEmpty) {
                Future.delayed(Duration(seconds: 1), () {
                  replyVoiceControlBtnKey?.currentState?.player.pause();
                  descriptionVoiceControlBtnKey?.currentState?.player.pause();
                });
              }

              cardKey.currentState!.toggleCard();
              isFront = true;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    Get.to(
                        HistoryCardReviewComplete(
                            cardId: boxes![currentIndex].card!.id!),
                        fullscreenDialog: true,
                        transition: Transition.zoom,
                        duration: Duration(seconds: 1));
                  },
                  child: Container(
                    margin: EdgeInsetsDirectional.only(end: 10),
                    padding: EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      // backgroundColor: Colors.white,
                      child: Icon(Icons.history, size: 20),
                      radius: 18,
                    ),
                  ),
                ),
                //  Container(width: 10,),
                Container(
                  margin: EdgeInsetsDirectional.only(bottom: 10, end: 10),
                  child: CircleAvatar(
                      radius: 18,
                      child: Icon(Icons.rotate_90_degrees_ccw_rounded)),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: CircleAvatar(
                      radius: 18,
                      child:
                          Text(boxes != null ? boxes!.length.toString() : '0')),
                ),
              ],
            )));
    var imageShow = StreamBuilder<bool>(
      stream: quesShowImageStream.stream,
      initialData: quesShowImageStream.value,
      builder: (context, snapshot) {
        if ((snapshot.hasData &&
            snapshot.data! &&
            (boxes![currentIndex].card!.imagePath != null &&
                boxes![currentIndex].card!.imagePath!.isNotEmpty))) {
          return Image.file(File(boxes![currentIndex].card!.imagePath!));
        } else {
          return Container();
        }
      },
    );
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 0.0),
      // color: CustomColor.grey,
      child: FlipCard(
        key: cardKey,
        flipOnTouch: false,
        direction: FlipDirection.HORIZONTAL,
        speed: 1000,
        onFlipDone: (status) {
          print(status);
        },
        front: frontCard2(align2, quilTheme),
        back: backCard2(quilTheme, align2),
      ), /////////////////
    );
  }

  Widget backCard2(qu.DefaultStyles quilTheme, Align align2) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Answer",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff353535))),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 100, spreadRadius: 1)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            TwoStateWidget(
                              playingImage: "assets/images/volume-high.png",
                              stoppedImage: "assets/images/volume-slash.png",
                              onEnable: (bool value) async {
                                String language = getLangForTTS(
                                    boxes![currentIndex]
                                            .subGroup!
                                            .languageItemTwo ??
                                        0);
                                tts.setLanguage(language);
                                String text =
                                    replyController.document.toPlainText();
                                tts.speak(text);
                              },
                              onDisable: (bool value) async {
                                await tts.stop();
                              },
                            ),
                            IconButton(
                                onPressed: () {
                                  String text =
                                      replyController.document.toPlainText();
                                  translationDialog(text);
                                },
                                icon: Icon(Icons.translate_rounded)),
                          ],
                        ),
                        Expanded(
                          child: StreamBuilder(
                            stream: replyController.obs.stream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return Container(
                                child: qu.QuillEditor(
                                  controller: replyController,
                                  readOnly: true, // true for view only mode
                                  autoFocus: true,
                                  scrollController: ScrollController(),
                                  expands: false,
                                  focusNode: FocusNode(),
                                  scrollable: false,
                                  padding: EdgeInsets.only(left: 0, right: 0),
                                  customStyles: quilTheme,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    (boxes![currentIndex].card!.replyVoicePath == null ||
                            boxes![currentIndex].card!.replyVoicePath!.isEmpty)
                        ? Container()
                        : ControlButtonsOld(
                            indexCallBackTrigger:
                                boxes![currentIndex].card!.id.toString() +
                                    'reply',
                            musicEndCallBack: automaticPlayDescription,
                            speedController: reply_review_controler,
                            key: replyVoiceControlBtnKey,
                            path: boxes![currentIndex].card!.replyVoicePath),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Text("Description",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff353535))),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 100, spreadRadius: 1)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            TwoStateWidget(
                              playingImage: "assets/images/volume-high.png",
                              stoppedImage: "assets/images/volume-slash.png",
                              onEnable: (bool value) async {
                                String language = getLangForTTS(
                                    boxes![currentIndex]
                                            .subGroup!
                                            .languageItemThree ??
                                        0);
                                tts.setLanguage(language);
                                String text =
                                    descController.document.toPlainText();
                                tts.speak(text);
                              },
                              onDisable: (bool value) async {
                                await tts.stop();
                              },
                            ),
                            IconButton(
                                onPressed: () {
                                  String text =
                                      descController.document.toPlainText();
                                  translationDialog(text);
                                },
                                icon: Icon(Icons.translate_rounded))
                          ],
                        ),
                        Expanded(
                          child: StreamBuilder(
                            stream: descController.obs.stream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return Text(descController.document.toPlainText(),
                                  // questionController.toString,
                                  style: themeContoller.mainContentStyle);
                              return Container(
                                child: qu.QuillEditor.basic(
                                  controller: descController,
                                  readOnly: true, // true for view only mode
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    (boxes![currentIndex].card!.descriptionVoicePath == null ||
                            boxes![currentIndex]
                                .card!
                                .descriptionVoicePath!
                                .isEmpty)
                        ? Container()
                        : ControlButtonsOld(
                            indexCallBackTrigger:
                                boxes![currentIndex].card!.id.toString() +
                                    'description',
                            musicEndCallBack: musicPlayCompleteCallBack,
                            speedController: descriptions_review_controler,
                            key: descriptionVoiceControlBtnKey,
                            path: boxes![currentIndex]
                                .card!
                                .descriptionVoicePath),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            StreamBuilder<bool>(
              stream: ansShowImageStream.stream,
              initialData: ansShowImageStream.value,
              builder: (context, snapshot) {
                if ((snapshot.hasData &&
                    snapshot.data! &&
                    (boxes![currentIndex].card!.imagePath != null &&
                        boxes![currentIndex].card!.imagePath!.isNotEmpty))) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text("Image",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff353535))),
                      SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.file(
                            File(boxes![currentIndex].card!.imagePath!),
                            fit: BoxFit.cover),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Card backCard(qu.DefaultStyles quilTheme, Align align2) {
  //   return Card(
  //     elevation: 10,
  //     child: Builder(builder: (context) {
  //       switch (widget.caseType) {
  //         case 3:
  //           // Picture
  //           return Stack(
  //             children: [
  //               Container(
  //                   padding: EdgeInsets.all(8),
  //                   child: ListView(
  //                     children: [
  //                       StreamBuilder<bool>(
  //                         stream: ansShowImageStream.stream,
  //                         initialData: ansShowImageStream.value,
  //                         builder: (context, snapshot) {
  //                           if ((snapshot.hasData &&
  //                               snapshot.data! &&
  //                               (boxes![currentIndex].card!.imagePath != null &&
  //                                   boxes![currentIndex]
  //                                       .card!
  //                                       .imagePath!
  //                                       .isNotEmpty))) {
  //                             return Image.file(
  //                                 File(boxes![currentIndex].card!.imagePath!));
  //                           } else {
  //                             return Container();
  //                           }
  //                         },
  //                       ),
  //                       ListTile(
  //                         //  title: Text(boxes![currentIndex].card!.reply ?? ''),
  //                         title: StreamBuilder(
  //                           stream: replyController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Container(
  //                               child: qu.QuillEditor(
  //                                 controller: replyController,
  //                                 readOnly: true, // true for view only mode
  //                                 autoFocus: true,
  //                                 scrollController: ScrollController(),
  //                                 expands: false,
  //                                 focusNode: FocusNode(),
  //                                 scrollable: false,
  //                                 padding: EdgeInsets.only(left: 0, right: 0),
  //                                 customStyles: quilTheme,
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemTwo ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   replyController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(CupertinoIcons.speaker_1_fill,
  //                                 color: themeContoller
  //                                     .themeData.value.primaryColor)),
  //                       ),
  //                       (boxes![currentIndex].card!.replyVoicePath == null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .replyVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString() +
  //                                       'reply',
  //                               musicEndCallBack: automaticPlayDescription,
  //                               speedController: reply_review_controler,
  //                               key: replyVoiceControlBtnKey,
  //                               path:
  //                                   boxes![currentIndex].card!.replyVoicePath),
  //                       ListTile(
  //                         title: StreamBuilder(
  //                           stream: descController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Container(
  //                               child: qu.QuillEditor.basic(
  //                                 controller: descController,
  //                                 readOnly: true, // true for view only mode
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemThree ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   descController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(CupertinoIcons.speaker_1_fill,
  //                                 color: themeContoller
  //                                     .themeData.value.primaryColor)),
  //                         // subtitle:
  //                         //     (boxes![currentIndex].card!.descriptionVoicePath ==
  //                         //                 null ||
  //                         //             boxes![currentIndex]
  //                         //                 .card!
  //                         //                 .descriptionVoicePath!
  //                         //                 .isEmpty)
  //                         //         ? Container()
  //                         //         : ControlButtons(
  //                         //             path: boxes![currentIndex]
  //                         //                 .card!
  //                         //                 .descriptionVoicePath),
  //                       ),
  //                       (boxes![currentIndex].card!.descriptionVoicePath ==
  //                                   null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .descriptionVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString() +
  //                                       'description',
  //                               musicEndCallBack: musicPlayCompleteCallBack,
  //                               speedController: descriptions_review_controler,
  //                               key: descriptionVoiceControlBtnKey,
  //                               path: boxes![currentIndex]
  //                                   .card!
  //                                   .descriptionVoicePath),
  //                       SizedBox(
  //                         height: 50,
  //                       )
  //                     ],
  //                   )),
  //               align2,
  //             ],
  //           );

  //         case 2:
  //           // Description
  //           return Stack(
  //             children: [
  //               Container(
  //                   padding: EdgeInsets.all(8),
  //                   child: ListView(
  //                     children: [
  //                       StreamBuilder<bool>(
  //                         stream: ansShowImageStream.stream,
  //                         initialData: ansShowImageStream.value,
  //                         builder: (context, snapshot) {
  //                           if ((snapshot.hasData &&
  //                               snapshot.data! &&
  //                               (boxes![currentIndex].card!.imagePath != null &&
  //                                   boxes![currentIndex]
  //                                       .card!
  //                                       .imagePath!
  //                                       .isNotEmpty))) {
  //                             return Image.file(
  //                                 File(boxes![currentIndex].card!.imagePath!));
  //                           } else {
  //                             return Container();
  //                           }
  //                         },
  //                       ),
  //                       ListTile(
  //                         // title: Text(boxes![currentIndex].card!.question ?? ''),
  //                         title: StreamBuilder(
  //                           stream: questionController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Container(
  //                               child: qu.QuillEditor(
  //                                 controller: questionController,
  //                                 readOnly: true, // true for view only mode
  //                                 autoFocus: true,
  //                                 scrollController: ScrollController(),
  //                                 expands: false,
  //                                 focusNode: FocusNode(),
  //                                 scrollable: false,
  //                                 padding: EdgeInsets.only(left: 0, right: 0),
  //                                 customStyles: quilTheme,
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemOne ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   questionController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(
  //                               CupertinoIcons.speaker_1_fill,
  //                               color:
  //                                   themeContoller.themeData.value.primaryColor,
  //                             )),
  //                       ),
  //                       (boxes![currentIndex].card!.questionVoicePath == null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .questionVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString(),
  //                               musicEndCallBack: musicPlayCompleteCallBack,
  //                               speedController: question_review_controler,
  //                               key: questionVoiceControlBtnKey,
  //                               path: boxes![currentIndex]
  //                                   .card!
  //                                   .questionVoicePath),
  //                       ListTile(
  //                         //  title: Text(boxes![currentIndex].card!.reply ?? ''),
  //                         title: StreamBuilder(
  //                           stream: replyController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Container(
  //                               child: qu.QuillEditor(
  //                                 controller: replyController,
  //                                 readOnly: true, // true for view only mode
  //                                 autoFocus: true,
  //                                 scrollController: ScrollController(),
  //                                 expands: false,
  //                                 focusNode: FocusNode(),
  //                                 scrollable: false,
  //                                 padding: EdgeInsets.only(left: 0, right: 0),
  //                                 customStyles: quilTheme,
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemTwo ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   replyController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(CupertinoIcons.speaker_1_fill,
  //                                 color: themeContoller
  //                                     .themeData.value.primaryColor)),
  //                       ),
  //                       (boxes![currentIndex].card!.replyVoicePath == null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .replyVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString() +
  //                                       'reply',
  //                               musicEndCallBack: automaticPlayDescription,
  //                               speedController: reply_review_controler,
  //                               key: replyVoiceControlBtnKey,
  //                               path:
  //                                   boxes![currentIndex].card!.replyVoicePath),
  //                       SizedBox(
  //                         height: 50,
  //                       )
  //                     ],
  //                   )),
  //               align2,
  //             ],
  //           );

  //         case 1:
  //           // Pasokh
  //           return Stack(
  //             children: [
  //               Container(
  //                   padding: EdgeInsets.all(8),
  //                   child: ListView(
  //                     children: [
  //                       StreamBuilder<bool>(
  //                         stream: ansShowImageStream.stream,
  //                         initialData: ansShowImageStream.value,
  //                         builder: (context, snapshot) {
  //                           if ((snapshot.hasData &&
  //                               snapshot.data! &&
  //                               (boxes![currentIndex].card!.imagePath != null &&
  //                                   boxes![currentIndex]
  //                                       .card!
  //                                       .imagePath!
  //                                       .isNotEmpty))) {
  //                             return Image.file(
  //                                 File(boxes![currentIndex].card!.imagePath!));
  //                           } else {
  //                             return Container();
  //                           }
  //                         },
  //                       ),
  //                       ListTile(
  //                         // title: Text(boxes![currentIndex].card!.question ?? ''),
  //                         title: StreamBuilder(
  //                           stream: questionController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Container(
  //                               child: qu.QuillEditor(
  //                                 controller: questionController,
  //                                 readOnly: true, // true for view only mode
  //                                 autoFocus: true,
  //                                 scrollController: ScrollController(),
  //                                 expands: false,
  //                                 focusNode: FocusNode(),
  //                                 scrollable: false,
  //                                 padding: EdgeInsets.only(left: 0, right: 0),
  //                                 customStyles: quilTheme,
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemOne ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   questionController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(
  //                               CupertinoIcons.speaker_1_fill,
  //                               color:
  //                                   themeContoller.themeData.value.primaryColor,
  //                             )),
  //                       ),
  //                       (boxes![currentIndex].card!.questionVoicePath == null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .questionVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString(),
  //                               musicEndCallBack: musicPlayCompleteCallBack,
  //                               speedController: question_review_controler,
  //                               key: questionVoiceControlBtnKey,
  //                               path: boxes![currentIndex]
  //                                   .card!
  //                                   .questionVoicePath),
  //                       ListTile(
  //                         title: StreamBuilder(
  //                           stream: descController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Container(
  //                               child: qu.QuillEditor.basic(
  //                                 controller: descController,
  //                                 readOnly: true, // true for view only mode
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemThree ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   descController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(CupertinoIcons.speaker_1_fill,
  //                                 color: themeContoller
  //                                     .themeData.value.primaryColor)),
  //                         // subtitle:
  //                         //     (boxes![currentIndex].card!.descriptionVoicePath ==
  //                         //                 null ||
  //                         //             boxes![currentIndex]
  //                         //                 .card!
  //                         //                 .descriptionVoicePath!
  //                         //                 .isEmpty)
  //                         //         ? Container()
  //                         //         : ControlButtons(
  //                         //             path: boxes![currentIndex]
  //                         //                 .card!
  //                         //                 .descriptionVoicePath),
  //                       ),
  //                       (boxes![currentIndex].card!.descriptionVoicePath ==
  //                                   null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .descriptionVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString() +
  //                                       'description',
  //                               musicEndCallBack: musicPlayCompleteCallBack,
  //                               speedController: descriptions_review_controler,
  //                               key: descriptionVoiceControlBtnKey,
  //                               path: boxes![currentIndex]
  //                                   .card!
  //                                   .descriptionVoicePath),
  //                       SizedBox(
  //                         height: 50,
  //                       )
  //                     ],
  //                   )),
  //               align2,
  //             ],
  //           );

  //         // Porsesh
  //         case 0:
  //         default:
  //           return Stack(
  //             children: [
  //               Container(
  //                   padding: EdgeInsets.all(8),
  //                   child: ListView(
  //                     children: [
  //                       StreamBuilder<bool>(
  //                         stream: ansShowImageStream.stream,
  //                         initialData: ansShowImageStream.value,
  //                         builder: (context, snapshot) {
  //                           if ((snapshot.hasData &&
  //                               snapshot.data! &&
  //                               (boxes![currentIndex].card!.imagePath != null &&
  //                                   boxes![currentIndex]
  //                                       .card!
  //                                       .imagePath!
  //                                       .isNotEmpty))) {
  //                             return Image.file(
  //                                 File(boxes![currentIndex].card!.imagePath!));
  //                           } else {
  //                             return Container();
  //                           }
  //                         },
  //                       ),
  //                       ListTile(
  //                         //  title: Text(boxes![currentIndex].card!.reply ?? ''),
  //                         title: StreamBuilder(
  //                           stream: replyController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Container(
  //                               child: qu.QuillEditor(
  //                                 controller: replyController,
  //                                 readOnly: true, // true for view only mode
  //                                 autoFocus: true,
  //                                 scrollController: ScrollController(),
  //                                 expands: false,
  //                                 focusNode: FocusNode(),
  //                                 scrollable: false,
  //                                 padding: EdgeInsets.only(left: 0, right: 0),
  //                                 customStyles: quilTheme,
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemTwo ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   replyController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(CupertinoIcons.speaker_1_fill,
  //                                 color: themeContoller
  //                                     .themeData.value.primaryColor)),
  //                       ),
  //                       (boxes![currentIndex].card!.replyVoicePath == null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .replyVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString() +
  //                                       'reply',
  //                               musicEndCallBack: automaticPlayDescription,
  //                               speedController: reply_review_controler,
  //                               key: replyVoiceControlBtnKey,
  //                               path:
  //                                   boxes![currentIndex].card!.replyVoicePath),
  //                       ListTile(
  //                         title: StreamBuilder(
  //                           stream: descController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Text(descController.document.toPlainText(),
  //                                 // questionController.toString,
  //                                 style: themeContoller.mainContentStyle);
  //                             return Container(
  //                               child: qu.QuillEditor.basic(
  //                                 controller: descController,
  //                                 readOnly: true, // true for view only mode
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemThree ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   descController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(CupertinoIcons.speaker_1_fill,
  //                                 color: themeContoller
  //                                     .themeData.value.primaryColor)),
  //                         // subtitle:
  //                         //     (boxes![currentIndex].card!.descriptionVoicePath ==
  //                         //                 null ||
  //                         //             boxes![currentIndex]
  //                         //                 .card!
  //                         //                 .descriptionVoicePath!
  //                         //                 .isEmpty)
  //                         //         ? Container()
  //                         //         : ControlButtons(
  //                         //             path: boxes![currentIndex]
  //                         //                 .card!
  //                         //                 .descriptionVoicePath),
  //                       ),
  //                       (boxes![currentIndex].card!.descriptionVoicePath ==
  //                                   null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .descriptionVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString() +
  //                                       'description',
  //                               musicEndCallBack: musicPlayCompleteCallBack,
  //                               speedController: descriptions_review_controler,
  //                               key: descriptionVoiceControlBtnKey,
  //                               path: boxes![currentIndex]
  //                                   .card!
  //                                   .descriptionVoicePath),
  //                       SizedBox(
  //                         height: 50,
  //                       )
  //                     ],
  //                   )),
  //               align2,
  //             ],
  //           );
  //       }
  //     }),
  //   );
  // }

  Widget frontCard2(Align align2, qu.DefaultStyles quilTheme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Question",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff353535))),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 100, spreadRadius: 1)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          TwoStateWidget(
                            playingImage: "assets/images/volume-high.png",
                            stoppedImage: "assets/images/volume-slash.png",
                            onEnable: (bool value) async {
                              String language = getLangForTTS(
                                  boxes![currentIndex]
                                          .subGroup!
                                          .languageItemOne ??
                                      0);
                              tts.setLanguage(language);
                              String text =
                                  questionController.document.toPlainText();
                              tts.speak(text);
                            },
                            onDisable: (bool value) async {
                              await tts.stop();
                            },
                          ),
                          IconButton(
                              onPressed: () {
                                String text =
                                    questionController.document.toPlainText();
                                translationDialog(text);
                              },
                              icon: Icon(Icons.translate_rounded))
                        ],
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: questionController.obs.stream,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            // return Text(descController.document.toPlainText(),
                            //     // questionController.toString,
                            //     style: themeContoller.mainContentStyle);
                            return Container(
                              child: qu.QuillEditor(
                                controller: questionController,
                                readOnly: true, // true for view only mode
                                autoFocus: true,
                                scrollController: ScrollController(),
                                expands: false,
                                focusNode: FocusNode(),
                                scrollable: false,
                                padding: EdgeInsets.only(left: 0, right: 0),
                                customStyles: quilTheme,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  (boxes![currentIndex].card!.questionVoicePath == null ||
                          boxes![currentIndex].card!.questionVoicePath!.isEmpty)
                      ? Container()
                      : ControlButtonsOld(
                          indexCallBackTrigger:
                              boxes![currentIndex].card!.id.toString(),
                          musicEndCallBack: musicPlayCompleteCallBack,
                          speedController: question_review_controler,
                          key: questionVoiceControlBtnKey,
                          path: boxes![currentIndex].card!.questionVoicePath),
                ],
              ),
            ),
          ),
          StreamBuilder<bool>(
            stream: quesShowImageStream.stream,
            initialData: quesShowImageStream.value,
            builder: (context, snapshot) {
              if ((snapshot.hasData &&
                  snapshot.data! &&
                  (boxes![currentIndex].card!.imagePath != null &&
                      boxes![currentIndex].card!.imagePath!.isNotEmpty))) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text("Image",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff353535))),
                    SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                          File(boxes![currentIndex].card!.imagePath!),
                          fit: BoxFit.cover),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
          SizedBox(height: 15),
          Text("Your Reply",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff353535))),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 100, spreadRadius: 1)
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: VoiceRecordViewPage(
                        key: voiceRecordKey,
                        disableSdCard: true,
                        voiceEditingController: voiceReplyController),
                  ),
                  // (_isKeyboardVisible == false)
                  //     ?
                  //     : Container(),
                  SizedBox(height: 10),
                  Obx(() {
                    return (boxes![currentIndex].card!.spellChecker == true ||
                            _cardsController.allSpellCheck.value)
                        ? Column(children: [
                            Divider(),
                            Card(
                              color: themeContoller.themeData.value.splashColor,
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: _cardsController.textWidget.value),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xffF1F2F6),
                                  borderRadius: BorderRadius.circular(15)),
                              margin: EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                cursorColor: Color(0xff8A8A8A),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Color(0xff8A8A8A)),
                                enabled: true,
                                controller: txtReply,
                                autocorrect: false,
                                enableSuggestions: false,
                                // keyboardType: TextInputType.emailAddress,
                                autofocus: false,
                                onChanged: (value) {
                                  String text = replyController.document
                                      .toPlainText()
                                      .toLowerCase();
                                  _cardsController.check(
                                      input: value, strAnswer: text);
                                },
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,
                                minLines: 1,
                                decoration: InputDecoration(
                                    hintText: "Enter Your Reply",
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    hintStyle: TextStyle(
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Color(0xff8A8A8A)),
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: 30.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      String text = replyController.document
                                          .toPlainText()
                                          .toLowerCase();
                                      _cardsController.check(
                                          input: txtReply.text,
                                          strAnswer: text,
                                          check: true);
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                side: BorderSide(
                                                  color: Colors.black,
                                                )))),
                                    child: Text(
                                      "Check",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xff27187E),
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 30.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      String text = replyController.document
                                          .toPlainText()
                                          .toLowerCase();
                                      _cardsController.check(
                                          input: txtReply.text,
                                          strAnswer: text,
                                          check: true,
                                          help: true);
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                side: BorderSide(
                                                  color: Colors.black,
                                                )))),
                                    child: Text(
                                      "Help",
                                      style: TextStyle(
                                        color: Color(0xff27187E),
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                    height: 30.0,
                                    child: GestureDetector(
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      side: BorderSide(
                                                        color: Colors.black,
                                                      )))),
                                          child: Text(
                                            "Hold to Show",
                                            style: TextStyle(
                                              color: Color(0xff27187E),
                                              fontSize: 12,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                        onTapDown: (_) {
                                          String text = replyController.document
                                              .toPlainText()
                                              .toLowerCase();
                                          _cardsController.check(
                                              input: txtReply.text,
                                              strAnswer: text,
                                              check: true,
                                              show: true);
                                        },
                                        onTapCancel: () {
                                          String text = replyController.document
                                              .toPlainText()
                                              .toLowerCase();
                                          _cardsController.check(
                                            input: txtReply.text,
                                            strAnswer: text,
                                          );
                                        })),
                              ],
                            )
                          ])
                        : Container();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card frontCard(Align align2, qu.DefaultStyles quilTheme) {
  //   return Card(
  //     elevation: 10,
  //     child: Builder(builder: (context) {
  //       print(widget.caseType);
  //       var descriptioin = [
  //         Container(
  //           padding: EdgeInsets.all(8),
  //           child: ListTile(
  //             title: StreamBuilder(
  //               stream: descController.obs.stream,
  //               builder: (BuildContext context, AsyncSnapshot snapshot) {
  //                 return Container(
  //                   child: qu.QuillEditor.basic(
  //                     controller: descController,
  //                     readOnly: true, // true for view only mode
  //                   ),
  //                 );
  //               },
  //             ),
  //             leading: InkWell(
  //                 onTap: () {
  //                   String language = getLangForTTS(
  //                       boxes![currentIndex].subGroup!.languageItemThree ?? 0);
  //                   tts.setLanguage(language);
  //                   String text = descController.document.toPlainText();
  //                   tts.speak(text);
  //                 },
  //                 child: Icon(CupertinoIcons.speaker_1_fill,
  //                     color: themeContoller.themeData.value.primaryColor)),
  //           ),
  //         ),
  //         (boxes![currentIndex].card!.descriptionVoicePath == null ||
  //                 boxes![currentIndex].card!.descriptionVoicePath!.isEmpty)
  //             ? Container()
  //             : ControlButtonsOld(
  //                 indexCallBackTrigger:
  //                     boxes![currentIndex].card!.id.toString() + 'description',
  //                 musicEndCallBack: musicPlayCompleteCallBack,
  //                 speedController: descriptions_review_controler,
  //                 key: descriptionVoiceControlBtnKey,
  //                 path: boxes![currentIndex].card!.descriptionVoicePath),
  //         SizedBox(
  //           height: 50,
  //         )
  //       ];
  //       switch (widget.caseType) {
  //         case 3:
  //           // Picture
  //           return Stack(
  //             children: [
  //               Center(
  //                 child: boxes![currentIndex].card!.imagePath! != null
  //                     ? Image.file(File(boxes![currentIndex].card!.imagePath!))
  //                     : Text("No Image"),
  //               ),
  //               align2
  //             ],
  //           );
  //         case 2:
  //           return Stack(
  //             children: [
  //               Container(
  //                   padding: EdgeInsets.all(8),
  //                   child: ListView(
  //                     children: [
  //                       StreamBuilder<bool>(
  //                         stream: quesShowImageStream.stream,
  //                         initialData: quesShowImageStream.value,
  //                         builder: (context, snapshot) {
  //                           if ((snapshot.hasData &&
  //                               snapshot.data! &&
  //                               (boxes![currentIndex].card!.imagePath != null &&
  //                                   boxes![currentIndex]
  //                                       .card!
  //                                       .imagePath!
  //                                       .isNotEmpty))) {
  //                             return Image.file(
  //                                 File(boxes![currentIndex].card!.imagePath!));
  //                           } else {
  //                             return Container();
  //                           }
  //                         },
  //                       ),
  //                       ListTile(
  //                         title: StreamBuilder(
  //                           stream: descController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Container(
  //                               child: qu.QuillEditor.basic(
  //                                 controller: descController,
  //                                 readOnly: true, // true for view only mode
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemThree ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   descController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(CupertinoIcons.speaker_1_fill,
  //                                 color: themeContoller
  //                                     .themeData.value.primaryColor)),
  //                         // subtitle:
  //                         //     (boxes![currentIndex].card!.descriptionVoicePath ==
  //                         //                 null ||
  //                         //             boxes![currentIndex]
  //                         //                 .card!
  //                         //                 .descriptionVoicePath!
  //                         //                 .isEmpty)
  //                         //         ? Container()
  //                         //         : ControlButtons(
  //                         //             path: boxes![currentIndex]
  //                         //                 .card!
  //                         //                 .descriptionVoicePath),
  //                       ),
  //                       (boxes![currentIndex].card!.descriptionVoicePath ==
  //                                   null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .descriptionVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString() +
  //                                       'description',
  //                               musicEndCallBack: musicPlayCompleteCallBack,
  //                               speedController: descriptions_review_controler,
  //                               key: descriptionVoiceControlBtnKey,
  //                               path: boxes![currentIndex]
  //                                   .card!
  //                                   .descriptionVoicePath),
  //                       SizedBox(
  //                         height: 50,
  //                       )
  //                     ],
  //                   )),
  //               align2,
  //             ],
  //           );
  //         // Description

  //         case 1:
  //           // Pasokh
  //           return Stack(
  //             children: [
  //               Container(
  //                   padding: EdgeInsets.all(8),
  //                   child: ListView(
  //                     children: [
  //                       StreamBuilder<bool>(
  //                         stream: quesShowImageStream.stream,
  //                         initialData: quesShowImageStream.value,
  //                         builder: (context, snapshot) {
  //                           if ((snapshot.hasData &&
  //                               snapshot.data! &&
  //                               (boxes![currentIndex].card!.imagePath != null &&
  //                                   boxes![currentIndex]
  //                                       .card!
  //                                       .imagePath!
  //                                       .isNotEmpty))) {
  //                             return Image.file(
  //                                 File(boxes![currentIndex].card!.imagePath!));
  //                           } else {
  //                             return Container();
  //                           }
  //                         },
  //                       ),
  //                       ListTile(
  //                         //  title: Text(boxes![currentIndex].card!.reply ?? ''),
  //                         title: StreamBuilder(
  //                           stream: replyController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Container(
  //                               child: qu.QuillEditor(
  //                                 controller: replyController,
  //                                 readOnly: true, // true for view only mode
  //                                 autoFocus: true,
  //                                 scrollController: ScrollController(),
  //                                 expands: false,
  //                                 focusNode: FocusNode(),
  //                                 scrollable: false,
  //                                 padding: EdgeInsets.only(left: 0, right: 0),
  //                                 customStyles: quilTheme,
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemTwo ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   replyController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(CupertinoIcons.speaker_1_fill,
  //                                 color: themeContoller
  //                                     .themeData.value.primaryColor)),
  //                       ),
  //                       (boxes![currentIndex].card!.replyVoicePath == null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .replyVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString() +
  //                                       'reply',
  //                               musicEndCallBack: automaticPlayDescription,
  //                               speedController: reply_review_controler,
  //                               key: replyVoiceControlBtnKey,
  //                               path:
  //                                   boxes![currentIndex].card!.replyVoicePath),
  //                       SizedBox(
  //                         height: 50,
  //                       )
  //                     ],
  //                   )),
  //               align2,
  //             ],
  //           );

  //         // Porsesh
  //         case 0:
  //         default:
  //           return Stack(
  //             children: [
  //               Container(
  //                   padding: EdgeInsets.all(8),
  //                   child: ListView(
  //                     children: [
  //                       StreamBuilder<bool>(
  //                         stream: quesShowImageStream.stream,
  //                         initialData: quesShowImageStream.value,
  //                         builder: (context, snapshot) {
  //                           if ((snapshot.hasData &&
  //                               snapshot.data! &&
  //                               (boxes![currentIndex].card!.imagePath != null &&
  //                                   boxes![currentIndex]
  //                                       .card!
  //                                       .imagePath!
  //                                       .isNotEmpty))) {
  //                             return Image.file(
  //                                 File(boxes![currentIndex].card!.imagePath!));
  //                           } else {
  //                             return Container();
  //                           }
  //                         },
  //                       ),
  //                       (boxes![currentIndex].card!.questionVoicePath == null ||
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .questionVoicePath!
  //                                   .isEmpty)
  //                           ? Container()
  //                           : ControlButtonsOld(
  //                               indexCallBackTrigger:
  //                                   boxes![currentIndex].card!.id.toString(),
  //                               musicEndCallBack: musicPlayCompleteCallBack,
  //                               speedController: question_review_controler,
  //                               key: questionVoiceControlBtnKey,
  //                               path: boxes![currentIndex]
  //                                   .card!
  //                                   .questionVoicePath),
  //                       ListTile(
  //                         // title: Text(boxes![currentIndex].card!.question ?? ''),
  //                         title: StreamBuilder(
  //                           stream: questionController.obs.stream,
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshot) {
  //                             return Container(
  //                               child: qu.QuillEditor(
  //                                 controller: questionController,
  //                                 readOnly: true, // true for view only mode
  //                                 autoFocus: true,
  //                                 scrollController: ScrollController(),
  //                                 expands: false,
  //                                 focusNode: FocusNode(),
  //                                 scrollable: false,
  //                                 padding: EdgeInsets.only(left: 0, right: 0),
  //                                 customStyles: quilTheme,
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                         leading: InkWell(
  //                             onTap: () {
  //                               String language = getLangForTTS(
  //                                   boxes![currentIndex]
  //                                           .subGroup!
  //                                           .languageItemOne ??
  //                                       0);
  //                               tts.setLanguage(language);
  //                               String text =
  //                                   questionController.document.toPlainText();
  //                               tts.speak(text);
  //                             },
  //                             child: Icon(
  //                               CupertinoIcons.speaker_1_fill,
  //                               color:
  //                                   themeContoller.themeData.value.primaryColor,
  //                             )),
  //                       ),
  //                       Obx(() {
  //                         return (boxes![currentIndex].card!.spellChecker ==
  //                                     true ||
  //                                 _cardsController.allSpellCheck.value)
  //                             ? Column(children: [
  //                                 Divider(),
  //                                 Card(
  //                                   color: themeContoller
  //                                       .themeData.value.splashColor,
  //                                   elevation: 5,
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: Center(
  //                                         child: _cardsController
  //                                             .textWidget.value),
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   margin: EdgeInsets.only(bottom: 15),
  //                                   child: TextFormField(
  //                                     enabled: true,
  //                                     controller: txtReply,
  //                                     autocorrect: false,
  //                                     enableSuggestions: false,
  //                                     // keyboardType: TextInputType.emailAddress,
  //                                     autofocus: false,
  //                                     onChanged: (value) {
  //                                       String text = replyController.document
  //                                           .toPlainText()
  //                                           .toLowerCase();
  //                                       _cardsController.check(
  //                                           input: value, strAnswer: text);
  //                                     },
  //                                     keyboardType: TextInputType.multiline,
  //                                     maxLines: 2,
  //                                     minLines: 1,
  //                                     decoration: InputDecoration(
  //                                         labelText: 'Enter Your Reply'),
  //                                   ),
  //                                 )
  //                               ])
  //                             : Container();
  //                       }),
  //                       SizedBox(
  //                         height: 150,
  //                       )
  //                     ],
  //                   )),
  //               Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       (_isKeyboardVisible == false)
  //                           ? Padding(
  //                               padding: const EdgeInsets.only(bottom: 12.0),
  //                               child: VoiceRecordViewPage(
  //                                   voiceEditingController:
  //                                       voiceReplyController),
  //                             )
  //                           : Container(),
  //                       Obx(() {
  //                         if (_cardsController.allSpellCheck.value ||
  //                             _cardsController.hasCardSpellCheck.value &&
  //                                 _cardsController.isSpellCheck.value &&
  //                                 !_cardsController.showAnswer.value) {
  //                           return Container(
  //                             margin: EdgeInsets.only(bottom: 12),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceAround,
  //                               children: [
  //                                 Container(
  //                                   margin: EdgeInsets.only(left: 10),
  //                                   height: 30.0,
  //                                   child: ElevatedButton(
  //                                     onPressed: () {
  //                                       String text = replyController.document
  //                                           .toPlainText()
  //                                           .toLowerCase();
  //                                       _cardsController.check(
  //                                           input: txtReply.text,
  //                                           strAnswer: text,
  //                                           check: true);
  //                                     },
  //                                     style: ButtonStyle(
  //                                         backgroundColor:
  //                                             MaterialStateProperty.all(
  //                                                 Colors.white),
  //                                         shape: MaterialStateProperty.all<
  //                                                 RoundedRectangleBorder>(
  //                                             RoundedRectangleBorder(
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(
  //                                                         10.0),
  //                                                 side: BorderSide(
  //                                                   color: Colors.black,
  //                                                 )))),
  //                                     child: Text(
  //                                       "Check",
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                         color: Color(0xff27187E),
  //                                         fontSize: 12,
  //                                         fontFamily: "Poppins",
  //                                         fontWeight: FontWeight.w300,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 8,
  //                                 ),
  //                                 Container(
  //                                   height: 30.0,
  //                                   child: ElevatedButton(
  //                                     onPressed: () {
  //                                       String text = replyController.document
  //                                           .toPlainText()
  //                                           .toLowerCase();
  //                                       _cardsController.check(
  //                                           input: txtReply.text,
  //                                           strAnswer: text,
  //                                           check: true,
  //                                           help: true);
  //                                     },
  //                                     style: ButtonStyle(
  //                                         backgroundColor:
  //                                             MaterialStateProperty.all(
  //                                                 Colors.white),
  //                                         shape: MaterialStateProperty.all<
  //                                                 RoundedRectangleBorder>(
  //                                             RoundedRectangleBorder(
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(
  //                                                         10.0),
  //                                                 side: BorderSide(
  //                                                   color: Colors.black,
  //                                                 )))),
  //                                     child: Text(
  //                                       "Help",
  //                                       style: TextStyle(
  //                                         color: Color(0xff27187E),
  //                                         fontSize: 12,
  //                                         fontFamily: "Poppins",
  //                                         fontWeight: FontWeight.w300,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 8,
  //                                 ),
  //                                 Container(
  //                                     height: 30.0,
  //                                     child: GestureDetector(
  //                                         child: ElevatedButton(
  //                                           onPressed: () {},
  //                                           style: ButtonStyle(
  //                                               backgroundColor:
  //                                                   MaterialStateProperty.all(
  //                                                       Colors.white),
  //                                               shape: MaterialStateProperty.all<
  //                                                       RoundedRectangleBorder>(
  //                                                   RoundedRectangleBorder(
  //                                                       borderRadius:
  //                                                           BorderRadius
  //                                                               .circular(10.0),
  //                                                       side: BorderSide(
  //                                                         color: Colors.black,
  //                                                       )))),
  //                                           child: Text(
  //                                             "Hold to Show",
  //                                             style: TextStyle(
  //                                               color: Color(0xff27187E),
  //                                               fontSize: 12,
  //                                               fontFamily: "Poppins",
  //                                               fontWeight: FontWeight.w300,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         onTapDown: (_) {
  //                                           String text = replyController
  //                                               .document
  //                                               .toPlainText()
  //                                               .toLowerCase();
  //                                           _cardsController.check(
  //                                               input: txtReply.text,
  //                                               strAnswer: text,
  //                                               check: true,
  //                                               show: true);
  //                                         },
  //                                         onTapCancel: () {
  //                                           String text = replyController
  //                                               .document
  //                                               .toPlainText()
  //                                               .toLowerCase();
  //                                           _cardsController.check(
  //                                             input: txtReply.text,
  //                                             strAnswer: text,
  //                                           );
  //                                         })),
  //                                 SizedBox(
  //                                   height: 8,
  //                                 ),
  //                                 // Container(
  //                                 //   height: 30.0,
  //                                 //   width: 50,
  //                                 //   child: RaisedButton(
  //                                 //     onPressed: () {
  //                                 //       String text =
  //                                 //           replyController
  //                                 //               .document
  //                                 //               .toPlainText()
  //                                 //               .toLowerCase();
  //                                 //       _cardsController
  //                                 //           .showAnswer(true);
  //                                 //     },
  //                                 //     shape:
  //                                 //         RoundedRectangleBorder(
  //                                 //       borderRadius:
  //                                 //           BorderRadius.circular(
  //                                 //               18.0),
  //                                 //     ),
  //                                 //     padding: EdgeInsets.only(
  //                                 //         left: 8.0, right: 8),
  //                                 //     color:
  //                                 //         Get.theme.primaryColor,
  //                                 //     textColor: Colors.white,
  //                                 //     child: Center(
  //                                 //         child: Text("Pass",
  //                                 //             style: TextStyle(
  //                                 //                 fontSize: 15))),
  //                                 //   ),
  //                                 // ),
  //                               ],
  //                             ),
  //                           );
  //                         } else
  //                           return Container();
  //                       }),
  //                       InkWell(
  //                         onTap: () {
  //                           //    if (secondDifficult! <= _seconds) {
  //                           //   Get.snackbar(
  //                           //       'warning'.tr, 'difficult_question_msg'.tr,
  //                           //       backgroundColor: Colors.redAccent,
  //                           //       colorText: Colors.white);
  //                           // }

  //                           cardKey.currentState!.toggleCard();

  //                           voiceRecordKey.currentState?.stopRecord();
  //                           voiceRecordKey.currentState?.setStatusRecord(false);

  //                           isFront = false;
  //                           enableEdit = false;
  //                           timerKey.currentState!.stopTimer(resets: false);
  //                           if (_seconds <= secondDifficult! * 0.4) {
  //                             difficultLevel = 2;
  //                             setState(() {});
  //                             print('خیلی ساده');
  //                           } else if (_seconds > secondDifficult! * 0.4 &&
  //                               _seconds <= secondDifficult! * 0.7) {
  //                             difficultLevel = 3;
  //                             setState(() {});
  //                             difficultLevel = 3;
  //                             print('ساده');
  //                           } else if (_seconds > secondDifficult! * 0.7 &&
  //                               _seconds <= secondDifficult!) {
  //                             difficultLevel = 4;
  //                             setState(() {});
  //                             print('متوسط');
  //                           } else if (_seconds > secondDifficult! &&
  //                               _seconds <= secondDifficult! * 1.5) {
  //                             difficultLevel = 5;
  //                             setState(() {});
  //                             print('سخت');
  //                           } else if (_seconds > secondDifficult! * 1.5) {
  //                             difficultLevel = 6;
  //                             setState(() {});
  //                             print('بلد نیستم');
  //                           }
  //                           //شرط های لازم برای خوانش اتوماتیک پاسخ
  //                           if (autoPlayReview == true &&
  //                               isFront == false &&
  //                               boxes![currentIndex]
  //                                   .card!
  //                                   .questionVoicePath!
  //                                   .isNotEmpty) {
  //                             Future.delayed(Duration(seconds: 1), () {
  //                               replyVoiceControlBtnKey!.currentState!.player
  //                                   .play();
  //                             });
  //                           }
  //                         },
  //                         child: Container(
  //                           margin: EdgeInsets.only(bottom: 15),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               CircleAvatar(
  //                                   child: Icon(
  //                                       Icons.rotate_90_degrees_ccw_rounded)),
  //                               Container(
  //                                 width: 10,
  //                               ),
  //                               CircleAvatar(
  //                                 child: Text(boxes != null
  //                                     ? boxes!.length.toString()
  //                                     : '0'),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   )),
  //             ],
  //           );
  //       }
  //     }),
  //   );
  // }

  void play(String path) {
    final audioPlayer = AssetsAudioPlayer();
    audioPlayer.open(
      Audio.file(path),
      autoStart: true,
      showNotification: true,
    );
  }
}

List<Widget> SettingItem(
  String title,
  bool item,
  StreamController<bool> streamController,
  ValueChanged<bool> onChangeCallStream,
) {
  return [
    Text(
      title,
    ),
    StreamBuilder(
      stream: streamController.stream,
      initialData: item,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: Transform.scale(
            scale: 0.6,
            child: CupertinoSwitch(
              value: snapshot.data,
              onChanged: (value) {
                //  setState(() {
                streamController.sink.add(value);
                onChangeCallStream(value);
              },
            ),
          ),
        );
      },
    ),
  ];
}
