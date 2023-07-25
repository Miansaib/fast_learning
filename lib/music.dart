import 'dart:math';
import 'package:Fast_learning/controllers/music_controller.dart';
import 'package:Fast_learning/speed_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as RRx;
import 'package:audio_session/audio_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';
import 'package:showcaseview/showcaseview.dart';

import 'card_view_page.dart';
import 'constants/preference.dart';
import 'controllers/base_music_speed_controller.dart';

// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;

//   ControlButtons(this.player);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Opens volume slider dialog
//         IconButton(
//           icon: Icon(Icons.volume_up),
//           onPressed: () {
//             // showSliderDialog(
//             //   context: context,
//             //   title: "Adjust volume",
//             //   divisions: 10,
//             //   min: 0.0,
//             //   max: 1.0,
//             //   value: player.volume,
//             //   stream: player.volumeStream,
//             //   onChanged: player.setVolume,
//             // );
//           },
//         ),

//         /// This StreamBuilder rebuilds whenever the player state changes, which
//         /// includes the playing/paused state and also the
//         /// loading/buffering/ready state. Depending on the state we show the
//         /// appropriate button or loading indicator.
//         StreamBuilder<PlayerState>(
//           stream: player.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;
//             if (processingState == ProcessingState.loading ||
//                 processingState == ProcessingState.buffering) {
//               return Container(
//                 margin: EdgeInsets.all(8.0),
//                 width: 64.0,
//                 height: 64.0,
//                 child: CircularProgressIndicator(),
//               );
//             } else if (playing != true) {
//               return IconButton(
//                 icon: Icon(Icons.play_arrow),
//                 iconSize: 64.0,
//                 onPressed: player.play,
//               );
//             } else if (processingState != ProcessingState.completed) {
//               return IconButton(
//                 icon: Icon(Icons.pause),
//                 iconSize: 64.0,
//                 onPressed: player.pause,
//               );
//             } else {
//               return IconButton(
//                 icon: Icon(Icons.replay),
//                 iconSize: 64.0,
//                 onPressed: () => player.seek(Duration.zero),
//               );
//             }
//           },
//         ),
//         // Opens speed slider dialog
//         StreamBuilder<double>(
//           stream: player.speedStream,
//           builder: (context, snapshot) => IconButton(
//             icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             onPressed: () {
//               // showSliderDialog(
//               //   context: context,
//               //   title: "Adjust speed",
//               //   divisions: 10,
//               //   min: 0.5,
//               //   max: 1.5,
//               //   value: player.speed,
//               //   stream: player.speedStream,
//               //   onChanged: player.setSpeed,
//               // );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

/// Displays the play/pause button and volume/speed sliders.
///
class ControlButtonsCustom extends StatelessWidget {
  final AudioPlayer player;

  ControlButtonsCustom(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            Icons.volume_up,
            color: Colors.grey[700],
          ),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "تنظیم صدا",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              // return Container(
              //   margin: EdgeInsets.all(8.0),
              //   width: 64.0,
              //   height: 64.0,
              //   child: CircularProgressIndicator(),
              // );
              return Container();
            } else if (playing != true) {
              return IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.grey[700],
                ),
                iconSize: 30.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(
                  Icons.pause,
                  color: Colors.grey[700],
                ),
                iconSize: 30.0,
                onPressed: player.pause,
              );
            } else {
              player.seek(Duration.zero);
              return IconButton(
                icon: Icon(
                  Icons.pause,
                  color: Colors.grey[700],
                ),
                iconSize: 30.0,
                onPressed: player.pause,
              );
              // return IconButton(
              //   icon: Icon(Icons.replay,color: Colors.grey[700],),
              //   iconSize: 30.0,
              //   onPressed: () => player.seek(Duration.zero),
              // );
            }
          },
        ),
        // Opens speed slider dialog
        // StreamBuilder<double>(
        //   stream: player.speedStream,
        //   builder: (context, snapshot) => IconButton(
        //     icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
        //         style: TextStyle(fontWeight: FontWeight.bold)),
        //     onPressed: () {
        //       showSliderDialog(
        //         context: context,
        //         title: "Adjust speed",
        //         divisions: 10,
        //         min: 0.5,
        //         max: 1.5,
        //         value: player.speed,
        //         stream: player.speedStream,
        //         onChanged: player.setSpeed,
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class PlayerVoiceRecord extends StatefulWidget {
  final BaseMusicSpeedController? speedController;
  final String? path;
  final List<String>? pathes;
  final Function? musicEndCallBack;
  final String?
      indexCallBackTrigger; //برای اینکه تابع کال بک در تغییر استیت مجدد فراخوانی نشود
  PlayerVoiceRecord(
      {Key? key,
      this.path,
      this.pathes,
      this.musicEndCallBack,
      this.indexCallBackTrigger,
      this.speedController})
      : super(key: key);

  @override
  PlayerVoiceRecordState createState() => PlayerVoiceRecordState();
}

class PlayerVoiceRecordState extends State<PlayerVoiceRecord> {
  //SpeedController speedController = myget.Get.find<SpeedController>();
  List<String> indexCallBackTriggers = [];
  final AudioPlayer player = AudioPlayer();
  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    if (widget.path != null) {
      try {
        await player.setFilePath(widget.path!);
        //  await _player.setAudioSource(AudioSource.uri(Uri.parse(
        //     "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
      } catch (e) {
        print("Error loading audio source: $e");
      }
    } else if (widget.pathes != null && widget.pathes!.length > 0) {
      await player.setAudioSource(
        ConcatenatingAudioSource(
          // Start loading next item just before reaching it.
          useLazyPreparation: true, // default
          // Customise the shuffle algorithm.
          shuffleOrder: DefaultShuffleOrder(), // default
          // Specify the items in the playlist.
          children:
              widget.pathes!.map((e) => AudioSource.uri(Uri.file(e))).toList(),
          // children: [
          //   AudioSource.uri())
          //   // AudioSource.uri(Uri.parse("https://example.com/track1.mp3")),
          //   // AudioSource.uri(Uri.parse("https://example.com/track2.mp3")),
          //   // AudioSource.uri(Uri.parse("https://example.com/track3.mp3")),
          // ],
        ),
        // Playback will be prepared to start from track1.mp3
        initialIndex: 0, // default
        // Playback will be prepared to start from position zero.
        initialPosition: Duration.zero, // default
      );
    }
  }

  @override
  void initState() {
    _init();
    // if (widget.speedController != null) {
    //   widget.speedController?.speed.stream.listen((value) {
    //     player.setSpeed(value);
    //   });
    //   player.setSpeed(widget.speedController?.speed.value ?? 1.0);
    // }
    widget.speedController?.speed.stream.listen((value) {
      player.setSpeed(value);
    });
    player.setSpeed(widget.speedController?.speed.value ?? 1.0);
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      RRx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    // _init();
    player.pause();
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        // decoration: BoxDecoration(color: Colors.red),
        // width: 200,
        child: StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // StreamBuilder<double>(
                //   stream: player.speedStream,
                //   builder: (context, snapshot) => IconButton(
                //     icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                //         style: TextStyle(fontWeight: FontWeight.bold)),
                //     onPressed: () {
                //       showSliderDialog(
                //         speedController: widget.speedController,
                //         context: context,
                //         title: "Adjust speed",
                //         divisions: 20,
                //         min: 0.5,
                //         max: 2.0,
                //         value: player.speed,
                //         stream: player.speedStream,
                //         onChanged: player.setSpeed,
                //       );
                //     },
                //   ),
                // ),

                // (widget.pathes == null)
                //     ? IconButton(
                //         onPressed: () {
                //           player.seek(Duration(
                //               seconds: positionData!.position.inSeconds - 5 <= 0
                //                   ? 0
                //                   : positionData.position.inSeconds - 5));
                //         },
                //         icon: Icon(CupertinoIcons.refresh),
                //         iconSize: 15,
                //       )
                //     : Container(),
                // (widget.pathes == null)
                //     ? IconButton(
                //         onPressed: () {
                //           player.seek(Duration(
                //               seconds: positionData!.position.inSeconds + 5));
                //         },
                //         icon: Icon(CupertinoIcons.refresh_bold),
                //         iconSize: 15,
                //       )
                //     : Container(),

                /// This StreamBuilder rebuilds whenever the player state changes, which
                /// includes the playing/paused state and also the
                /// loading/buffering/ready state. Depending on the state we show the
                /// appropriate button or loading indicator.
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    var processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          width: 15.0,
                          height: 15.0,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (playing != true) {
                      return IconButton(
                        icon: Icon(Icons.play_arrow),
                        iconSize: 15.0,
                        onPressed: player.play,
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        icon: Icon(Icons.pause),
                        iconSize: 15.0,
                        onPressed: player.pause,
                      );
                    } else {
                      if (processingState == ProcessingState.completed &&
                          widget.musicEndCallBack != null) {
                        if ((positionData!.duration - positionData.position)
                                .inSeconds ==
                            0) {
                          //positionData.position.inSeconds >= 1) {
                          // if (indexCallBackTriggers.contains(widget.indexCallBackTrigger) ==  false) {
                          print('now');
                          indexCallBackTriggers
                              .add(widget.indexCallBackTrigger!);
                          widget.musicEndCallBack!();
                          //}

                          // widget.musicEndCallBack!();
                        }
                        // widget.musicEndCallBack!();

                      }
                      return IconButton(
                        icon: Icon(CupertinoIcons.refresh_circled),
                        iconSize: 15.0,
                        onPressed: () => player.seek(Duration.zero),
                      );
                    }
                  },
                ),
                (widget.pathes != null && widget.pathes!.length > 0)
                    ? IconButton(
                        onPressed: () async {
                          await player.seekToPrevious();
                        },
                        icon: Icon(Icons.skip_previous),
                        iconSize: 15,
                      )
                    : Container(),
                (widget.pathes != null && widget.pathes!.length > 0)
                    ? IconButton(
                        onPressed: () async {
                          await player.seekToNext();
                        },
                        icon: Icon(Icons.skip_next),
                        iconSize: 15,
                      )
                    : Container(),
                SizedBox(
                  width: 100,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: SeekBar(
                      showTextStatus: false,
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: player.seek,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ControlButtonsOld extends StatefulWidget {
  final List<GlobalKey<ControlButtonsOldState>>? otherControls;
  final BaseMusicSpeedController? speedController;
  final String? path;
  final List<String>? pathes;
  final Function? musicEndCallBack;
  final RRx.BehaviorSubject<double>? howManyTimePlayStream;
  final Function(double)? streamCaller;
  final String? indexCallBackTrigger;

  final GlobalKey? show_hint_key;
  //برای اینکه تابع کال بک در تغییر استیت مجدد فراخوانی نشود
  ControlButtonsOld({
    Key? key,
    this.path,
    this.pathes,
    this.musicEndCallBack,
    this.indexCallBackTrigger,
    this.speedController,
    this.howManyTimePlayStream,
    this.streamCaller,
    this.otherControls,
    this.show_hint_key,
  }) : super(key: key);

  @override
  ControlButtonsOldState createState() => ControlButtonsOldState();
}

class ControlButtonsOldState extends State<ControlButtonsOld> {
  //SpeedController speedController = myget.Get.find<SpeedController>();
  List<String> indexCallBackTriggers = [];
  bool? playing;
  final AudioPlayer player = AudioPlayer();

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    if (widget.path != null) {
      try {
        await player.setFilePath(widget.path!);
        //  await _player.setAudioSource(AudioSource.uri(Uri.parse(
        //     "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
      } catch (e) {
        print("Error loading audio source: $e");
      }
    } else if (widget.pathes != null && widget.pathes!.length > 0) {
      await player.setAudioSource(
        ConcatenatingAudioSource(
          // Start loading next item just before reaching it.
          useLazyPreparation: true, // default
          // Customise the shuffle algorithm.
          shuffleOrder: DefaultShuffleOrder(), // default
          // Specify the items in the playlist.
          children:
              widget.pathes!.map((e) => AudioSource.uri(Uri.file(e))).toList(),
          // children: [
          //   AudioSource.uri())
          //   // AudioSource.uri(Uri.parse("https://example.com/track1.mp3")),
          //   // AudioSource.uri(Uri.parse("https://example.com/track2.mp3")),
          //   // AudioSource.uri(Uri.parse("https://example.com/track3.mp3")),
          // ],
        ),
        // Playback will be prepared to start from track1.mp3
        initialIndex: 0, // default
        // Playback will be prepared to start from position zero.
        initialPosition: Duration.zero, // default
      );
    }
  }

  @override
  void initState() {
    _init();
    // if (widget.speedController != null) {
    //   widget.speedController?.speed.stream.listen((value) {
    //     player.setSpeed(value);
    //   });
    //   player.setSpeed(widget.speedController?.speed.value ?? 1.0);
    // }
    widget.speedController?.speed.stream.listen((value) async {
      widget.speedController?.changeSpeed(value);
      player.setSpeed(value);
    });
    player.setSpeed(widget.speedController?.speed.value ?? 1.0);
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      RRx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    // _init();
    MusicController musicController = Get.find();
    player.pause();
    return StreamBuilder<PositionData>(
      stream: _positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;

        // return SeekBar(
        //   duration: positionData?.duration ?? Duration.zero,
        //   position: positionData?.position ?? Duration.zero,
        //   bufferedPosition:
        //       positionData?.bufferedPosition ?? Duration.zero,
        //   onChangeEnd: player.seek,
        // );
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.howManyTimePlayStream != null)
              StreamBuilder<Object>(
                  stream: widget.howManyTimePlayStream,
                  builder: (context, snapshot) {
                    return IconButton(
                      icon: Badge(
                        badgeContent: Text(widget.howManyTimePlayStream!.value
                            .toInt()
                            .toString()),
                        child: Icon(Icons.restart_alt_rounded),
                        animationType: BadgeAnimationType.fade,
                      ),
                      onPressed: () {
                        showDelaySliderDialog(
                            title: 'How many time you want to play answer?',
                            divisions: 4,
                            min: 1,
                            max: 5,
                            value: 1,
                            stream: widget.howManyTimePlayStream!.stream,
                            onChangeCallStream: (value) {
                              widget.streamCaller!(value);
                              musicController.howManyTimePlayAnswer(value);
                            },
                            isInt: true);
                      },
                    );
                  }),
            Expanded(
              child: StreamBuilder<double>(
                stream: player.speedStream,
                builder: (context, snapshot) => IconButton(
                  icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    showSliderDialog(
                      speedController: widget.speedController,
                      context: context,
                      title: "Adjust speed",
                      divisions: 20,
                      min: 0.5,
                      max: 2.0,
                      value: player.speed,
                      stream: player.speedStream,
                      onChanged: player.setSpeed,
                    );
                  },
                ),
              ),
            ),
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                var processingState = playerState?.processingState;
                playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: Image.asset("assets/images/play-icon.png"),
                    iconSize: 20,
                    onPressed: player.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  if (playing == true) {
                    if (widget.otherControls != null &&
                        widget.otherControls!.length != 0) {
                      for (var item in widget.otherControls!) {
                        if (item.currentState?.playing == true) {
                          item.currentState!.player.pause();
                          // .then((value) {
                          //   Future.delayed(Duration(seconds: 5), () {
                          //     if (playing == false) {
                          //       // player.play();
                          //     }
                          //   });
                          // });
                        }
                      }
                      player.play();
                    }
                  }
                  return IconButton(
                    icon: Image.asset("assets/images/pause-icon.png"),
                    iconSize: 20,
                    onPressed: player.pause,
                  );
                } else {
                  if (processingState == ProcessingState.completed) if (widget
                          .musicEndCallBack !=
                      null) {
                    if ((positionData!.duration - positionData.position)
                            .inSeconds ==
                        0) {
                      player.pause();
                      player.seek(Duration.zero);
                      //positionData.position.inSeconds >= 1) {
                      // if (indexCallBackTriggers.contains(widget.indexCallBackTrigger) ==  false) {

                      if (widget.indexCallBackTrigger != null)
                        indexCallBackTriggers.add(widget.indexCallBackTrigger!);
                      if (widget.musicEndCallBack != null)
                        widget.musicEndCallBack!();
                      //}

                      // widget.musicEndCallBack!();
                    }
                    // widget.musicEndCallBack!();
                    return IconButton(
                      icon: Image.asset("assets/images/play-icon.png"),
                      iconSize: 20,
                      onPressed: player.play,
                    );
                  }

                  return IconButton(
                    icon: Icon(Icons.replay),
                    iconSize: 20,
                    onPressed: player.play,
                  );
                }
              },
            ),

            SizedBox(
              width: 100,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: player.seek,
                ),
              ),
            ),
            (widget.pathes == null)
                ? IconButton(
                    onPressed: () {
                      player.seek(Duration(
                          seconds: positionData!.position.inSeconds - 5 <= 0
                              ? 0
                              : positionData.position.inSeconds - 5));
                    },
                    icon: Icon(CupertinoIcons.refresh_bold),
                    iconSize: 15,
                  )
                : Container(),

            /// This StreamBuilder rebuilds whenever the player state changes, which
            /// includes the playing/paused state and also the
            /// loading/buffering/ready state. Depending on the state we show the
            /// appropriate button or loading indicator.
            (widget.pathes == null)
                ? IconButton(
                    onPressed: () {
                      player.seek(Duration(
                          seconds: positionData!.position.inSeconds + 5));
                    },
                    icon: Icon(CupertinoIcons.refresh),
                    iconSize: 15,
                  )
                : Container(),
            (widget.pathes != null && widget.pathes!.length > 0)
                ? IconButton(
                    onPressed: () async {
                      await player.seekToPrevious();
                    },
                    icon: Icon(Icons.skip_previous),
                    iconSize: 15,
                  )
                : Container(),
            (widget.pathes != null && widget.pathes!.length > 0)
                ? IconButton(
                    onPressed: () async {
                      await player.seekToNext();
                    },
                    icon: Icon(Icons.skip_next),
                    iconSize: 15,
                  )
                : Container(),
          ],
        );
      },
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final bool showTextStatus;

  SeekBar(
      {required this.duration,
      required this.position,
      required this.bufferedPosition,
      this.onChanged,
      this.onChangeEnd,
      this.showTextStatus = true});

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 60.0),
      child: Stack(
        children: [
          // SliderTheme(
          //   data: _sliderThemeData.copyWith(
          //     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
          //     thumbColor: Color(0xff27187E),
          //     activeTrackColor: Color(0xff27187E),
          //     inactiveTrackColor: Colors.transparent,
          //   ),
          //   child: ExcludeSemantics(
          //     child: Slider(
          //       min: 0.0,
          //       max: widget.duration.inMilliseconds.toDouble(),
          //       value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
          //           widget.duration.inMilliseconds.toDouble()),
          //       onChanged: (value) {
          //         setState(() {
          //           _dragValue = value;
          //         });
          //         if (widget.onChanged != null) {
          //           widget.onChanged!(Duration(milliseconds: value.round()));
          //         }
          //       },
          //       onChangeEnd: (value) {
          //         if (widget.onChangeEnd != null) {
          //           widget.onChangeEnd!(Duration(milliseconds: value.round()));
          //         }
          //         _dragValue = null;
          //       },
          //     ),
          //   ),
          // ),
          SliderTheme(
            data: _sliderThemeData.copyWith(
              thumbShape: HiddenThumbComponentShape(),
              activeTrackColor: Color(0xff8A8A8A),
              inactiveTrackColor: Color(0xff8A8A8A),
            ),
            child: ExcludeSemantics(
              child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                    widget.duration.inMilliseconds.toDouble()),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  _dragValue = null;
                },
              ),
            ),
          ),

          SliderTheme(
            data: _sliderThemeData.copyWith(
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4),
              thumbColor: Color(0xff27187E),
              activeTrackColor: Color(0xff27187E),
              inactiveTrackColor: Colors.transparent,
            ),
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
          Visibility(
            visible: widget.showTextStatus,
            child: Positioned(
              right: 16.0,
              bottom: 0.0,
              child: Text(
                  RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                          .firstMatch("$_remaining")
                          ?.group(1) ??
                      '$_remaining',
                  style: Theme.of(context).textTheme.caption),
            ),
          ),
        ],
      ),
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog(
    {required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    String valueSuffix = '',
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
    BaseMusicSpeedController? speedController}) {
  showDialog<void>(
      context: context,
      builder: (context) {
        //  SpeedController speedController = myget.Get.find<SpeedController>();
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: StreamBuilder<double>(
            stream: stream,
            builder: (context, snapshot) => Container(
              height: 100.0,
              child: Column(
                children: [
                  Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                      style: TextStyle(
                          fontFamily: 'Fixed',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0)),
                  Slider(
                    divisions: divisions,
                    min: min,
                    max: max,
                    value: snapshot.data ?? value,
                    onChanged: (double value) {
                      if (speedController != null) {
                        speedController.speed.value = value;
                      } else {
                        onChanged(value);
                      }

                      //
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
