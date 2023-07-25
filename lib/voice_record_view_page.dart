import 'dart:async';

import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
// Import package
import 'package:record/record.dart';
// import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uuid/uuid.dart';

import 'music.dart';
import 'tools/tools.dart';

class VoiceRecordViewPage extends StatefulWidget {
  final bool? disableSdCard;
  final bool? timerOn;
  final TextEditingController voiceEditingController;
  VoiceRecordViewPage(
      {Key? key,
      required this.voiceEditingController,
      this.disableSdCard,
      this.timerOn})
      : super(key: key);

  @override
  _VoiceRecordViewPageState createState() => _VoiceRecordViewPageState();
}

class _VoiceRecordViewPageState extends State<VoiceRecordViewPage> {
  final audioPlayer = AssetsAudioPlayer();
  String statusText = "record my voice";
  bool isComplete = false;
  bool isFirst = true;
  bool isRecording = false;
  bool enableRecord = true;
  int seconds = 0;
  Timer? timer;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      if (widget.voiceEditingController.text.isNotEmpty) {
        //  recordFilePath = widget.voiceEditingController.text;
      }
      setState(() {});
    });
    super.initState();
  }

  void stopRecordByTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (value) {
      seconds++;
      if (value.tick > 120) {
        pauseRecord();
        timer!.cancel();
      }
    });
  }

  @override
  void dispose() {
    // if (widget.timerOn == true) {
    //   timer!.cancel();
    // }
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  ///Enable reord button
  void setStatusRecord(bool isEnable) {
    enableRecord = isEnable;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Color(0xff353535)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xff27187E),
                                )),
                            child: IconButton(
                              onPressed: () {
                                if (isComplete || isFirst) {
                                  if (widget
                                      .voiceEditingController.text.isNotEmpty) {
                                    print(widget.voiceEditingController.text);
                                    File tokenFile = File(
                                        widget.voiceEditingController.text);
                                    tokenFile.delete();
                                  }
                                  isFirst = false;
                                  startRecord();
                                } else if (!isComplete) {
                                  stopRecord();
                                }
                              },
                              icon: (isComplete || isFirst)
                                  ? Image.asset(
                                      "assets/images/microphone-2.png",
                                      width: 24,
                                      height: 24,
                                    )
                                  : Image.asset(
                                      "assets/images/tick-circle.png",
                                      width: 24,
                                      height: 24,
                                    ),
                            ),
                          ),
                        ),
                        if (isComplete == false && !isFirst)
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xff27187E),
                                  )),
                              child: IconButton(
                                  onPressed: () {
                                    pauseRecord();
                                    // setState(() {});
                                  },
                                  icon: ((isRecording == false)
                                      ? Image.asset(
                                          "assets/images/play-icon.png",
                                          width: 24,
                                          height: 24,
                                        )
                                      : Image.asset(
                                          "assets/images/pause-icon.png",
                                          width: 24,
                                          height: 24,
                                        ))),
                            ),
                          ),
                        SizedBox(width: 10),
                        Text(statusText,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff27187E))),
                        SizedBox(height: 10),
                      ],
                    ),
                    Text(
                        "that is useful to listen and compare with the answer\nespecially while you are learning a new language",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 74, 83, 141))),
                    SizedBox(height: 10)
                  ],
                ),
              ),
              (widget.disableSdCard == true)
                  ? Container()
                  : Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.black,
                            height: 50,
                            width: 2,
                          ),
                        ),
                        IconButton(
                          iconSize: 50,
                          icon: Column(
                            children: [
                              Icon(
                                Icons.file_present,
                                size: 24,
                              ),
                              Text(
                                'Browse',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            await getMusicFileFromDir();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
            ],
          ),
          ((isComplete == true))
              ? Column(
                  children: [
                    Divider(
                      thickness: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ControlButtonsOld(
                        path: widget.voiceEditingController.text,
                      ),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Future<bool> checkPermission() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    return true;
  }

  void startRecord() async {
    if (widget.timerOn == true) {
      stopRecordByTimer();
    }
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      isRecording = true;
      statusText = "Recording...";
      widget.voiceEditingController.text = await getFilePath();
      print(widget.voiceEditingController.text);
      isComplete = false;
      final record = Record();

      record.start(
        path: widget.voiceEditingController.text,
        bitRate: 64000, // by default
        samplingRate: 44100,
      );
    } else {
      statusText = "No recording permission";
    }
    setState(() {});
  }

  void pauseRecord() async {
    final record = Record();
    // bool isRecording = await record.isRecording();
    isRecording = !isRecording;
    print(isRecording);
    if (isRecording) {
      await record.resume();

      statusText = "Recording...";
      setState(() {});
    } else {
      await record.pause();

      statusText = "Recording is paused...";
      setState(() {});
    }
  }

  void stopRecord() async {
    final record = Record();

    String? s = await record.stop();

    isRecording = false;
    //statusText = "Recording is complete";
    statusText = 'record new voice';
    isComplete = true;
    setState(() {});
  }

  void resumeRecord() async {
    final record = Record();
    await record.resume();

    statusText = "Recording...";
    setState(() {});
  }

  void play() {
    //"/data/user/0/com.drehsani.Fast_learning/app_flutter/record/52e5b3d7-9bf5-4a93-aab7-79d4766bd456.mp3"
    if (widget.voiceEditingController.text != null &&
        File(widget.voiceEditingController.text).existsSync()) {
      audioPlayer.open(
        Audio.file(widget.voiceEditingController.text),
        autoStart: true,
        showNotification: true,
      );
    }
  }

  //int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String path = storageDirectory.path + "/${Uuid().v4()}.mp3";
    widget.voiceEditingController.text = path;
    //return sdPath + "/test_${i++}.mp3";
    return path;
  }

  Future getMusicFileFromDir() async {
    isComplete = false;
    setState(() {});
    PermissionStatus status = await Permission.storage.request();
    Directory currentDirectory = Directory(FolderPicker.rootPath);
    String? musicFilePath = await FilesystemPicker.open(
      title: 'select_file'.tr,
      context: Get.context!,
      rootDirectory: currentDirectory,
      fsType: FilesystemType.file,
      pickText: 'open mp3 file',
      folderIconColor: Colors.teal,
    );
    if (musicFilePath == null) {
      Get.snackbar('warning'.tr, 'music_select_file_required'.tr);
      setState(() {
        isComplete = true;
      });
      return;
    }
    if (getFileExtenstion(musicFilePath) == '.mp3') {
      Directory storageDirectory = await getApplicationDocumentsDirectory();
      String newPath = storageDirectory.path +
          "/${Uuid().v4()}.${getFileExtenstion(musicFilePath)}";
      File(musicFilePath).copy(newPath);
      widget.voiceEditingController.text = newPath;
      setState(() {
        isComplete = true;
      });
    } else {
      Get.snackbar('warning'.tr, 'music_select_file_required'.tr);
      return;
    }
  }
}
