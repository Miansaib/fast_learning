import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/tools/export/lesson_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../music.dart';
import '../speed_controller.dart';

class MyAudioSource {
  final AudioSource source;
  final TblCard card;
  MyAudioSource(this.source, this.card);
}

class MusicController extends GetxController {
  var audios = <TblCard>[].obs;
  var audios_path = <String>[].obs;
  var audio_widgets = <Widget>[].obs;
  var currentAudio = ''.obs;
  var currentAudioIndex = 0.obs;
  var canPlay = false.obs;
  var howManyTimePlayAnswer = 1.0.obs;
  StreamSubscription<int?>? sub;
  List<MyAudioSource> myAudios = [];
  TblCard get currentCard => myAudios[currentAudioIndex.value].card;
  List<TblCard> cards = <TblCard>[];
  SpeedController speedController = SpeedController();
  int lessonID = -1;
  MusicController() {
    final pref = SharedPreferences.getInstance().then((prefs) {
      howManyTimePlayAnswer(
          prefs.getDouble(Preference.numberOfPlayAnswer) ?? 1.0);
    });
    _init();
    getListWidget();
    speedController.speed.stream.listen((event) {
      player.setSpeed(event);
    });
    // currentAudioIndex.listen((p0) {
    //   print("printing $p0");
    // });
    player.playerStateStream.listen((playerState) async {
      var processingState = playerState.processingState;
      // playing = playerState.playing;
      if (processingState == ProcessingState.completed) {
        currentAudioIndex(currentAudioIndex.value + 1);
        print(currentAudioIndex.value);
        // player.pause();
        // currentAudioIndex(audios_path.indexOf(currentAudio));
      }
      // lesson_index
    });
  }
  final AudioPlayer player = AudioPlayer();

  Future<void> _init() async {
    // cards = await TblCard().select().orderBy('id').toList();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    if (currentAudio != null) {
      try {
        await player.setFilePath(currentAudio.value);
        //  await _player.setAudioSource(AudioSource.uri(Uri.parse(
        //     "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
      } catch (e) {
        print("Error loading audio source: $e");
      }
    } else if (audios_path != null && audios_path.length > 0) {
      // await player.setAudioSource(
      //   ConcatenatingAudioSource(
      //     // Start loading next item just before reaching it.
      //     useLazyPreparation: true, // default
      //     // Customise the shuffle algorithm.
      //     shuffleOrder: DefaultShuffleOrder(), // default
      //     // Specify the items in the playlist.
      //     children: cards!
      //         .map((e) => AudioSource.uri(Uri.file(e.questionVoicePath!)))
      //         .toList(),
      //     // children: [
      //     //   AudioSource.uri())
      //     //   // AudioSource.uri(Uri.parse("https://example.com/track1.mp3")),
      //     //   // AudioSource.uri(Uri.parse("https://example.com/track2.mp3")),
      //     //   // AudioSource.uri(Uri.parse("https://example.com/track3.mp3")),
      //     // ],
      //   ),
      //   // Playback will be prepared to start from track1.mp3
      //   initialIndex: 0, // default
      //   // Playback will be prepared to start from position zero.
      //   initialPosition: Duration.zero, // default
      // );
    }
  }

  void changeSpeed() {}
  void play(
    List<TblCard> widgetCards,
    int index,
    int lessonLength,
    TblCard card,
    List<Lesson>? listLessons,
  ) async {
    QuestionReviewSpeedController qSpeed = Get.find();
    ReplyReviewSpeedController rSpeed = Get.find();
    DescriptionReviewSpeedController dSpeed = Get.find();

    bool isPlayed = false;
    canPlay(true);
    final pref = await SharedPreferences.getInstance();
    currentAudioIndex(index);

    final radioOptions = pref.getInt(Preference.reviewRadioOption) ?? 0;
    myAudios.clear();
    cards.clear();
    if (listLessons == null)
      cards = await TblCard()
          .select()
          .boxNumber
          .equals(widgetCards.first.boxNumber)
          .orderBy('id')
          .toList(preload: true);
    else {
      for (int i = 0; i < listLessons.length; i++) {
        print(listLessons[i].id);
        final c = await TblCard()
            .select()
            .lessonId
            .equals(listLessons[i].id)
            .orderBy('id')
            .toList(preload: true);
        c.forEach((element) {
          // cards.addAll(c);
          cards.addIf(
              (radioOptions == RadioOptions.All.index) ||
                  // IF choose review cards
                  (element.reviewStart == false && element.examDone == false) &&
                      (radioOptions == RadioOptions.Review.index) ||
                  // IF choose not learned cards
                  (element.examDone == true) &&
                      (radioOptions == RadioOptions.Learned.index),
              element);
        });
        print('lllid ${cards.length}');
      }
    }
    cards.forEach((e) {
      myAudios.add(
          MyAudioSource(AudioSource.uri(Uri.file(e.questionVoicePath!)), e));
      for (var i = 0;
          i < (pref.getDouble(Preference.numberOfPlayAnswer) ?? 1);
          i++) {
        myAudios.add(MyAudioSource(
          AudioSource.uri(Uri.file(e.replyVoicePath!)),
          e,
        ));
      }
      if (pref.getBool(Preference.autoPlayDescription) ?? false) {
        myAudios.add(MyAudioSource(
          AudioSource.uri(Uri.file(e.descriptionVoicePath!)),
          e,
        ));
      }
    });
    int indexAudio =
        myAudios.indexWhere((element) => element.card.id == card.id);
    await player.setAudioSource(
      ConcatenatingAudioSource(
        // Start loading next item just before reaching it.
        useLazyPreparation: true, // default
        // Customise the shuffle algorithm.
        shuffleOrder: DefaultShuffleOrder(), // default
        // Specify the items in the playlist.
        children: myAudios.map((e) => e.source).toList(),
      ),
      // Playback will be prepared to start from track1.mp3
      initialIndex: indexAudio, // default
      // Playback will be prepared to start from position zero.
      initialPosition: Duration.zero, // default
    );
    sub = player.currentIndexStream.listen((event) async {
      print(event);
      if (event != null) {
        print(myAudios[event].card.id);
        print(myAudios[event].card.lessonId);
        currentAudioIndex(event);
      }
    });
    await player.play();
    sub?.cancel();

    // for (int i = 0; cards.first.lessonId! + 1 < lesson_len; i++) {
    //   print("lenlen cards");
    //   print(cards.length);
    //   print("lenlen");
    //   print(temp.length);
    //   print(currentAudioIndex.value);
    //   print(player.currentIndex);

    //   if (player.currentIndex == temp.length - 1 &&
    //       cards.first.lessonId! + 1 < lesson_len) {
    //     cards = await TblCard()
    //         .select()
    //         .lessonId
    //         .equals(cards.first.lessonId! + 1)
    //         .orderBy('orderIndex')
    //         .toList(preload: true);
    //     currentAudioIndex(0);
    //     temp.clear();
    //     cards!.forEach((e) {
    //       temp.add(AudioSource.uri(Uri.file(e.questionVoicePath!)));
    //       for (var i = 0;
    //           i < (pref.getDouble(Preference.numberOfPlayAnswer) ?? 1);
    //           i++) {
    //         temp.add(AudioSource.uri(Uri.file(e.replyVoicePath!)));
    //       }
    //       if (pref.getBool(Preference.autoPlayDescription) ?? false) {
    //         temp.add(AudioSource.uri(Uri.file(e.descriptionVoicePath!)));
    //       }
    //     });
    //     await player.setAudioSource(
    //       ConcatenatingAudioSource(
    //         // Start loading next item just before reaching it.
    //         useLazyPreparation: true, // default
    //         // Customise the shuffle algorithm.
    //         shuffleOrder: DefaultShuffleOrder(), // default
    //         // Specify the items in the playlist.
    //         children: temp,
    //         // children: [
    //         //   AudioSource.uri())
    //         //   // AudioSource.uri(Uri.parse("https://example.com/track1.mp3")),
    //         //   // AudioSource.uri(Uri.parse("https://example.com/track2.mp3")),
    //         //   // AudioSource.uri(Uri.parse("https://example.com/track3.mp3")),
    //         // ],
    //       ),
    //       // Playback will be prepared to start from track1.mp3
    //       initialIndex: indexAudio, // default
    //       // Playback will be prepared to start from position zero.
    //       initialPosition: Duration.zero, // default
    //     );
    //   }
    // }
    // }
    //   {
    //     print("111");

    //     await player
    //         .setFilePath(cards![currentAudioIndex.value].questionVoicePath!);
    //     await player.setSpeed(qSpeed.speed.value);
    //     // await Future.delayed(Duration(seconds: 1));
    //     // await player.seek(duration);
    //     await player.play();
    //     // await Future.delayed(Duration(seconds: 2));
    //     await Future.delayed(Duration(
    //         seconds:
    //             (pref.getDouble(Preference.delayToPlayAnswer)?.toInt() ?? 0)));
    //     print("222");

    //     await player
    //         .setFilePath(cards![currentAudioIndex.value].replyVoicePath!);

    //     for (var i = 0;
    //         i < (pref.getDouble(Preference.numberOfPlayAnswer) ?? 1);
    //         i++) {
    //       await player.setSpeed(rSpeed.speed.value);
    //       await player.play();
    //       await Future.delayed(Duration(
    //           seconds: (pref
    //                   .getDouble(Preference.autoDelayToRepeteAnswer)
    //                   ?.toInt() ??
    //               0)));
    //       await player.seek(duration);
    //     }

    //     if (pref.getBool(Preference.autoPlayDescription) ?? false) {
    //       print("333");
    //       await player.setFilePath(
    //           cards![currentAudioIndex.value].descriptionVoicePath!);
    //       await player.seek(duration);
    //       await player.setSpeed(dSpeed.speed.value);
    //       await Future.delayed(Duration(seconds: 1));
    //       await player.play();
    //     }
    //     currentAudioIndex(currentAudioIndex.value + 1);
    //     if (currentAudioIndex.value == cards.length &&
    //         cards.first.lessonId! + 1 < lesson_len) {
    //       cards = await TblCard()
    //           .select()
    //           .lessonId
    //           .equals(cards.first.lessonId! + 1)
    //           .orderBy('orderIndex')
    //           .toList(preload: true);
    //       currentAudioIndex(0);
    //     }
    //   }
    // }
  }

  // questionVoicePath
  // replyVoicePath
  // descriptionVoicePath
  Future getListWidget() async {
    List<TblCard>? cards = await TblCard().select().orderBy('id').toList();
    audios_path.clear();
    audio_widgets.clear();

    for (int e = 0; e < cards.length; e++) {
      if (cards[e].lessonId != lessonID) {
        lessonID = cards[e].lessonId!;
        audio_widgets.add(Card(
            child: Column(
          children: [
            Text(lessonID.toString()),
            Text(cards[e].question!),
          ],
        )));
      } else if (cards[e].question != null) {
        audio_widgets.add(Card(child: Center(child: Text(cards[e].question!))));
      }
      // if (cards[e].questionVoicePath != null) {
      //   audios_path.add(cards[e].questionVoicePath!);
      //   audio_widgets.add(TextButton(
      //     child: Text("Question ${cards[e].id} "),
      //     onPressed: () {
      //       currentAudioIndex(audios_path.indexOf(cards[e].questionVoicePath!));
      //       currentAudio(cards[e].questionVoicePath!);

      //       player.pause();
      //       player.seek(Duration(seconds: 0));
      //       player.setFilePath(cards[e].questionVoicePath!);
      //       player.play();
      //     },
      //   ));
      // }
      // if (cards[e].replyVoicePath != null) {
      //   audios_path.add(cards[e].replyVoicePath!);
      //   audio_widgets.add(TextButton(
      //     child: Text("Reply"),
      //     onPressed: () {
      //       // currentAudioIndex(e + 1);
      //       currentAudioIndex(audios_path.indexOf(cards[e].questionVoicePath!));
      //       currentAudio(cards[e].questionVoicePath!);
      //       player.pause();
      //       player.seek(Duration(seconds: 0));
      //       player.setFilePath(cards[e].replyVoicePath!);
      //       player.play();
      //       // currentAudio(e.replyVoicePath!);
      //     },
      //   ));
      // }
      // if (cards[e].descriptionVoicePath != null) {
      //   audios_path.add(cards[e].descriptionVoicePath!);
      //   audio_widgets.add(TextButton(
      //     child: Text("Description"),
      //     onPressed: () {
      //       // currentAudioIndex(e + 2);
      //       currentAudioIndex(audios_path.indexOf(cards[e].questionVoicePath!));
      //       currentAudio(cards[e].questionVoicePath!);
      //       player.pause();
      //       player.seek(Duration(seconds: 0));
      //       player.setFilePath(cards[e].descriptionVoicePath!);
      //       player.play();

      //       // currentAudio(e.descriptionVoicePath!);
      //     },
      //   ));
      // }
      audio_widgets.add(Divider(
          // thickness: 10,
          ));
    }
    audios.value = cards;
  }
}
