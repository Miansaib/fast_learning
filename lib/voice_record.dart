import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

// import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'music.dart';
import 'tools/tools.dart';

class VoiceRecord extends StatefulWidget {
  final bool? disableSdCard;
  final bool? timerOn;
  final TextEditingController voiceEditingController;
  VoiceRecord(
      {Key? key,
      required this.voiceEditingController,
      this.disableSdCard,
      this.timerOn})
      : super(key: key);

  @override
  VoiceRecordState createState() => VoiceRecordState();
}

class VoiceRecordState extends State<VoiceRecord> {
  final audioPlayer = AssetsAudioPlayer();
  String statusText = "";
  bool isComplete = false;
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
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              child: Container(
                height: 48.0,
                decoration: BoxDecoration(
                    color: enableRecord ? Colors.red.shade300 : Colors.grey),
                child: Center(
                  child: Text(
                    'record',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onTap: () async {
                if (enableRecord == true) {
                  startRecord();
                }
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                height: 48.0,
                decoration: BoxDecoration(color: Colors.blue.shade300),
                child: Center(
                  child: Text(
                    isRecording ? 'resume' : 'pause',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                pauseRecord();
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                height: 48.0,
                decoration: BoxDecoration(color: Colors.green.shade300),
                child: Center(
                  child: Text(
                    'stop',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                stopRecord();
              },
            ),
          ),
          (widget.disableSdCard == true)
              ? Container()
              : Expanded(
                  child: GestureDetector(
                    child: Container(
                      height: 48.0,
                      decoration:
                          BoxDecoration(color: Colors.yellowAccent.shade700),
                      child: Center(
                        child: Text(
                          'browse',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      getMusicFileFromDir();
                    },
                  ),
                ),
        ],
      ),

      Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
          statusText,
          // style: TextStyle(color: Colors.red, fontSize: 14),
        ),
      ),
      // ((isComplete && widget.voiceEditingController.text.isNotEmpty) &&
      //         isRecording == false)
      (isRecording == false && widget.voiceEditingController.text.isNotEmpty)
          ? ControlButtonsOld(path: widget.voiceEditingController.text)
          : Container(),
      // GestureDetector(
      //   behavior: HitTestBehavior.opaque,
      //   onTap: () {
      //     play();
      //   },
      //   child: Container(
      //     margin: EdgeInsets.only(top: 5),
      //     alignment: AlignmentDirectional.center,
      //     width: 100,
      //     height: 40,
      //     child: (isComplete && recordFilePath != null) || widget.voiceEditingController.text.isNotEmpty
      //         ? Text(
      //             "Play",
      //             style: Get.theme.textTheme.body1!.copyWith(color: Colors.red),
      //           )
      //         : Container(),
      //   ),
      // ),
    ]);
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
    bool isRecording = await record.isRecording();

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
    statusText = '';
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
      return;
    }
    if (getFileExtenstion(musicFilePath) == '.mp3') {
      Directory storageDirectory = await getApplicationDocumentsDirectory();
      String newPath = storageDirectory.path +
          "/${Uuid().v4()}.${getFileExtenstion(musicFilePath)}";
      File(musicFilePath).copy(newPath);
      widget.voiceEditingController.text = newPath;
      setState(() {});
    } else {
      Get.snackbar('warning'.tr, 'music_select_file_required'.tr);
      return;
    }
  }
}
