import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Fast_learning/leitner_box/audio_player.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:Fast_learning/leitner_box/customWidgets/twostatewidget.dart';
import 'package:Fast_learning/leitner_box/screens/leitner84.dart';
import 'package:Fast_learning/pages/show_hint.dart';
import 'package:Fast_learning/zcomponent/common_widget/translation.dart';
import 'package:analyzer/instrumentation/file_instrumentation.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:Fast_learning/controllers/add_leitner_controller.dart';
import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/music.dart';
import 'package:Fast_learning/speed_controller.dart';
import 'package:Fast_learning/tools/tools.dart';
import 'package:Fast_learning/voice_record_view_page.dart';
import 'package:async/async.dart';
import 'package:darq/darq.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:flutter_quill/flutter_quill.dart' as qu;
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'constants/preference.dart';
import 'controllers/music_controller.dart';
import 'controllers/theme_controller.dart';
import 'customcard_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
// import 'tools/export/lesson_page.dart';

class CardViewPage extends StatefulWidget {
  final bool autoPlay;
  final bool autoSliding;
  final List<TblCard> cards;
  final TblCard currentCard;
  final Lesson lesson;
  final List<Lesson>? list_of_lessons;
  final int lesson_index;
  bool mergeLessons;
  final bool autoPlayDescription;
  final bool keepAwake;
  bool showImage;
  final bool showAnswer;
  final int cardIndex;
  final bool autoOpenCardView;
  double numberOfPlayQuestion;
  double numberOfPlayAnswer;
  double numberOfPlayDescription;
  final double nextLessonDelay;
  double autoDelay;
  double repeteAnswerDelay;
  bool autoplaySpell;
  bool isEditable;

  CardViewPage(
      {Key? key,
      required this.cards,
      required this.currentCard,
      required this.lesson,
      required this.list_of_lessons,
      required this.lesson_index,
      this.cardIndex = 0,
      this.autoOpenCardView = false,
      prefs,
      this.isEditable = true})
      : this.autoPlay = prefs.getBool(Preference.autoPlayTraining) ?? false,
        this.autoplaySpell = prefs.getBool(Preference.autoplaySpell) ?? false,
        this.autoSliding = prefs.getBool(Preference.autoSliding) ?? false,
        this.autoPlayDescription =
            prefs.getBool(Preference.autoPlayDescription) ?? false,
        this.mergeLessons = prefs.getBool(Preference.mergeLessons) ?? false,
        this.keepAwake = prefs.getBool(Preference.keepAwake) ?? false,
        this.autoDelay = prefs.getDouble(Preference.delayToPlayAnswer) ?? 0,
        this.numberOfPlayAnswer =
            prefs.getDouble(Preference.numberOfPlayAnswer) ?? 1,
        this.numberOfPlayQuestion =
            prefs.getDouble(Preference.numberOfPlayQuestion) ?? 1,
        this.numberOfPlayDescription =
            prefs.getDouble(Preference.numberOfPlayDescription) ?? 1,
        this.nextLessonDelay =
            prefs.getDouble(Preference.autoDelayToGoNextLesson) ?? 0,
        this.repeteAnswerDelay =
            prefs.getDouble(Preference.autoDelayToRepeteAnswer) ?? 0,
        this.showImage = prefs.getBool(Preference.showImage) ?? false,
        this.showAnswer = prefs.getBool(Preference.hasSpellCheck) ?? false,
        super(key: key);

  @override
  _CardViewPageState createState() => _CardViewPageState();
}

class _CardViewPageState extends State<CardViewPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  CardsController cardsController = Get.find<CardsController>();
  AddLeitnerController addLeitnerController = Get.find<AddLeitnerController>();
  StreamController<int> indicatorController = StreamController<int>.broadcast();
  List<GlobalKey<ControlButtonsOldState>> questionControlBtnKeys = [];
  List<GlobalKey<ControlButtonsOldState>> replyControlBtnKeys = [];
  List<GlobalKey<ControlButtonsOldState>> descriptionControlBtnKeys = [];
  StreamController<bool> questionTxtChangeStream = StreamController.broadcast();
  StreamController<bool> replyTxtChangeStream = StreamController.broadcast();
  StreamController<bool> descTxtChangeStream = StreamController.broadcast();
  StreamController<bool> autoplayStream = StreamController<bool>.broadcast();
  StreamController<bool> autoPlayDesciptionStream =
      StreamController<bool>.broadcast();
  StreamController<bool> autoMergeLessonsStream =
      StreamController<bool>.broadcast();
  StreamController<bool> autoKeepAwakeStream =
      StreamController<bool>.broadcast();
  // StreamController<double> autoDelayStream = StreamController<double>();
  final _autoDelayStream = BehaviorSubject.seeded(0.0);
  final _nextLessonDelayStream = BehaviorSubject.seeded(0.0);
  final _repeteAnswerStream = BehaviorSubject.seeded(0.0);
  final _howManyTimePlayQuestionStream = BehaviorSubject.seeded(0.0);
  final _howManyTimePlayAnswerStream = BehaviorSubject.seeded(0.0);
  final _howManyTimePlayDescriptionStream = BehaviorSubject.seeded(0.0);
  final showImageStream = BehaviorSubject.seeded(false);
  StreamSubscription<void>? replyUnsubscriber;

  StreamSubscription<void>? questionUnsubscriber;

  StreamSubscription? actionWithDelayUnsubscriber;
  StreamSubscription? ttsSubscribation;
  int howManyPlayedQuestion = 0;
  int howManyPlayedAnswer = 0;
  int howManyPlayedDescription = 0;

  Stream<double> get delayStreem => _autoDelayStream.stream;
  Stream<double> get nextLessonDelayStream => _nextLessonDelayStream.stream;
  Stream<double> get repeteAnswerStream => _repeteAnswerStream.stream;
  Stream<double> get howManyTimePlayDescriptionStream =>
      _howManyTimePlayDescriptionStream.stream;
  Stream<double> get howManyTimePlayQuestionStream =>
      _howManyTimePlayQuestionStream.stream;
  Stream<double> get howManyTimePlayAnswerStream =>
      _howManyTimePlayAnswerStream.stream;
  StreamController<bool> addCardReviewStream =
      StreamController<bool>.broadcast();
  StreamController<int> floadActionBtnStream =
      StreamController<int>.broadcast();
  StreamController<bool> iKnowStream = StreamController<bool>.broadcast();
  StreamController<bool> autoSlidingStream = StreamController<bool>.broadcast();
  qu.QuillController questionController = qu.QuillController.basic();
  qu.QuillController replyController = qu.QuillController.basic();
  qu.QuillController descController = qu.QuillController.basic();
  TextEditingController voiceEditingController = TextEditingController();

  PageController? controller;
  TextToSpeech tts = TextToSpeech();
  TextToSpeech tts_answer = TextToSpeech();
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  QuestionReviewSpeedController questionReviewSpeedController =
      Get.find<QuestionReviewSpeedController>();
  ReplyReviewSpeedController replyReviewSpeedController =
      Get.find<ReplyReviewSpeedController>();
  DescriptionReviewSpeedController descriptionReviewSpeedController =
      Get.find<DescriptionReviewSpeedController>();
  TextEditingController txtReply = TextEditingController();
  MusicController mController = Get.find<MusicController>();
  CardsController _cardsController = Get.find<CardsController>();
  double delay = 0;
  int? selectedindex = 0;
  bool autoPlay = false;
  bool autoSlide = false;
  bool autoPlayDescription = false;
  bool showImage = false;
  bool autoMergeLessons = false;

  GlobalKey _1_timers = GlobalKey();
  GlobalKey _2_sliding = GlobalKey();
  GlobalKey _3_auto_play = GlobalKey();
  GlobalKey _4_play_dis = GlobalKey();
  GlobalKey _5_show_image = GlobalKey();
  GlobalKey _6_show_spell_check = GlobalKey();
  GlobalKey _7_tts = GlobalKey();
  GlobalKey _8_merge_lesson = GlobalKey();
  GlobalKey _9_auto_leitner = GlobalKey();
  GlobalKey _10_screen_awake = GlobalKey();
  GlobalKey _11_i_know = GlobalKey();
  GlobalKey _12_send_to_review = GlobalKey();
  GlobalKey _13_record_voice = GlobalKey();
  GlobalKey _14_tts = GlobalKey();
  GlobalKey _15_how_many_play = GlobalKey();
  GlobalKey _16_website = GlobalKey();

  List<GlobalKey> get _hint_list => [
        _1_timers,
        _2_sliding,
        _3_auto_play,
        _4_play_dis,
        _5_show_image,
        _6_show_spell_check,
        // _7_tts,
        _8_merge_lesson,
        _9_auto_leitner,
        _10_screen_awake,
        _16_website,
        _11_i_know,
        _12_send_to_review,
        _13_record_voice,
        _14_tts,
        _15_how_many_play,
      ];
  CancelableOperation? ttsCanceler;
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    mController = Get.find();
    if (state == AppLifecycleState.inactive) {
      // int index = ((1 +
      //             widget.numberOfPlayAnswer.toInt() +
      //             (widget.autoPlayDescription ? 1 : 0)) *
      //         selectedindex!) *
      //     (widget.lesson_index);
      TblCard card = widget.cards[selectedindex!];
      if (autoPlay == true &&
          ((questionControlBtnKeys[selectedindex!].currentState != null &&
                  questionControlBtnKeys[selectedindex!]
                      .currentState!
                      .player
                      .playing) ||
              (replyControlBtnKeys[selectedindex!].currentState != null &&
                  replyControlBtnKeys[selectedindex!]
                      .currentState!
                      .player
                      .playing) ||
              (descriptionControlBtnKeys[selectedindex!].currentState != null &&
                  descriptionControlBtnKeys[selectedindex!]
                      .currentState!
                      .player
                      .playing))) {
        await descriptionControlBtnKeys[selectedindex!]
            .currentState
            ?.player
            .stop();
        await questionControlBtnKeys[selectedindex!]
            .currentState
            ?.player
            .stop();
        await replyControlBtnKeys[selectedindex!].currentState?.player.stop();

        // print(
        //     'app inactive, is lock screen: ${replyControlBtnKeys[selectedindex!].currentState!.player}');

        mController.play(
          widget.cards,
          selectedindex!,
          widget.list_of_lessons!.length,
          card,
          widget.list_of_lessons,
        );
      }
    } else if (state == AppLifecycleState.resumed) {
      print('app resumed');
      if (mController.player.playing) {
        Future.delayed(Duration(seconds: 1)).then((value) async {
          await mController.player.stop();
          await mController.sub?.cancel();
          mController.dispose();
        });
        int next_index = mController
            .myAudios[mController.currentAudioIndex.value].card.lessonId!;
        // If there is any Lesson it will forward to it
        if (next_index != widget.currentCard.lessonId) {
          final prefs = await SharedPreferences.getInstance();
          // Lesson lesson = widget.list_of_lessons![next_index];
          Lesson lesson = (await Lesson()
                  .select()
                  .id
                  .equals(next_index)
                  .orderBy('id')
                  .toList())
              .first;
          Lesson().getById(lesson.id, preload: true).then((value) async {
            Navigator.of(context)
                .popUntil((route) => route.isFirst); // await Get.to
            await Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) {
                  return CupertinoPageScaffold(
                      resizeToAvoidBottomInset: true,
                      child: CustomCardPage(
                        lesson: value!,
                        list_of_lessons: widget.list_of_lessons!,
                        lesson_index: widget.list_of_lessons!
                            .indexWhere((element) => element.id == next_index),
                        auto_open_first: true,
                        radioSelected:
                            prefs.getInt(Preference.reviewRadioOption) ?? 0,
                        cardIndex: mController.currentCard.id!,
                        isEditable: widget.isEditable,
                      ));
                },
              ),
            );
            // await Get.offUntil(
            //     GetPageRoute(
            //         page: () => CustomCardPage(
            //               lesson: value!,
            //               list_of_lessons: widget.list_of_lessons!,
            //               lesson_index: widget.list_of_lessons!.indexWhere(
            //                   (element) => element.id == next_index),
            //               auto_open_first: true,
            //               radioSelected:
            //                   prefs.getInt(Preference.reviewRadioOption) ?? 0,
            //               cardIndex: mController.currentCard.id!,
            //             )),
            //     );
          });
        } else if (mController.currentCard.id !=
            widget.cards[selectedindex!].id) {
          controller!.animateToPage(
              widget.cards.indexWhere(
                  (element) => element.id == mController.currentCard.id),
              duration: Duration(seconds: 1),
              curve: Curves.bounceIn);
          mController.player.pause();
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Wakelock.disable();
    replyTxtChangeStream.close();
    descTxtChangeStream.close();
    questionTxtChangeStream.close();
    iKnowStream.close();
    indicatorController.close();
    autoplayStream.close();
    addCardReviewStream.close();
    autoSlidingStream.close();
    autoMergeLessonsStream.close();
    autoPlayDesciptionStream.close();
    autoKeepAwakeStream.close();
    _autoDelayStream.close();
    _nextLessonDelayStream.close();
    floadActionBtnStream.close();
    _howManyTimePlayDescriptionStream.close();
    _howManyTimePlayQuestionStream.close();
    _howManyTimePlayAnswerStream.close();
    _repeteAnswerStream.close();
    actionWithDelayUnsubscriber?.cancel();
    ttsSubscribation?.cancel();
    showImageStream.close();
    _cardsController.clearTextWidget();

    stopPlayers();
    ttsCanceler?.cancel();
    tts.stop();
    SharedPreferences.getInstance().then(
        (prefs) => prefs.setBool(Preference.show_hint_flashcard_page, false));

    super.dispose();
  }

  void stopPlayers() async {
    for (int i = 0; i < widget.cards.length; i++) {
      await questionControlBtnKeys[i].currentState!.player.stop();
      await replyControlBtnKeys[i].currentState!.player.stop();
      await descriptionControlBtnKeys[i].currentState!.player.stop();
    }
  }

  @override
  void initState() {
    var autoplay = true;
    ttsCanceler?.cancel();
    WidgetsBinding.instance.addObserver(this);
    if (widget.autoOpenCardView) {
      if (widget.cardIndex == 0) {
        selectedindex = 0;
        print(selectedindex!);
      } else if (widget.cardIndex == -1) {
        selectedindex = widget.cards.length - 1;
        print(selectedindex!);
      } else {
        selectedindex = widget.cards
            .indexWhere((element) => element.id == widget.cardIndex);
        selectedindex =
            selectedindex == -1 ? widget.cards.length - 1 : selectedindex;
        print(selectedindex!);
      }
    } else {
      selectedindex = widget.cards.indexOf(widget.currentCard);
    }
    _cardsController.selectedindex.value = selectedindex!;
    txtReply.clear();
    _cardsController.hasCardSpellCheck.value =
        widget.cards[selectedindex!].spellChecker ?? false;
    Wakelock.toggle(enable: widget.keepAwake);
    floadActionBtnStream.add(selectedindex ?? 0);
    _autoDelayStream.add(widget.autoDelay);
    _howManyTimePlayDescriptionStream.add(widget.numberOfPlayDescription);
    _howManyTimePlayQuestionStream.add(widget.numberOfPlayQuestion);
    _howManyTimePlayAnswerStream.add(widget.numberOfPlayAnswer);
    _repeteAnswerStream.add(widget.repeteAnswerDelay);
    _nextLessonDelayStream.add(widget.nextLessonDelay);
    showImage = widget.showImage;
    autoPlay = widget.autoPlay;
    autoSlide = widget.autoSliding;
    autoPlayDescription = widget.autoPlayDescription;
    autoMergeLessons = widget.mergeLessons;
    showImageStream.add(showImage);

//addLeitnerController.addLeitnerStatus.stream.listen((value) {print(value); });
    tts.getLanguages().then((value) {
      print(value);
    });

    controller = PageController(initialPage: selectedindex!);
    editTextsPrepare();
    setState(() {
      Future.delayed(Duration(seconds: 1), () {
        if (widget.cards[selectedindex!].questionVoicePath!.isNotEmpty &&
            autoPlay == true) {
          questionUnsubscriber = questionControlBtnKeys[selectedindex!]
              .currentState!
              .player
              .play()
              .asStream()
              .listen((event) {});
        }
      });
    });
    _tabController = TabController(length: widget.cards.length, vsync: this);
    controller!.addListener(() {
      stopPlayers();
      if (mController.player.playing) {
        Future.delayed(Duration(seconds: 1)).then((value) async {
          await mController.player.stop();
          await mController.sub?.cancel();
          mController.dispose();
        });
      }
      howManyPlayedQuestion = 0;
      howManyPlayedAnswer = 0;
      howManyPlayedDescription = 0;

      actionWithDelayUnsubscriber?.cancel();
      // setState(() {
      // });
      selectedindex = controller!.page!.toInt();
      floadActionBtnStream.add(selectedindex!);
      indicatorController.sink.add(selectedindex!);
      _tabController!.index = selectedindex!;
      addCardReviewStream.sink
          .add(widget.cards[selectedindex!].reviewStart ?? false);
      iKnowStream.sink.add(widget.cards[selectedindex!].examDone ?? false);

      Future.delayed(Duration(seconds: 1), () {
        if (widget.cards[selectedindex!].questionVoicePath!.isNotEmpty &&
            autoPlay == true) {
          questionUnsubscriber = questionControlBtnKeys[selectedindex!]
              .currentState!
              .player
              .play()
              .asStream()
              .listen((event) {});
        }
      });
      editTextsPrepare();
      questionTxtChangeStream.sink.add(true);
      replyTxtChangeStream.sink.add(true);
      descTxtChangeStream.sink.add(true);
      showImageStream.add(showImage);

      // if (widget.showImage)
      //   showImageStream.sink.add(
      //       (widget.cards[selectedindex!].imagePath != null &&
      //           widget.cards[selectedindex!].imagePath!.isNotEmpty));
      if (_cardsController.selectedindex.value != selectedindex!) {
        txtReply.clear();
        _cardsController.selectedindex.value = selectedindex!;
      } else {
        _cardsController.check(
          input: txtReply.text,
        );
      }
      _cardsController.clearTextWidget();
      _cardsController.showAnswer.value = false;
      _cardsController.hasCardSpellCheck.value =
          widget.cards[selectedindex!].spellChecker ?? false;
      String text = replyController.document.toPlainText().toLowerCase();
      _cardsController.check(strAnswer: text);
      // if (widget.autoSliding &&
      //     !_tabController!.indexIsChanging &&
      //     ((widget.cards[selectedindex!].questionVoicePath?.isEmpty ?? false) &&
      //         (widget.cards[selectedindex!].replyVoicePath?.isEmpty ??
      //             false))) {
      //   Future.delayed(Duration(seconds: 3)).then((v) {
      //     goToNextSlide();
      //   });
      // }
      // tts.stop();

      // if (!_cardsController.isSpellCheck.value &&
      //     !_tabController!.indexIsChanging &&
      //     widget.autoplaySpell &&
      //     ((widget.cards[selectedindex!].questionVoicePath?.isEmpty ?? true) ||
      //         (widget.cards[selectedindex!].replyVoicePath?.isEmpty ?? true))) {
      //   String language = getLangForTTS(
      //       widget.currentCard.plLesson?.plSubGroup?.languageItemOne ?? 0);
      //   tts.setLanguage(language);
      //   var ttsfuture =
      //       Future.delayed(Duration(seconds: 1)).then((value) async {
      //     if (widget.autoplaySpell &&
      //         (widget.cards[selectedindex!].questionVoicePath?.isEmpty ??
      //             true)) {
      //       String language = getLangForTTS(
      //           widget.currentCard.plLesson?.plSubGroup?.languageItemTwo ?? 0);
      //       tts.setLanguage(language);
      //       await tts.speak(questionController.document.toPlainText());
      //       await SharedPreferences.getInstance().then((prefs) async {
      //         await Future.delayed(Duration(
      //             seconds:
      //                 prefs.getDouble(Preference.delayToPlayAnswer)?.toInt() ??
      //                     0));
      //       });
      //     }
      //     if (widget.autoplaySpell &&
      //         (widget.cards[selectedindex!].replyVoicePath?.isEmpty ?? true)) {
      //       await SharedPreferences.getInstance().then((prefs) async {
      //         await Future.delayed(Duration(seconds: 1));
      //         for (double i = 0;
      //             i < widget.numberOfPlayAnswer &&
      //                 !(ttsCanceler?.isCanceled ?? false);
      //             i++) {
      //           await tts.speak(replyController.document.toPlainText());

      //           // await Future.delayed(Duration(
      //           //     seconds: prefs
      //           //             .getDouble(Preference.delayToPlayAnswer)
      //           //             ?.toInt() ??
      //           //         0));
      //         }
      //       });
      //     }
      // ttsCanceler = CancelableOperation.fromFuture(
      //   ttsfuture,
      //   onCancel: () {
      //     tts.stop();
      //     print('canelled');
      //   },
      // );
      // }

      // });
      if (widget.cards[selectedindex!].descriptionVoicePath!.isNotEmpty &&
          autoPlay &&
          autoPlayDescription) {
        descriptionControlBtnKeys[selectedindex!].currentState?.player.play();
      } else if (widget.cards[selectedindex!].descriptionVoicePath!.isEmpty ||
          autoSlide ||
          (autoMergeLessons && selectedindex! == widget.cards.length - 1)) {}

      // setState(() {
      // });
    });
    buildGlobalKeys();
    // SharedPreferences.getInstance().then((prefs) {
    //   final do_show =
    //       prefs.getBool(Preference.show_hint_flashcard_page) ?? true;
    //   show_hint(this.context, _hint_list, do_show);
    // });
    super.initState();
  }

  void editTextsPrepare() {
    //*******question */
    if (widget.cards[selectedindex!].question != null) {
      print(widget.cards[selectedindex!].question);
      qu.Document doc = qu.Document()
        ..insert(0, widget.cards[selectedindex!].question);

      try {
        questionController = qu.QuillController(
            document: qu.Document.fromJson(
                jsonDecode(widget.cards[selectedindex!].question!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        questionController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
    //*******reply */
    if (widget.cards[selectedindex!].reply != null) {
      qu.Document doc = qu.Document()
        ..insert(0, widget.cards[selectedindex!].reply);

      try {
        replyController = qu.QuillController(
            document: qu.Document.fromJson(
                jsonDecode(widget.cards[selectedindex!].reply!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        replyController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
//*********description */
    if (widget.cards[selectedindex!].description != null) {
      qu.Document doc = qu.Document()
        ..insert(0, widget.cards[selectedindex!].description);

      try {
        descController = qu.QuillController(
            document: qu.Document.fromJson(
                jsonDecode(widget.cards[selectedindex!].description!)),
            selection: TextSelection.collapsed(offset: 0));
      } catch (e) {
        descController = qu.QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      }
    }
  }

  void playReplyAuto() {
    if (widget.cards[selectedindex!].questionVoicePath!.isNotEmpty &&
        autoPlay == true &&
        howManyPlayedQuestion + 1 < widget.numberOfPlayQuestion) {
      SharedPreferences.getInstance().then((prefs) async {
        final delay = prefs.getDouble(Preference.autoDelayToRepeteAnswer) ?? 0;
        actionWithDelayUnsubscriber?.cancel();
        actionWithDelayUnsubscriber =
            Future.delayed(Duration(seconds: delay.toInt()))
                .asStream()
                .listen((event) {
          howManyPlayedQuestion++;
          questionControlBtnKeys[selectedindex!]
              .currentState
              ?.player
              .seek(Duration(seconds: 0));

          replyUnsubscriber = questionControlBtnKeys[selectedindex!]
              .currentState
              ?.player
              .play()
              .asStream()
              .listen((event) {});
        });
      });
    } else if (widget.cards[selectedindex!].replyVoicePath!.isNotEmpty &&
        autoPlay == true &&
        howManyPlayedAnswer < widget.numberOfPlayAnswer) {
      print(widget.numberOfPlayAnswer);
      SharedPreferences.getInstance().then((prefs) async {
        final delay = (howManyPlayedAnswer == 0
                ? prefs.getDouble(Preference.delayToPlayAnswer)
                : prefs.getDouble(Preference.autoDelayToRepeteAnswer)) ??
            0;
        actionWithDelayUnsubscriber?.cancel();
        actionWithDelayUnsubscriber =
            Future.delayed(Duration(seconds: delay.toInt()))
                .asStream()
                .listen((event) {
          howManyPlayedAnswer++;
          replyControlBtnKeys[selectedindex!]
              .currentState
              ?.player
              .seek(Duration(seconds: 0));

          replyUnsubscriber = replyControlBtnKeys[selectedindex!]
              .currentState
              ?.player
              .play()
              .asStream()
              .listen((event) {});
        });
      });
    } else if (widget.cards[selectedindex!].descriptionVoicePath!.isNotEmpty &&
        autoPlay &&
        autoPlayDescription &&
        howManyPlayedDescription < widget.numberOfPlayDescription) {
      descriptionControlBtnKeys[selectedindex!].currentState?.player.play();
      howManyPlayedDescription++;
    }
    // else if (widget.cards[selectedindex!].descriptionVoicePath!.isEmpty &&
    //         autoSlide ||
    //     (autoMergeLessons && selectedindex! == widget.cards.length - 1)) {
    //   goToNextSlide();
    // }
    else if (widget.autoplaySpell &&
        (widget.cards[selectedindex!].replyVoicePath!.isEmpty ||
            widget.cards[selectedindex!].questionVoicePath!.isEmpty) &&
        autoPlay == true &&
        howManyPlayedAnswer < widget.numberOfPlayAnswer) {
    } else {
      goToNextSlide();
    }
  }

  void playDecriptionAuto() {
    if (widget.cards[selectedindex!].descriptionVoicePath!.isNotEmpty &&
        autoPlay &&
        autoPlayDescription &&
        howManyPlayedDescription < widget.numberOfPlayDescription) {
      descriptionControlBtnKeys[selectedindex!].currentState?.player.play();
      howManyPlayedDescription++;
    } else {
      goToNextSlide();
    }
  }

  void goToNextSlide() {
    if (autoSlide == true && selectedindex! < widget.cards.length) {
      if (addLeitnerController.addLeitnerStatus.value == true) {
        addCardReviewStream.sink
            .add(addLeitnerController.addLeitnerStatus.value);
        widget.cards[selectedindex!].reviewStart =
            addLeitnerController.addLeitnerStatus.value;
        widget.cards[selectedindex!]
            .save()
            .then((value) => cardsController.rebind());
      }

      controller!.animateToPage(selectedindex! + 1,
          duration: Duration(seconds: 1), curve: Curves.bounceIn);
    }
    if (autoMergeLessons == true && selectedindex! == widget.cards.length - 1) {
      SharedPreferences.getInstance().then((prefs) async {
        actionWithDelayUnsubscriber = Future.delayed(Duration(
                seconds: prefs
                        .getDouble(Preference.autoDelayToGoNextLesson)
                        ?.toInt() ??
                    0))
            .asStream()
            .listen((event) {
          AssetsAudioPlayer.newPlayer()
              .open(
            Audio('assets/music/b2.wav'),
            autoStart: true,
            showNotification: true,
          )
              .then((value) {
            int next_index = widget.lesson_index + 1;
            // If there is any Lesson it will forward to it
            if (next_index < widget.list_of_lessons!.length) {
              Lesson lesson = widget.list_of_lessons![next_index];
              Lesson().getById(lesson.id, preload: true).then((value) async {
                Navigator.of(context)
                    .popUntil((route) => route.isFirst); // await Get.to
                await Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (BuildContext context) {
                      return CupertinoPageScaffold(
                          child: CustomCardPage(
                              lesson: value!,
                              list_of_lessons: widget.list_of_lessons!,
                              lesson_index: widget.lesson_index + 1,
                              auto_open_first: true,
                              radioSelected:
                                  prefs.getInt(Preference.reviewRadioOption) ??
                                      0,
                              isEditable: widget.isEditable));
                    },
                  ),
                );
                // await Get.offUntil(
                //     GetPageRoute(
                //         page: () => CustomCardPage(
                //               lesson: value!,
                //               list_of_lessons: widget.list_of_lessons!,
                //               lesson_index: widget.lesson_index + 1,
                //               auto_open_first: true,
                //               radioSelected:
                //                   prefs.getInt(Preference.reviewRadioOption) ??
                //                       0,
                //             )),
                //     );
              });
            }
            // If the book is ended and there is no lessons, Show Snackbar
            else {
              Get.back();
              // Get.snackbar('warning'.tr, 'card_end_message'.tr);
            }
          });
        });
      });
    }
  }

  void buildGlobalKeys() {
    for (int i = 0; i < widget.cards.length; i++) {
      GlobalKey<ControlButtonsOldState> questionControlBtnKey =
          GlobalKey<ControlButtonsOldState>();
      GlobalKey<ControlButtonsOldState> replyControlBtnKey =
          GlobalKey<ControlButtonsOldState>();
      GlobalKey<ControlButtonsOldState> descriptionControlBtnKey =
          GlobalKey<ControlButtonsOldState>();

      questionControlBtnKeys.add(questionControlBtnKey);
      replyControlBtnKeys.add(replyControlBtnKey);
      descriptionControlBtnKeys.add(descriptionControlBtnKey);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String text = replyController.document.toPlainText().toLowerCase();
    _cardsController.check(input: txtReply.text, strAnswer: text);
    _cardsController.showAnswer(false);
    var tt = qu.DefaultStyles.getInstance(context);
    var temp = qu.DefaultStyles.getInstance(context).merge(qu.DefaultStyles(
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
        strikeThrough: const TextStyle(decoration: TextDecoration.lineThrough),
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
        placeHolder: qu.DefaultTextBlockStyle(themeContoller.mainContentStyle,
            tt.paragraph!.lineSpacing, tt.paragraph!.verticalSpacing, null),
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
    // TODO change this shit
    // tts.stop();
    // tts_answer.stop();
    // if (!_cardsController.isSpellCheck.value &&
    //     !_tabController!.indexIsChanging &&
    //     widget.autoplaySpell &&
    //     ((widget.cards[selectedindex!].questionVoicePath?.isEmpty ?? true) ||
    //         (widget.cards[selectedindex!].replyVoicePath?.isEmpty ?? true))) {
    //   String language = getLangForTTS(
    //       widget.currentCard.plLesson?.plSubGroup?.languageItemOne ?? 0);
    //   tts.setLanguage(language);
    //   var ttsfuture = Future.delayed(Duration(seconds: 1)).then((value) async {
    //     if (widget.autoplaySpell &&
    //         (widget.cards[selectedindex!].questionVoicePath?.isEmpty ?? true)) {
    //       String language = getLangForTTS(
    //           widget.currentCard.plLesson?.plSubGroup?.languageItemOne ?? 0);
    //       await tts.setLanguage(language);
    //       await tts
    //           .speak(questionController.document.toPlainText())
    //           .whenComplete(() {
    //         if (widget.autoplaySpell &&
    //             (widget.cards[selectedindex!].replyVoicePath?.isEmpty ??
    //                 true)) {
    //           SharedPreferences.getInstance().then((prefs) async {
    //             String language = getLangForTTS(
    //                 widget.currentCard.plLesson?.plSubGroup?.languageItemTwo ??
    //                     0);
    //             await tts_answer.setLanguage(language);
    //             await Future.delayed(Duration(seconds: 1));
    //             for (double i = 0;
    //                 i < widget.numberOfPlayAnswer &&
    //                     !(ttsCanceler?.isCanceled ?? false);
    //                 i++) {
    //               await tts_answer
    //                   .speak(replyController.document.toPlainText());
    //               // await tts.speak(replyController.document.toPlainText());
    //             }
    //           });
    //           goToNextSlide();
    //         }
    //       });
    //       await SharedPreferences.getInstance().then((prefs) async {
    //         await Future.delayed(Duration(seconds: 1));
    //       });
    //     }
    //     if (widget.cards[selectedindex!].descriptionVoicePath!.isNotEmpty &&
    //         autoPlay &&
    //         autoPlayDescription) {
    //       descriptionControlBtnKeys[selectedindex!].currentState?.player.play();
    //     } else if (widget.cards[selectedindex!].descriptionVoicePath!.isEmpty ||
    //         autoSlide ||
    //         (autoMergeLessons && selectedindex! == widget.cards.length - 1)) {}
    //   });
    //   ttsCanceler = CancelableOperation.fromFuture(
    //     ttsfuture,
    //     onCancel: () {
    //       tts.stop();
    //       print('canelled');
    //     },
    //   );
    // }
    int index = -1;
    // if (widget.autoSliding &&
    //     !_tabController!.indexIsChanging &&
    //     ((widget.cards[selectedindex!].questionVoicePath?.isEmpty ?? false) &&
    //         (widget.cards[selectedindex!].replyVoicePath?.isEmpty ?? false))) {
    //   Future.delayed(Duration(seconds: 2)).then((v) {
    //     goToNextSlide();
    //   });
    // }
    // questionControlBtnKeys.clear();

    return Scaffold(
      floatingActionButton: StreamBuilder<int>(
          stream: floadActionBtnStream.stream,
          builder: (context, card_page_index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  if (_cardsController.allSpellCheck.value ||
                      _cardsController.hasCardSpellCheck.value &&
                          _cardsController.isSpellCheck.value &&
                          !_cardsController.showAnswer.value) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 30),
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
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                padding: EdgeInsets.only(left: 8.0, right: 8),
                                backgroundColor: Get.theme.primaryColor,
                              ),
                              child: Text("Check",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white)),
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
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                // padding: EdgeInsets.only(left: 8.0, right: 8),
                                backgroundColor: Get.theme.primaryColor,
                              ),
                              child: Text("Help",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white)),
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
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 8.0, right: 8),
                                      backgroundColor: Get.theme.primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text("Hold to Show",
                                        style: TextStyle(fontSize: 15)),
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
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 30.0,
                            width: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                String text = replyController.document
                                    .toPlainText()
                                    .toLowerCase();
                                _cardsController.showAnswer(true);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                padding: EdgeInsets.only(left: 8.0, right: 8),
                                backgroundColor: Get.theme.primaryColor,
                              ),
                              child: Center(
                                  child: Text("Pass",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white))),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else
                    return Container();
                }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (card_page_index.data == 0 && widget.lesson_index != 0)
                        ? Container(
                            child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 10),
                                height: 30.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(
                                      // left: 10.0,
                                      right: 10.0,
                                    ),
                                    backgroundColor: Get.theme.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Lesson lesson = widget.list_of_lessons![
                                        widget.lesson_index - 1];
                                    Lesson()
                                        .getById(lesson.id, preload: true)
                                        .then((value) async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      // await Get.to
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      await Navigator.of(context).push(
                                        CupertinoPageRoute<void>(
                                          builder: (BuildContext context) {
                                            return CupertinoPageScaffold(
                                                resizeToAvoidBottomInset: true,
                                                child: CustomCardPage(
                                                    lesson: value!,
                                                    list_of_lessons:
                                                        widget.list_of_lessons!,
                                                    lesson_index:
                                                        widget.lesson_index - 1,
                                                    auto_open_first: true,
                                                    cardIndex: -1,
                                                    radioSelected: prefs.getInt(
                                                            Preference
                                                                .reviewRadioOption) ??
                                                        0,
                                                    isEditable:
                                                        widget.isEditable));
                                          },
                                        ),
                                      );
                                      // await Get.offUntil(
                                      //     GetPageRoute(
                                      //         page: () => CustomCardPage(
                                      //               lesson: value!,
                                      //               list_of_lessons:
                                      //                   widget.list_of_lessons!,
                                      //               lesson_index:
                                      //                   widget.lesson_index - 1,
                                      //               auto_open_first: true,
                                      //               cardIndex: -1,
                                      //               radioSelected: prefs.getInt(
                                      //                       Preference
                                      //                           .reviewRadioOption) ??
                                      //                   0,
                                      //             )),
                                      //     );
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.navigate_before_rounded),
                                      Text("Previous Lesson",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ))
                        : Container(),
                    (card_page_index.data == widget.cards.length - 1 &&
                            widget.lesson_index !=
                                widget.list_of_lessons!.length - 1)
                        ? Container(
                            child: Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                height: 30.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 10.0,
                                      // right: 10.0,
                                    ),
                                    backgroundColor: Get.theme.primaryColor,
                                  ),
                                  onPressed: () {
                                    _cardsController.showAnswer(false);
                                    Lesson lesson = widget.list_of_lessons![
                                        widget.lesson_index + 1];
                                    Lesson()
                                        .getById(lesson.id, preload: true)
                                        .then((value) async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      // await Get.to
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      await Navigator.of(context).push(
                                        CupertinoPageRoute<void>(
                                          builder: (BuildContext context) {
                                            return CupertinoPageScaffold(
                                                resizeToAvoidBottomInset: true,
                                                child: CustomCardPage(
                                                    lesson: value!,
                                                    list_of_lessons:
                                                        widget.list_of_lessons!,
                                                    lesson_index:
                                                        widget.lesson_index + 1,
                                                    auto_open_first: true,
                                                    cardIndex: 0,
                                                    radioSelected: prefs.getInt(
                                                            Preference
                                                                .reviewRadioOption) ??
                                                        0,
                                                    isEditable:
                                                        widget.isEditable));
                                          },
                                        ),
                                      );
                                      //   await Get.offUntil(
                                      //       GetPageRoute(
                                      //           page: () => CustomCardPage(
                                      //                 lesson: value!,
                                      //                 list_of_lessons:
                                      //                     widget.list_of_lessons!,
                                      //                 lesson_index:
                                      //                     widget.lesson_index + 1,
                                      //                 auto_open_first: true,
                                      //                 cardIndex: 0,
                                      //                 radioSelected: prefs.getInt(
                                      //                         Preference
                                      //                             .reviewRadioOption) ??
                                      //                     0,
                                      //               )),
                                      //       );
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text("Next Lesson",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                      Icon(Icons.navigate_next_rounded),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ))
                        : Container()
                  ],
                ),
              ],
            );
          }),
      body: SafeArea(
        child: Column(
          children: [
            app_Bar(
              title_text: ((widget.list_of_lessons != null)
                      ? '${widget.lesson_index + 1}/${widget.list_of_lessons?.length} - '
                      : '') +
                  ((widget.lesson.title != null)
                      ? widget.currentCard.plLesson!.title!
                      : 'cards'.tr),
              canGoBack: true,
              // 'cards'.tr,
            ),
            appBarOptions(),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: controller,
                      children: widget.cards.map((e) {
                        index++;

                        final quesPlayer = ControlButtonsOld(
                          otherControls: [
                            replyControlBtnKeys[index],
                            descriptionControlBtnKeys[index]
                          ],
                          speedController: questionReviewSpeedController,
                          musicEndCallBack: playReplyAuto,
                          indexCallBackTrigger: "q" + e.id.toString(),
                          key: questionControlBtnKeys[index],
                          path: e.questionVoicePath,
                          howManyTimePlayStream: _howManyTimePlayQuestionStream,
                          streamCaller: (value) {
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setDouble(
                                  Preference.numberOfPlayQuestion, value);
                            });
                            _howManyTimePlayQuestionStream.add(value);
                            widget.numberOfPlayQuestion = value;
                          },
                        );
                        final replyPlayer = ControlButtonsOld(
                          show_hint_key: _15_how_many_play,
                          otherControls: [
                            questionControlBtnKeys[index],
                            descriptionControlBtnKeys[index]
                          ],
                          speedController: replyReviewSpeedController,
                          musicEndCallBack: playReplyAuto,
                          indexCallBackTrigger: e.id.toString() + "r",
                          key: replyControlBtnKeys[index],
                          path: e.replyVoicePath,
                          howManyTimePlayStream: _howManyTimePlayAnswerStream,
                          streamCaller: (value) {
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setDouble(
                                  Preference.numberOfPlayAnswer, value);
                            });
                            _howManyTimePlayAnswerStream.add(value);
                            widget.numberOfPlayAnswer = value;
                          },
                        );
                        final descPlayer = ControlButtonsOld(
                            otherControls: [
                              replyControlBtnKeys[index],
                              questionControlBtnKeys[index]
                            ],
                            speedController: descriptionReviewSpeedController,
                            musicEndCallBack: playDecriptionAuto,
                            indexCallBackTrigger: e.id.toString() + "d",
                            key: descriptionControlBtnKeys[index],
                            path: e.descriptionVoicePath);
                        return Center(
                          child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              //padding: EdgeInsets.all(25),
                              // margin: EdgeInsets.only(
                              //     bottom: 90, right: 5, left: 5, top: 0),
                              child: ListView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 12, left: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15),
                                        Text("Question",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff353535))),
                                        SizedBox(height: 12),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 100,
                                                    spreadRadius: 1)
                                              ]),
                                          // height: 102,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        TwoStateWidget(
                                                          playingImage:
                                                              "assets/images/volume-high.png",
                                                          stoppedImage:
                                                              "assets/images/volume-slash.png",
                                                          onEnable: (bool
                                                              value) async {
                                                            String language =
                                                                getLangForTTS(e
                                                                        .plLesson
                                                                        ?.plSubGroup
                                                                        ?.languageItemOne ??
                                                                    0);
                                                            tts.setLanguage(
                                                                language);
                                                            String text =
                                                                questionController
                                                                    .document
                                                                    .toPlainText();
                                                            await tts
                                                                .speak(text);
                                                          },
                                                          onDisable: (bool
                                                              value) async {
                                                            await tts.stop();
                                                          },
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              String text =
                                                                  questionController
                                                                      .document
                                                                      .toPlainText();
                                                              translationDialog(
                                                                  text);
                                                            },
                                                            icon: Icon(Icons
                                                                .translate_rounded))
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child: StreamBuilder(
                                                        stream:
                                                            questionTxtChangeStream
                                                                .stream,
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                          // return Text(
                                                          //     questionController.toString,
                                                          //     style: themeContoller
                                                          //         .mainContentStyle);
                                                          return qu.QuillEditor(
                                                            controller:
                                                                questionController,
                                                            readOnly:
                                                                true, // true for view only mode
                                                            autoFocus: true,
                                                            scrollController:
                                                                ScrollController(),
                                                            expands: false,
                                                            focusNode:
                                                                FocusNode(),
                                                            scrollable: false,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0,
                                                                    right: 0),
                                                            customStyles: temp,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (e.questionVoicePath !=
                                                        null &&
                                                    e.questionVoicePath!
                                                        .isNotEmpty)
                                                  quesPlayer,
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Obx(() {
                                          if (_cardsController
                                                  .allSpellCheck.value ||
                                              _cardsController.hasCardSpellCheck
                                                      .value &&
                                                  _cardsController
                                                      .isSpellCheck.value &&
                                                  !_cardsController
                                                      .showAnswer.value) {
                                            return Column(children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Card(
                                                    color: themeContoller
                                                        .themeData
                                                        .value
                                                        .splashColor,
                                                    elevation: 0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 8.0,
                                                        top: 8.0,
                                                        bottom: 8.0,
                                                      ),
                                                      child: Center(
                                                          child:
                                                              _cardsController
                                                                  .textWidget
                                                                  .value),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 15),
                                                    child: TextFormField(
                                                      enabled: true,
                                                      controller: txtReply,
                                                      autocorrect: false,
                                                      enableSuggestions: false,
                                                      autofocus: false,
                                                      onChanged: (value) {
                                                        String text =
                                                            replyController
                                                                .document
                                                                .toPlainText()
                                                                .toLowerCase();

                                                        // _cardsController
                                                        //     .tempSpallCheck(value);
                                                        _cardsController.check(
                                                            input: value,
                                                            strAnswer: text);
                                                      },
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: 2,
                                                      minLines: 1,
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Enter Your Reply'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]);
                                          } else {
                                            return Container();
                                          }
                                        }),
                                        Container(child: Obx(() {
                                          if (!_cardsController
                                                      .allSpellCheck.value &&
                                                  !_cardsController
                                                      .hasCardSpellCheck
                                                      .value ||
                                              !_cardsController
                                                  .isSpellCheck.value ||
                                              _cardsController
                                                  .showAnswer.value) {
                                            return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Answer",
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                              0xff353535))),
                                                  SizedBox(height: 12),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              blurRadius: 100,
                                                              spreadRadius: 1)
                                                        ]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  TwoStateWidget(
                                                                    playingImage:
                                                                        "assets/images/volume-high.png",
                                                                    stoppedImage:
                                                                        "assets/images/volume-slash.png",
                                                                    onEnable: (bool
                                                                        value) async {
                                                                      String
                                                                          language =
                                                                          getLangForTTS(e.plLesson?.plSubGroup?.languageItemTwo ??
                                                                              0);
                                                                      tts.setLanguage(
                                                                          language);
                                                                      String
                                                                          text =
                                                                          replyController
                                                                              .document
                                                                              .toPlainText();
                                                                      await tts
                                                                          .speak(
                                                                              text);
                                                                    },
                                                                    onDisable: (bool
                                                                        value) async {
                                                                      await tts
                                                                          .stop();
                                                                    },
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        String
                                                                            text =
                                                                            replyController.document.toPlainText();
                                                                        translationDialog(
                                                                            text);
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .translate_rounded))
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child: StreamBuilder<
                                                                          Object>(
                                                                      stream: replyTxtChangeStream
                                                                          .stream,
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        return qu
                                                                            .QuillEditor(
                                                                          controller:
                                                                              replyController,
                                                                          readOnly:
                                                                              true, // true for view only mode
                                                                          autoFocus:
                                                                              true,
                                                                          scrollController:
                                                                              ScrollController(),
                                                                          expands:
                                                                              false,
                                                                          focusNode:
                                                                              FocusNode(),
                                                                          scrollable:
                                                                              false,
                                                                          padding: EdgeInsets.only(
                                                                              left: 0,
                                                                              right: 0),
                                                                          customStyles:
                                                                              temp,
                                                                        );
                                                                      }),
                                                                ),
                                                              )
                                                              // Text("فرودگاه",
                                                              //     textDirection:
                                                              //         TextDirection
                                                              //             .rtl,
                                                              //     style: TextStyle(
                                                              //         fontFamily:
                                                              //             "Poppins",
                                                              //         fontSize: 14,
                                                              //         fontWeight:
                                                              //             FontWeight
                                                              //                 .w500,
                                                              //         color: Color(
                                                              //             0xff353535))),
                                                            ],
                                                          ),
                                                          if (e.replyVoicePath !=
                                                                  null &&
                                                              e.replyVoicePath!
                                                                  .isNotEmpty)
                                                            replyPlayer
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                  Text("Description",
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                              0xff353535))),
                                                  SizedBox(height: 12),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              blurRadius: 100,
                                                              spreadRadius: 1)
                                                        ]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  TwoStateWidget(
                                                                    playingImage:
                                                                        "assets/images/volume-high.png",
                                                                    stoppedImage:
                                                                        "assets/images/volume-slash.png",
                                                                    onEnable: (bool
                                                                        value) async {
                                                                      String
                                                                          language =
                                                                          getLangForTTS(e.plLesson?.plSubGroup?.languageItemThree ??
                                                                              0);
                                                                      tts.setLanguage(
                                                                          language);
                                                                      String
                                                                          text =
                                                                          descController
                                                                              .document
                                                                              .toPlainText();
                                                                      await tts
                                                                          .speak(
                                                                              text);
                                                                    },
                                                                    onDisable: (bool
                                                                        value) async {
                                                                      await tts
                                                                          .stop();
                                                                    },
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        String
                                                                            text =
                                                                            descController.document.toPlainText();
                                                                        translationDialog(
                                                                            text);
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .translate_rounded))
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                      ListTile(
                                                                title:
                                                                    StreamBuilder(
                                                                  stream:
                                                                      descTxtChangeStream
                                                                          .stream,
                                                                  builder: (BuildContext
                                                                          context,
                                                                      AsyncSnapshot
                                                                          snapshot) {
                                                                    return Text(
                                                                        descController
                                                                            .document
                                                                            .toPlainText(),
                                                                        // questionController.toString,
                                                                        style: themeContoller
                                                                            .mainContentStyle);
                                                                    return Container(
                                                                      child: qu
                                                                          .QuillEditor(
                                                                        controller:
                                                                            descController,
                                                                        readOnly:
                                                                            true, // true for view only mode
                                                                        autoFocus:
                                                                            true,
                                                                        scrollController:
                                                                            ScrollController(),
                                                                        expands:
                                                                            false,
                                                                        focusNode:
                                                                            FocusNode(),
                                                                        scrollable:
                                                                            false,
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                0,
                                                                            right:
                                                                                0),
                                                                        customStyles:
                                                                            temp,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ))
                                                              // Text(
                                                              //     "محل عبور و مرور هواپیماها",
                                                              //     textDirection:
                                                              //         TextDirection
                                                              //             .rtl,
                                                              //     style: TextStyle(
                                                              //         fontFamily:
                                                              //             "Poppins",
                                                              //         fontSize: 14,
                                                              //         fontWeight:
                                                              //             FontWeight
                                                              //                 .w500,
                                                              //         color: Color(
                                                              //             0xff353535))),
                                                            ],
                                                          ),
                                                          if (e.descriptionVoicePath !=
                                                                  null &&
                                                              e.descriptionVoicePath!
                                                                  .isNotEmpty)
                                                            descPlayer
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                  SizedBox(height: 15),
                                                  Center(
                                                    child: StreamBuilder<bool>(
                                                      stream: showImageStream
                                                          .stream,
                                                      initialData:
                                                          showImageStream.value,
                                                      builder:
                                                          (context, snapshot) {
                                                        if ((snapshot.hasData &&
                                                            snapshot.data! &&
                                                            (widget
                                                                        .cards[
                                                                            selectedindex!]
                                                                        .imagePath !=
                                                                    null &&
                                                                widget
                                                                    .cards[
                                                                        selectedindex!]
                                                                    .imagePath!
                                                                    .isNotEmpty))) {
                                                          return Column(
                                                            children: [
                                                              Text("Image",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff353535))),
                                                              ClipRRect(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                                child: Image.file(
                                                                    File(widget
                                                                        .cards[
                                                                            selectedindex!]
                                                                        .imagePath!),
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                  VoiceRecordViewPage(
                                                      // show_hint_key:
                                                      //     _13_record_voice,
                                                      disableSdCard: true,
                                                      voiceEditingController:
                                                          voiceEditingController),
                                                  SizedBox(height: 15),
                                                ]);
                                          }
                                          return Container();
                                        }))
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        iknowBtn(),
                        SizedBox(height: 5),
                        Center(
                          child: Text(
                            "Or",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        ),
                        SizedBox(height: 5),
                        transferCardBtn(),
                        SizedBox(height: 5),
                        StreamBuilder<int>(
                            stream: indicatorController.stream,
                            builder: (context, snapshot) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                  left: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    ((widget.list_of_lessons != null)
                                        ? '${selectedindex! + 1}/${widget.cards.length}'
                                        : ''),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transferCardBtn() {
    return StreamBuilder<bool>(
        initialData: widget.cards[selectedindex!].reviewStart,
        stream: addCardReviewStream.stream,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(right: 8, left: 8.0),
            child: SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: snapshot.data! == true
                        ? Color.fromARGB(255, 108, 108, 108)
                        : Color(0xff27187E), //background color of button
                    // side: BorderSide(
                    //     width: 3,
                    //     color: Colors.brown), //border width and color
                    elevation: 3, //elevation of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.all(15) //content padding inside button
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.save),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Text(
                      "Send to review".tr,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                // snapshot.data! == true
                // ? null
                // :
                onPressed: () async {
                  if (snapshot.data == true) {
                    bool currentValue = !snapshot.data!;
                    addCardReviewStream.sink.add(currentValue);
                    widget.cards[selectedindex!].reviewStart = currentValue;
                    await widget.cards[selectedindex!].save();
                    cardsController.rebind();
                  } else if (snapshot.data == false) {
                    // Review is started
                    bool currentValue = !snapshot.data!;
                    addCardReviewStream.sink.add(currentValue);
                    widget.cards[selectedindex!].reviewStart = currentValue;
                    await widget.cards[selectedindex!].save();
                    cardsController.rebind();
                  }
                },
              ),
            ),
          );
        });
  }

  Widget iknowBtn() {
    return StreamBuilder<bool>(
        stream: iKnowStream.stream,
        initialData: widget.cards[selectedindex!].examDone,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(right: 8, left: 8.0),
            child: SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: snapshot.data! == true
                        ? Color.fromARGB(255, 108, 108, 108)
                        : Color(0xff27187E), //background color of button
                    // side: BorderSide(
                    //     width: 3,
                    //     color: Colors.brown), //border width and color
                    elevation: 3, //elevation of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.all(15) //content padding inside button
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.save),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Text(
                      "I know".tr,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                onPressed: () async {
                  if (snapshot.data == true) {
                    // I Don't Know
                    bool currentValue = !snapshot.data!;
                    iKnowStream.sink.add(currentValue);
                    widget.cards[selectedindex!].examDone = currentValue;
                    widget.cards[selectedindex!].boxNumber = 0;
                    await widget.cards[selectedindex!].save();
                    cardsController.rebind();
                  } else if (snapshot.data == false) {
                    // I Know
                    bool currentValue = !snapshot.data!;
                    iKnowStream.sink.add(currentValue);
                    widget.cards[selectedindex!].examDone = currentValue;
                    widget.cards[selectedindex!].boxNumber =
                        widget.lesson.plSubGroup?.boxCount;

                    await widget.cards[selectedindex!].save();
                    cardsController.rebind();
                  }
                },
              ),
            ),
          );
        });
  }

  // StreamBuilder<bool> QuesReplyDescBuilder(
  //     Stream<bool> stream, qu.QuillController controller) {
  //   return
  // }

  Padding appBarOptions() {
    const double switchScaler = .8;
    final _scroll_controller = ScrollController();

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      // padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SingleChildScrollView(
            controller: _scroll_controller,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Showcase(
                  key: _2_sliding,
                  description: 'It automatically shows you the next flashcard',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomSwitch(
                              clr: Color(0xff27187E),
                              imgPath: 'assets/images/edit-icon.png',
                              text1: 'Edit Card',
                              scale: .14,
                              isPushBtn: true,
                              isEnabled: true,
                              onChanged: (value) async {
                                await Get.to(
                                    TblCardAdd(widget.cards[selectedindex!]));
                                await _cardsController.rebind();
                                controller!.notifyListeners();
                                setState(() {});
                              }),
                        ),
                        StreamBuilder(
                          stream: autoSlidingStream.stream,
                          initialData: widget.autoSliding,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return CustomSwitch(
                                scale: .14,
                                clr: Color(0xff27187E),
                                imgPath: "assets/images/auto-next-icon.png",
                                text1: "Auto next flashcard",
                                value: snapshot.data,
                                onChanged: ((value) {
                                  autoSlidingStream.sink.add(value);
                                  widget.cards[selectedindex!].reviewStart =
                                      value;
                                  autoSlide = value;
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setBool(
                                        Preference.autoSliding, value);
                                    //  // });
                                  });
                                }));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Showcase(
                  key: _3_auto_play,
                  description: 'Plays the flashcard as soon as it enters',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        // Text(
                        //   'Auto Play',
                        //   style: themeContoller
                        //       .themeData.value.textTheme.bodyText1!
                        //       .copyWith(color: Colors.white, fontSize: 12.0),
                        // ),
                        StreamBuilder(
                          stream: autoplayStream.stream,
                          initialData: widget.autoPlay,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return CustomSwitch(
                                scale: .14,
                                clr: Color(0xff27187E),
                                imgPath: "assets/images/musicnote-icon.png",
                                text1: "Auto play",
                                value: snapshot.data,
                                onChanged: ((value) {
                                  autoplayStream.sink.add(value);
                                  autoPlay = value;
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setBool(
                                        Preference.autoPlayTraining, value);
                                  });
                                }));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Showcase(
                  key: _8_merge_lesson,
                  description:
                      'Automatically moves to the next lesson after finishing this lesson',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        // Text(
                        //   'Merge Lessons',
                        //   style: themeContoller
                        //       .themeData.value.textTheme.bodyText1!
                        //       .copyWith(color: Colors.white, fontSize: 12.0),
                        // ),
                        StreamBuilder(
                          stream: autoMergeLessonsStream.stream,
                          initialData: widget.mergeLessons,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return CustomSwitch(
                                scale: .14,
                                clr: Color(0xff27187E),
                                imgPath: "assets/images/format-circle.png",
                                text1: "Auto next lesson",
                                value: snapshot.data,
                                onChanged: ((value) {
                                  autoMergeLessonsStream.sink.add(value);
                                  autoMergeLessons = value;
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setBool(
                                        Preference.mergeLessons, value);
                                  });
                                }));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Showcase(
                  key: _4_play_dis,
                  description: 'plays the description to you',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        // Text(
                        //   'Play Description',
                        //   style: themeContoller
                        //       .themeData.value.textTheme.bodyText1!
                        //       .copyWith(color: Colors.white, fontSize: 12.0),
                        // ),
                        StreamBuilder(
                          stream: autoPlayDesciptionStream.stream,
                          initialData: widget.autoPlayDescription,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            return CustomSwitch(
                                scale: .14,
                                clr: Color(0xff27187E),
                                imgPath: "assets/images/musicnote-icon.png",
                                text1: "Play decription",
                                value: snapshot.data,
                                onChanged: ((value) {
                                  autoPlayDesciptionStream.sink.add(value);
                                  autoPlayDescription = value;
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setBool(
                                        Preference.autoPlayDescription, value);
                                  });
                                }));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        Get.dialog(
                          otherDialog(),
                          barrierColor: Colors.transparent,
                        );
                      },
                      child: headerButtons(
                          containerbgcolor: Color(0xffF1F2F6),
                          clr: Color(0xff27187E),
                          img_path: "assets/images/menu.png",
                          txt1: "Others",
                          txt2: "")),
                ),

                // Showcase(
                //   key: _7_tts,
                //   description:
                //       'If flashcard doesn\'t exist, its voice will be generate and play',
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 8.0),
                //     child: Row(
                //       children: [
                //         Text(
                //           'Auto Play If Audio Isn\'t Avalable',
                //           style: themeContoller
                //               .themeData.value.textTheme.bodyText1!
                //               .copyWith(color: Colors.white, fontSize: 12.0),
                //         ),
                //         Obx(() {
                //           return Container(
                //             child: Transform.scale(
                //               scale: switchScaler,
                //               child: CupertinoSwitch(
                //                 value: _cardsController.autoplaySpell.value,
                //                 onChanged: (value) {
                //                   _cardsController.autoplaySpell(value);
                //                   SharedPreferences.getInstance().then((prefs) {
                //                     prefs.setBool(
                //                         Preference.autoplaySpell, value);
                //                     widget.autoplaySpell = value;
                //                     // if (value == false) {
                //                     //   _cardsController.allSpellCheck(value);
                //                     //   prefs.setBool(Preference.allSpellCheck, value);
                //                     // }
                //                   });
                //                 },
                //               ),
                //             ),
                //           );
                //         }),
                //       ],
                //     ),
                //   ),
                // ),
                // Showcase(
                //   overlayPadding: const EdgeInsets.all(1),
                //   key: _16_website,
                //   description: 'Tap to visit the website and see more hints',
                //   child: GestureDetector(
                //     onTap: () async {
                //       // var x = await .getById(2);

                //       final _url = 'https://mojiapplication.com/FastLearning';
                //       if (!await launch(_url)) {
                //         throw 'Could not launch $_url';
                //       }
                //     },
                //     child: Text("Help"),
                //     // child: Icon(
                //     //   Icons.lightbulb_outline_sharp,
                //     //   color: Colors.white,
                //     // ),
                //   ),
                // ),
                // IconButton(
                // icon: Icon(Icons.help_sharp),
                // onPressed: () {
                // SharedPreferences.getInstance().then((prefs) {
                //   prefs.setBool(
                //       Preference.show_hint_flashcard_page,
                //       !(prefs.getBool(
                //               Preference.show_hint_flashcard_page) ??
                //           true));

                //   if (!(prefs
                //           .getBool(Preference.show_hint_flashcard_page) ??
                //       true)) {}
                // });
                // (WidgetsBinding.instance).addPostFrameCallback(
                //   (_) =>
                //       ShowCaseWidget.of(context).startShowCase(_hint_list),
                // );
                // },
                // ),
              ],
            ),
          ),
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       Showcase(
          //         key: _11_i_know,
          //         description:
          //             'You confirm that you completely learn the word and don\'t see it in review part',
          //         child: StreamBuilder(
          //           stream: iKnowStream.stream,
          //           initialData: false,
          //           builder: (BuildContext context, AsyncSnapshot snapshot) {
          //             return Row(
          //               children: [
          //                 InkWell(
          //                   onTap: () async {
          //                     if (snapshot.data == false) {
          //                       bool currentValue = !snapshot.data;
          //                       iKnowStream.sink.add(currentValue);
          //                       widget.cards[selectedindex!].examDone =
          //                           currentValue;
          //                       await widget.cards[selectedindex!].save();
          //                       cardsController.rebind();
          //                     }
          //                   },
          //                   child: Container(
          //                     padding: EdgeInsets.only(
          //                         top: 5, bottom: 5, right: 8, left: 8),
          //                     decoration: BoxDecoration(
          //                         color: snapshot.data == true
          //                             ? Colors.grey
          //                             : Colors.green,
          //                         borderRadius: BorderRadius.circular(10)),
          //                     child: Center(child: Text('I know')),
          //                   ),
          //                 ),
          //                 Container(
          //                   child: Transform.scale(
          //                     scale: 1,
          //                     child: Checkbox(
          //                         value: snapshot.data,
          //                         onChanged: (value) async {
          //                           if (snapshot.data == true) {
          //                             bool currentValue = !snapshot.data;
          //                             iKnowStream.sink.add(currentValue);
          //                             widget.cards[selectedindex!].examDone =
          //                                 currentValue;
          //                             await widget.cards[selectedindex!].save();
          //                             cardsController.rebind();
          //                           }
          //                         }),
          //                   ),
          //                 ),
          //               ],
          //             );
          //           },
          //         ),
          //       ),
          //       Showcase(
          //         key: _12_send_to_review,
          //         description:
          //             'Flashcards moves to the review part and will be asked in different timespans, if you want to the app ask you about a flashcard, you can turn on this option and move the word to you long term memory',
          //         child: StreamBuilder(
          //           stream: addCardReviewStream.stream,
          //           initialData: false,
          //           builder: (BuildContext context, AsyncSnapshot snapshot) {
          //             return Row(
          //               children: [
          //                 InkWell(
          //                   onTap: () async {
          //                     if (snapshot.data == false) {
          //                       bool currentValue = !snapshot.data;
          //                       addCardReviewStream.sink.add(currentValue);
          //                       widget.cards[selectedindex!].reviewStart =
          //                           currentValue;
          //                       await widget.cards[selectedindex!].save();
          //                       cardsController.rebind();
          //                     }
          //                   },
          //                   child: Container(
          //                     padding: EdgeInsets.only(
          //                         top: 5, bottom: 5, right: 8, left: 8),
          //                     decoration: BoxDecoration(
          //                         color: snapshot.data == true
          //                             ? Colors.grey
          //                             : Colors.green,
          //                         borderRadius: BorderRadius.circular(10)),
          //                     child: Center(child: Text('Send to review')),
          //                   ),
          //                 ),
          //                 Container(
          //                   child: Transform.scale(
          //                     scale: 1,
          //                     child: Checkbox(
          //                         value: snapshot.data,
          //                         onChanged: (value) async {
          //                           if (snapshot.data == true) {
          //                             bool currentValue = !snapshot.data;
          //                             addCardReviewStream.sink.add(currentValue);
          //                             widget.cards[selectedindex!].reviewStart =
          //                                 currentValue;
          //                             await widget.cards[selectedindex!].save();
          //                             cardsController.rebind();
          //                           }
          //                         }),
          //                   ),
          //                 ),
          //               ],
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   )
        ],
      ),
    );
  }

  Widget otherDialog() {
    return Padding(
      padding: const EdgeInsets.only(top: 160),
      child: AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            side: BorderSide(color: Color(0xff353535), width: 1)),
        insetPadding: EdgeInsets.all(12),
        backgroundColor: Color(0xffF1F2F6),
        content: Container(
          height: 350,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: StreamBuilder(
                        stream: showImageStream.stream.asBroadcastStream(),
                        initialData: showImageStream.value,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return CustomSwitch(
                              value: snapshot.data,
                              clr: Color(0xff27187E),
                              imgPath: "assets/images/note-2.png",
                              text1: "Show image",
                              onChanged: ((value) {
                                showImageStream.sink.add(value);
                                showImage = value;
                                // autoPlay = value;
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setBool(Preference.showImage, value);
                                  // });
                                });
                              }));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(() {
                        return CustomSwitch(
                            value: _cardsController.isSpellCheck.value,
                            clr: Color(0xff27187E),
                            imgPath: "assets/images/smallcaps.png",
                            text1: "Show spell check",
                            onChanged: ((value) {
                              _cardsController.isSpellCheck(value);
                              SharedPreferences.getInstance().then((prefs) {
                                prefs.setBool(Preference.hasSpellCheck, value);
                                if (value == false) {
                                  _cardsController.allSpellCheck(value);
                                  prefs.setBool(
                                      Preference.allSpellCheck, value);
                                }
                              });
                            }));
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(() {
                        return _cardsController.isSpellCheck.value
                            ? CustomSwitch(
                                value: _cardsController.allSpellCheck.value,
                                clr: Color.fromARGB(255, 24, 15, 75),
                                imgPath: "assets/images/smallcaps.png",
                                text1: "Spell Check For All",
                                onChanged: ((value) {
                                  _cardsController.allSpellCheck(value);
                                  // autoPlay = value;
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setBool(
                                        Preference.allSpellCheck, value);
                                    // });
                                  });
                                }))
                            : Container();
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(() {
                        return CustomSwitch(
                            clr: Color.fromARGB(255, 24, 15, 75),
                            imgPath: "assets/images/task.png",
                            text1: "Auto Leitner",
                            value: addLeitnerController.addLeitnerStatus.value,
                            onChanged: (value) async {
                              addLeitnerController.addLeitnerStatus.value =
                                  value;
                            });
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: StreamBuilder(
                        stream: autoKeepAwakeStream.stream,
                        initialData: widget.keepAwake,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return CustomSwitch(
                            value: snapshot.data,
                            clr: Color(0xff27187E),
                            imgPath: "assets/images/devices.png",
                            text1: "Screen Awake",
                            onChanged: (value) {
                              //setState(() {
                              autoKeepAwakeStream.sink.add(value);
                              SharedPreferences.getInstance().then((prefs) {
                                Wakelock.toggle(enable: value);

                                prefs.setBool(Preference.keepAwake, value);
                                // });
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/timer-icon.png",
                      width: 24, height: 24),
                  SizedBox(width: 10),
                  Text(
                    "Set delay to",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff353535),
                        fontFamily: "Poppins"),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Play Answer",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff8A8A8A))),
                  SizedBox(width: 10),
                  sliderWidget(
                      min: 0,
                      max: 20,
                      isInt: true,
                      stream: _autoDelayStream,
                      valueSuffix: 's',
                      onChangeCallStream: (value) {
                        _autoDelayStream.add(value);
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setDouble(Preference.delayToPlayAnswer, value);
                        });
                      },
                      divisions: 20,
                      value: 0),
                  // Expanded(child: Player(audio_url: '')),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Repeat Answer",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff8A8A8A))),
                  SizedBox(width: 10),
                  sliderWidget(
                      // title: "Set delay to repete answer",
                      min: 0,
                      max: 20,
                      isInt: true,
                      stream: _repeteAnswerStream,
                      valueSuffix: 's',
                      onChangeCallStream: (value) {
                        _repeteAnswerStream.add(value);
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setDouble(
                              Preference.autoDelayToRepeteAnswer, value);
                        });
                      },
                      divisions: 20,
                      value: 0),

                  // Expanded(child: Player(audio_url: '')),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Go Next Lesson",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff8A8A8A))),
                  SizedBox(width: 10),
                  sliderWidget(
                      // title: "Set delay to go next lesson",
                      min: 0,
                      max: 20,
                      isInt: true,
                      stream: _nextLessonDelayStream,
                      valueSuffix: 's',
                      onChangeCallStream: (value) {
                        _nextLessonDelayStream.add(value);
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setDouble(
                              Preference.autoDelayToGoNextLesson, value);
                        });
                      },
                      divisions: 20,
                      value: 0),
                  // Expanded(child: Player(audio_url: '')),
                ],
              ),
            ],
          ),
        ),
        alignment: Alignment.topCenter,
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.cards.length; i++) {
      list.add(i == selectedindex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Color(0XFF2FB7B2).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? Color(0XFF6BC4C9) : Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}

void showDelaySliderDialog({
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChangeCallStream,
  String? info,
  bool isInt = false,
}) {
  Get.defaultDialog(
      title: title,
      content: StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) => Container(
                height: 100.0,
                child: Column(
                  children: [
                    Text(
                      isInt
                          ? '${snapshot.data?.toInt()}$valueSuffix'
                          : '${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                      style: TextStyle(
                        fontFamily: 'Fixed',
                        fontWeight: FontWeight.bold,
                      ),
                      // maxFontSize: 10,
                    ),
                    Slider(
                      divisions: divisions,
                      min: min,
                      max: max,
                      value: snapshot.data ?? value,
                      onChanged: onChangeCallStream,
                    ),
                  ],
                ),
              )));
}

Widget sliderWidget({
  String? title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChangeCallStream,
  String? info,
  bool isInt = false,
  bool isRow = false,
}) {
  var children2 = [
    title != null ? Text(title) : Container(),
    StreamBuilder<double>(
        initialData: value,
        stream: stream,
        builder: (context, snapshot) => Row(
              children: [
                Container(
                  width: 150,
                  child: Slider(
                    divisions: divisions,
                    min: min,
                    max: max,
                    value: snapshot.data ?? value,
                    onChanged: onChangeCallStream,
                  ),
                ),
                Container(
                  width: 30,
                  child: Text(
                    isInt
                        ? '${snapshot.data?.toInt()}$valueSuffix'
                        : '${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                    style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                    ),
                    // maxFontSize: 10,
                  ),
                ),
              ],
            )),
  ];
  return isRow
      ? Row(
          children: children2,
        )
      : Column(
          children: children2,
        );
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final bool isEnabled;
  final ValueChanged<bool>? onChanged;
  final Color clr;
  final String? imgPath;
  final String text1;
  final bool isPushBtn;
  final IconData? icon;

  final double scale;

  CustomSwitch({
    Key? key,
    this.value = false,
    this.isEnabled = true,
    this.isPushBtn = false,
    this.onChanged,
    required this.clr,
    this.icon,
    this.imgPath,
    required this.text1,
    this.scale = .17,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.isEnabled
            ? () {
                if (!widget.isPushBtn)
                  setState(() {
                    _value = !_value;
                  });
                if (widget.onChanged != null) widget.onChanged!(_value);
                // print('imdoning something');
              }
            : null,
        child: Container(
          height: 90,
          width: MediaQuery.of(context).size.width * widget.scale,
          decoration: BoxDecoration(
              color: widget.isEnabled
                  ? _value
                      ? Color(0xffAEB8FE)
                      : Colors.transparent
                  : Colors.grey,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: widget.clr)),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.imgPath != null)
                  Image.asset(
                    widget.imgPath!,
                    width: 23,
                    height: 23,
                  ),
                if (widget.icon != null)
                  Icon(
                    widget.icon!,
                    color: widget.clr,
                    size: 23,
                  ),
                SizedBox(height: 7),
                Text(widget.text1,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 11,
                        color: widget.clr,
                        fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ));
  }
}
