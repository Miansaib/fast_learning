import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/main.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:encrypt/encrypt.dart' as encrype;
import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_archive/flutter_archive.dart' as flutterarchive;
import 'package:path_provider/path_provider.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../model/model.dart';
import 'package:path/path.dart' as p;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:filesystem_picker/filesystem_picker.dart';
import 'extension.dart';
import 'helper.dart';
import 'package:darq/darq.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io' show Platform;

class Box {
  int? boxNumber;
  DateTime? startDate;
  SubGroup? subGroup;
  TblCard? card;
  Box({this.boxNumber, this.startDate, this.card, this.subGroup});
}

Future<List<Box>> calcBoxForCard() async {
  //Box currenttBox = Box(index: 1,startDate: DateTime.now());
  List<Box> boxes = [];
  var cards = await TblCard()
      .select()
      .boxVisibleDate
      .lessThan(DateTime.now())
      .and
      .examDone
      .equals(false)
      .and
      .reviewStart
      .equals(true)
      .orderBy('boxVisibleDate')
      .toList(preload: true);
  for (var card in cards) {
    var box = Box();
    var subGroup = await SubGroup()
        .select()
        .id
        .equals(card.plLesson!.subGroupId)
        .toSingle(loadParents: true);
    box
      ..boxNumber = 1
      ..card = card
      ..startDate = card.boxVisibleDate
      ..subGroup = subGroup;
    boxes.add(box);
  }
  return boxes.orderBy((c) => c.startDate).toList();
}

String getFileExtenstion(String path) {
  return p.extension(path);
}

Future<String> copyFileToApplicationDirectory(String currentPath) async {
  String applicatioPath = await getApplicationPath();
  String newFilePath =
      applicatioPath + '/' + Uuid().v4() + getFileExtenstion(currentPath);
  File newFile = await File(currentPath).copy(newFilePath);
  return newFile.path;
}

Future<String> getApplicationPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> getFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result == null) {
    return "";
  }
  return result.files.single.path!;
}

Future unzipFiles(
    {RootGroup? rootGroup, SubGroup? subGroup, String? givenPath}) async {
  final GlobalKey<State> dialogKey = GlobalKey<State>();

  final destinationDir =
      Directory((await getApplicationDocumentsDirectory()).path);
  // await destinationDir.delete(recursive: true);
  File zipFile;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString(Preference.token)!;
  if (givenPath == null) {
    PermissionStatus status = await Permission.storage.request();
    await FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    String? zipFilePath;
    if (result != null) {
      zipFilePath = result.files.single.path;
    } else {
      // User canceled the picker
    }
    if (zipFilePath != null && !zipFilePath.endsWith('.aes')) {
      Get.snackbar('warning'.tr, 'required_wrong_file'.tr,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (zipFilePath == null) {
      Get.snackbar('warning'.tr, 'required_select_zip_file'.tr);
      return;
    }
    await UITools(Get.context!).showWaitScreen('Waiting', null, dialogKey);
    zipFile = File(zipFilePath);
  } else {
    zipFile = File(givenPath);
  }
  print(givenPath);
//**************شروع رمز گشایی */
  var tempFile = await decrypeFile(zipFile);
//***************پایان رمزگشایی */

  String? jsonFileName;
  bool tokenExist = false;
  try {
    await flutterarchive.ZipFile.extractToDirectory(
        zipFile: tempFile!,
        //destinationDir: Directory('/storage/emulated/0/Ponisha'),
        destinationDir: destinationDir,
        onExtracting: (zipEntry, progress) {
          if (zipEntry.name.contains('.json')) {
            jsonFileName = zipEntry.name;
          }
          if (zipEntry.name.contains('tokens.txt')) {
            tokenExist = true;
          }
          print('progress: ${progress.toStringAsFixed(1)}%');
          print('name: ${zipEntry.name}');
          print('isDirectory: ${zipEntry.isDirectory}');
          // print(
          //     'modificationDate: ${zipEntry.modificationDate.toLocal().toIso8601String()}');
          print('uncompressedSize: ${zipEntry.uncompressedSize}');
          print('compressedSize: ${zipEntry.compressedSize}');
          print('compressionMethod: ${zipEntry.compressionMethod}');
          print('crc: ${zipEntry.crc}');
          return flutterarchive.ZipFileOperation.includeItem;
        });

//********بررسسی توکن و چک کردن داشتن مجوز برای ایمپورت */
    if (tokenExist == true) {
      String tokenFilePath = (await getApplicationPath()) + '/' + 'tokens.txt';
      String tokens = await File(tokenFilePath).readAsString();
      if (!tokens.contains(token)) {
        Get.snackbar('WARNING', 'you dont have permission!',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    }

    if (jsonFileName != null) {
      String zipFilePath = (await getApplicationPath()) + '/' + jsonFileName!;
      if (rootGroup == null) {
        await importFolders(zipFilePath);
      } else if (subGroup == null) {
        await importCards(zipFilePath, rootGroup: rootGroup);
      } else {
        await importCards(zipFilePath, subgroup: subGroup);
      }
    }
    if (dialogKey.currentContext != null)
      Navigator.of(dialogKey.currentContext!).pop();
  } catch (e) {
    if (dialogKey.currentContext != null)
      Navigator.of(dialogKey.currentContext!).pop();

    Get.snackbar('Import Failed!', 'Try again',
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}

Future zipLessons(SubGroup subGroup,
    {List<int>? lessonIds, List<String>? tokens}) async {
  final GlobalKey<State> dialogKey = GlobalKey<State>();

  String fileName = subGroup.title!;
  var lessons = await Lesson()
      .select()
      .subGroupId
      .equals(subGroup.id)
      .toList(preload: true);
  List<File> files = [];

  if (lessonIds != null && lessonIds.length > 0) {
    lessons.removeWhere((lesson) => !lessonIds.contains(lesson.id));
    // fileName = lessons.first.title!;
    fileName = fileName + '_' + lessonIds.length.toString();
  }

  for (var book in lessons) {
    if (book.imagePath != null && book.imagePath!.isNotEmpty) {
      File file = File(book.imagePath!);
      files.add(file);
    }

    for (var lesson in lessons) {
      if (lesson.imagePath != null && lesson.imagePath!.isNotEmpty) {
        File file = File(lesson.imagePath!);
        files.add(file);
      }
      if (lesson.storyImagePath != null && lesson.storyImagePath!.isNotEmpty) {
        File file = File(lesson.storyImagePath!);
        files.add(file);
      }
      if (lesson.storyVoicePathOne != null &&
          lesson.storyVoicePathOne!.isNotEmpty) {
        File file = File(lesson.storyVoicePathOne!);
        files.add(file);
      }
      if (lesson.storyVoicePathTwo != null &&
          lesson.storyVoicePathTwo!.isNotEmpty) {
        File file = File(lesson.storyVoicePathTwo!);
        files.add(file);
      }
      if (lesson.descriptionImagePath != null &&
          lesson.descriptionImagePath!.isNotEmpty) {
        File file = File(lesson.descriptionImagePath!);
        files.add(file);
      }
      if (lesson.descriptionVoicePathOne != null &&
          lesson.descriptionVoicePathOne!.isNotEmpty) {
        File file = File(lesson.descriptionVoicePathOne!);
        files.add(file);
      }
      if (lesson.descriptionVoicePathTwo != null &&
          lesson.descriptionVoicePathTwo!.isNotEmpty) {
        File file = File(lesson.descriptionVoicePathTwo!);
        files.add(file);
      }
      List<TblCard> cards = await lesson.getTblCards()!.toList();
      for (var card in cards) {
        if (card.imagePath != null && card.imagePath!.isNotEmpty) {
          File file = File(card.imagePath!);
          files.add(file);
        }
        if (card.questionVoicePath != null &&
            card.questionVoicePath!.isNotEmpty) {
          File file = File(card.questionVoicePath!);
          files.add(file);
        }
        if (card.replyVoicePath != null && card.replyVoicePath!.isNotEmpty) {
          File file = File(card.replyVoicePath!);
          files.add(file);
        }
        if (card.descriptionVoicePath != null &&
            card.descriptionVoicePath!.isNotEmpty) {
          File file = File(card.descriptionVoicePath!);
          files.add(file);
        }
      }
    }
  }
  List<File> uniqueFiles = [];
  for (var file in files) {
    if (uniqueFiles.where((element) => element.path == file.path).length == 0) {
      uniqueFiles.add(file);
    }
  }
  if (tokens != null && tokens.length != 0) {
    File tokenFile = File((await getApplicationPath()) + '/tokens.txt');
    String tokensText = tokens.join(',');
    await tokenFile.writeAsString(tokensText);
    uniqueFiles.add(tokenFile);
  }
  try {
    uniqueFiles.add(await writeLessonsToJson(lessons));
  } catch (e) {
    if (dialogKey.currentContext != null)
      Navigator.of(dialogKey.currentContext!).pop();

    Get.snackbar('warning'.tr, e.toString());
    return;
  }
  String appPath = await getApplicationPath();
  final sourceDir = await pickFolder();
  if (sourceDir == null) {
    Get.snackbar('warning'.tr, 'You must select folder');
    return;
  }

  //final zipFile = File(sourceDir!.path + '/$fileName.zip');
  final zipFile = File(appPath + '/$fileName.zip');
  bool isZipFileExist = await zipFile.exists();
  if (isZipFileExist) {
    await zipFile.delete();
  }
  PermissionStatus status = await Permission.storage.request();
  try {
    await UITools(Get.context!).showWaitScreen('Waiting', null, dialogKey);
    // String inAppZipPath = await getApplicationPath() +  '/$fileName.zip';
    await flutterarchive.ZipFile.createFromFiles(
        sourceDir: Directory(await getApplicationPath()),
        files: uniqueFiles,
        zipFile: zipFile);
    //****************** */
    Uint8List data = await File(zipFile.path).readAsBytes();
    // final key = encrype.Key.fromUtf8(
    //     'my 32 length key................'); //W2D7!LsJf5WX&C34G+Ah-yNgaS?S*g2U
    final key = encrype.Key.fromUtf8('W2D7!LsJf5WX&C34G+Ah-yNgaS?S*g2U');
    final iv = encrype.IV.fromLength(16);
    final encrypter = encrype.Encrypter(encrype.AES(key));
    final encrypted = encrypter.encryptBytes(data, iv: iv);
    File encodeFile = await File(sourceDir.path + '/$fileName.aes')
        .writeAsBytes(encrypted.bytes);

    Share.shareFiles([encodeFile.path], text: 'Share Export File');
    if (dialogKey.currentContext != null)
      Navigator.of(dialogKey.currentContext!).pop();
  } catch (e) {
    if (dialogKey.currentContext != null)
      Navigator.of(dialogKey.currentContext!).pop();
    Get.back();
    Get.snackbar('warning', e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 10));
    print(e);
  }
}

Future<File?> decrypeFile(File encrypedFile) async {
  Uint8List bytes = await encrypedFile.readAsBytes();
  final key = encrype.Key.fromUtf8('W2D7!LsJf5WX&C34G+Ah-yNgaS?S*g2U');
  final iv = encrype.IV.fromLength(16);
  final encrypter = encrype.Encrypter(encrype.AES(key));
  Encrypted data = Encrypted(bytes);
  final decrypted = encrypter.decryptBytes(data, iv: iv);
  String path = await getApplicationPath();
  File file = File(path + '/encrype_decrype.zip');
  if ((await file.exists())) {
    await file.delete();
  }
  File resultFile = await file.writeAsBytes(decrypted);
  return resultFile;
}

Future<File> writeLessonsToJson(List<Lesson> temp) async {
  for (var lesson in temp) {
    if (lesson.plTblCards == null) {
      lesson.plTblCards = await TblCard()
          .select()
          .lessonId
          .equals(lesson.id)
          .toList(preload: true);
    }
  }
  var x = temp.map((e) => e.toCustomJson()).toList();
  String cards = json.encode(x);
  String filepath = Uuid().v4() + '.json';
  File exportFile;
  exportFile = await writeData(data: cards, fileName: filepath);
  return exportFile;
}

Future zipRootFiles({List<int>? rootIds, List<String>? tokens}) async {
  final GlobalKey<State> dialogKey = GlobalKey<State>();

  var roots = await RootGroup().select().toList();
  String fileName = '';
  List<File> files = [];
  // Filter and save selected Roots
  if (rootIds != null && rootIds.length > 0) {
    roots.removeWhere((root) => !rootIds.contains(root.id));
    // fileName = subGroups.first.title!;
    fileName = roots.map((e) => "${e.title!}").toString() +
        "-" +
        rootIds.length.toString();
  }

  for (var root in roots) {
    if (root.imagePath != null && root.imagePath!.isNotEmpty) {
      File file = File(root.imagePath!);
      files.add(file);
    }
    var subGroups = await SubGroup()
        .select()
        .rootGroupId
        .equals(root.id)
        .toList(preload: true);
    subGroups = subGroups
        .where((element) =>
            element.password!.isEmpty || element.passwordConfirmed == true)
        .toList();

    for (var book in subGroups) {
      for (var lesson in book.plLessons ?? <Lesson>[]) {
        if (lesson.imagePath != null && lesson.imagePath!.isNotEmpty) {
          File file = File(lesson.imagePath!);
          files.add(file);
        }
        if (lesson.storyImagePath != null &&
            lesson.storyImagePath!.isNotEmpty) {
          File file = File(lesson.storyImagePath!);
          files.add(file);
        }
        if (lesson.storyVoicePathOne != null &&
            lesson.storyVoicePathOne!.isNotEmpty) {
          File file = File(lesson.storyVoicePathOne!);
          files.add(file);
        }
        if (lesson.storyVoicePathTwo != null &&
            lesson.storyVoicePathTwo!.isNotEmpty) {
          File file = File(lesson.storyVoicePathTwo!);
          files.add(file);
        }
        if (lesson.descriptionImagePath != null &&
            lesson.descriptionImagePath!.isNotEmpty) {
          File file = File(lesson.descriptionImagePath!);
          files.add(file);
        }
        if (lesson.descriptionVoicePathOne != null &&
            lesson.descriptionVoicePathOne!.isNotEmpty) {
          File file = File(lesson.descriptionVoicePathOne!);
          files.add(file);
        }
        if (lesson.descriptionVoicePathTwo != null &&
            lesson.descriptionVoicePathTwo!.isNotEmpty) {
          File file = File(lesson.descriptionVoicePathTwo!);
          files.add(file);
        }
        List<TblCard> cards = await lesson.getTblCards()!.toList();
        for (var card in cards) {
          if (card.imagePath != null && card.imagePath!.isNotEmpty) {
            File file = File(card.imagePath!);
            files.add(file);
          }
          if (card.questionVoicePath != null &&
              card.questionVoicePath!.isNotEmpty) {
            File file = File(card.questionVoicePath!);
            files.add(file);
          }
          if (card.replyVoicePath != null && card.replyVoicePath!.isNotEmpty) {
            File file = File(card.replyVoicePath!);
            files.add(file);
          }
          if (card.descriptionVoicePath != null &&
              card.descriptionVoicePath!.isNotEmpty) {
            File file = File(card.descriptionVoicePath!);
            files.add(file);
          }
        }
      }
    }
  }

  List<File> uniqueFiles = [];
  for (var file in files) {
    if (uniqueFiles.where((element) => element.path == file.path).length == 0) {
      uniqueFiles.add(file);
    }
  }
  if (tokens != null && tokens.length != 0) {
    File tokenFile = File((await getApplicationPath()) + '/tokens.txt');
    String tokensText = tokens.join(',');
    await tokenFile.writeAsString(tokensText);
    uniqueFiles.add(tokenFile);
  }
  try {
    uniqueFiles.add(await writeRootsToJson(roots));
  } catch (e) {
    Get.snackbar('warning'.tr, e.toString());
  }

  final sourceDir = await pickFolder();
  if (sourceDir == null) {
    Get.snackbar('warning'.tr, 'You must select folder');
    return;
  }
  String appPath = await getApplicationPath();
  final zipFile = File(appPath + '/$fileName.zip');
  bool isZipFileExist = await zipFile.exists();
  if (isZipFileExist) {
    await zipFile.delete();
  }

  // final zipFile = File(sourceDir!.path + '/$fileName.zip');
  // bool isZipFileExist = await zipFile.exists();
  // if (isZipFileExist) {
  //   await zipFile.delete();
  // }
  PermissionStatus status = await Permission.storage.request();

  try {
    await UITools(Get.context!).showWaitScreen('Waiting', null, dialogKey);
    await flutterarchive.ZipFile.createFromFiles(
        sourceDir: Directory(await getApplicationPath()),
        files: uniqueFiles,
        zipFile: zipFile);
    Uint8List data = await File(zipFile.path).readAsBytes();
    // final key = encrype.Key.fromUtf8(
    //     'my 32 length key................'); //W2D7!LsJf5WX&C34G+Ah-yNgaS?S*g2U
    final key = encrype.Key.fromUtf8('W2D7!LsJf5WX&C34G+Ah-yNgaS?S*g2U');
    final iv = encrype.IV.fromLength(16);
    final encrypter = encrype.Encrypter(encrype.AES(key));
    final encrypted = encrypter.encryptBytes(data, iv: iv);
    File encodeFile = await File(sourceDir.path + '/$fileName.aes')
        .writeAsBytes(encrypted.bytes);
    Share.shareFiles([encodeFile.path], text: 'Share Export File');
    if (dialogKey.currentContext != null)
      Navigator.of(dialogKey.currentContext!).pop();
  } catch (e) {
    Get.snackbar('warning', e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 10));
  }
}

Future zipAllFiles(RootGroup rootGroup,
    {List<int>? bookIds, List<String>? tokens}) async {
  final GlobalKey<State> dialogKey = GlobalKey<State>();

  String fileName = rootGroup.title!;
  var subGroups = await SubGroup()
      .select()
      .rootGroupId
      .equals(rootGroup.id)
      .toList(preload: true);
  subGroups = subGroups
      .where((element) =>
          element.password!.isEmpty || element.passwordConfirmed == true)
      .toList();

  List<File> files = [];

  if (bookIds != null && bookIds.length > 0) {
    subGroups.removeWhere((book) => !bookIds.contains(book.id));
    // fileName = subGroups.first.title!;
    fileName = fileName + '_' + bookIds.length.toString();
  }

  for (var book in subGroups) {
    if (book.imagePath != null && book.imagePath!.isNotEmpty) {
      File file = File(book.imagePath!);
      files.add(file);
    }

    for (var lesson in book.plLessons ?? <Lesson>[]) {
      if (lesson.imagePath != null && lesson.imagePath!.isNotEmpty) {
        File file = File(lesson.imagePath!);
        files.add(file);
      }
      if (lesson.storyImagePath != null && lesson.storyImagePath!.isNotEmpty) {
        File file = File(lesson.storyImagePath!);
        files.add(file);
      }
      if (lesson.storyVoicePathOne != null &&
          lesson.storyVoicePathOne!.isNotEmpty) {
        File file = File(lesson.storyVoicePathOne!);
        files.add(file);
      }
      if (lesson.storyVoicePathTwo != null &&
          lesson.storyVoicePathTwo!.isNotEmpty) {
        File file = File(lesson.storyVoicePathTwo!);
        files.add(file);
      }
      if (lesson.descriptionImagePath != null &&
          lesson.descriptionImagePath!.isNotEmpty) {
        File file = File(lesson.descriptionImagePath!);
        files.add(file);
      }
      if (lesson.descriptionVoicePathOne != null &&
          lesson.descriptionVoicePathOne!.isNotEmpty) {
        File file = File(lesson.descriptionVoicePathOne!);
        files.add(file);
      }
      if (lesson.descriptionVoicePathTwo != null &&
          lesson.descriptionVoicePathTwo!.isNotEmpty) {
        File file = File(lesson.descriptionVoicePathTwo!);
        files.add(file);
      }
      List<TblCard> cards = await lesson.getTblCards()!.toList();
      for (var card in cards) {
        if (card.imagePath != null && card.imagePath!.isNotEmpty) {
          File file = File(card.imagePath!);
          files.add(file);
        }
        if (card.questionVoicePath != null &&
            card.questionVoicePath!.isNotEmpty) {
          File file = File(card.questionVoicePath!);
          files.add(file);
        }
        if (card.replyVoicePath != null && card.replyVoicePath!.isNotEmpty) {
          File file = File(card.replyVoicePath!);
          files.add(file);
        }
        if (card.descriptionVoicePath != null &&
            card.descriptionVoicePath!.isNotEmpty) {
          File file = File(card.descriptionVoicePath!);
          files.add(file);
        }
      }
    }
  }
  List<File> uniqueFiles = [];
  for (var file in files) {
    if (uniqueFiles.where((element) => element.path == file.path).length == 0) {
      uniqueFiles.add(file);
    }
  }
  if (tokens != null && tokens.length != 0) {
    File tokenFile = File((await getApplicationPath()) + '/tokens.txt');
    String tokensText = tokens.join(',');
    await tokenFile.writeAsString(tokensText);
    uniqueFiles.add(tokenFile);
  }
  try {
    uniqueFiles.add(await writeTablesToJson(subGroups));
  } catch (e) {
    Get.snackbar('warning'.tr, e.toString());
  }

  final sourceDir = await pickFolder();
  if (sourceDir == null) {
    Get.snackbar('warning'.tr, 'You must select folder');
    return;
  }
  String appPath = await getApplicationPath();
  final zipFile = File(appPath + '/$fileName.zip');
  bool isZipFileExist = await zipFile.exists();
  if (isZipFileExist) {
    await zipFile.delete();
  }

  // final zipFile = File(sourceDir!.path + '/$fileName.zip');
  // bool isZipFileExist = await zipFile.exists();
  // if (isZipFileExist) {
  //   await zipFile.delete();
  // }
  PermissionStatus status = await Permission.storage.request();

  await UITools(Get.context!).showWaitScreen('Waiting', null, dialogKey);
  try {
    await flutterarchive.ZipFile.createFromFiles(
        sourceDir: Directory(await getApplicationPath()),
        files: uniqueFiles,
        zipFile: zipFile);
    Uint8List data = await File(zipFile.path).readAsBytes();
    // final key = encrype.Key.fromUtf8(
    //     'my 32 length key................'); //W2D7!LsJf5WX&C34G+Ah-yNgaS?S*g2U
    final key = encrype.Key.fromUtf8('W2D7!LsJf5WX&C34G+Ah-yNgaS?S*g2U');
    final iv = encrype.IV.fromLength(16);
    final encrypter = encrype.Encrypter(encrype.AES(key));
    final encrypted = encrypter.encryptBytes(data, iv: iv);
    File encodeFile = await File(sourceDir.path + '/$fileName.aes')
        .writeAsBytes(encrypted.bytes);
    Share.shareFiles([encodeFile.path], text: 'Share Export File');
    if (dialogKey.currentContext != null)
      Navigator.of(dialogKey.currentContext!).pop();
  } catch (e) {
    if (dialogKey.currentContext != null)
      Navigator.of(dialogKey.currentContext!).pop();
    Get.back();
    Future.delayed(Duration(seconds: 1)).then((value) => Get.snackbar(
        'warning', e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 10)));
  }
}

Future<File> writeRootsToJson(List<RootGroup> temp) async {
  for (var root in temp) {
    if (root.plSubGroups == null) {
      root.plSubGroups = await SubGroup()
          .select()
          .rootGroupId
          .equals(root.id)
          .toList(preload: true);
    }
  }
  var x = temp.map((e) => e.toCustomJson()).toList();
  String cards = json.encode(x);
  String filepath = Uuid().v4() + '.json';
  File exportFile;
  exportFile = await writeData(data: cards, fileName: filepath);
  return exportFile;
}

Future<File> writeTablesToJson(List<SubGroup> temp) async {
  for (var book in temp) {
    if (book.plLessons == null) {
      book.plLessons = await Lesson()
          .select()
          .subGroupId
          .equals(book.id)
          .toList(preload: true);
    }
  }
  var x = temp.map((e) => e.toCustomJson()).toList();
  String cards = json.encode(x);
  String filepath = Uuid().v4() + '.json';
  File exportFile;
  exportFile = await writeData(data: cards, fileName: filepath);
  return exportFile;
}

Future importFolders(String zipFilePath,
    {RootGroup? rootGroup, SubGroup? subgroup}) async {
  bool? isBook;
  bool hasError = false;

  if (zipFilePath != null) {
    // print(path);

    String content = (await new File(zipFilePath).readAsString());
    if (Platform.isIOS) {
      final directory = await getApplicationPath();
      //TODO CHANGE PAHT FOR IOS FOMR USER/0/... TO IOS FORMAT
      content = content.replaceAll(
          '/data/user/0/com.drehsani.Fast_learning/app_flutter', directory);
      content = content.replaceAll(
          '/data/user/0/com.example.base_flutter_app/app_flutter', directory);

      // Android-specific code
    } else {
      // iOS-specific code
      content = content.replaceAll(
          'com.example.base_flutter_app', 'com.drehsani.Fast_learning');
    }

    Iterable iterable = json.decode(content);
    for (var root in iterable) {
      var newRootGroup = RootGroup.fromMap(root);
      int? newRootGroupId = await newRootGroup.save();
      if (newRootGroup.isDeleted == null) {
        // Get.back(); //close waitning window
        hasError = true;
        await Future.delayed(Duration(seconds: 2)).then((value) {
          Get.snackbar('WARNING',
              'You can only import folders in Folders page!\nGo to the Folder page and import it again.\n',
              duration: Duration(seconds: 5),
              backgroundColor: Colors.red,
              colorText: Colors.white);
        });
        return;
      }

      for (var item in root['books']) {
        //var subGroup = SubGroup.fromMap(item, includeId: false);
        var subGroup = SubGroup.fromMap(item);

        if (subGroup.boxCount != null) {
          //شرط برای تشخیص اینکه حلقه برای کتاب تشکیل شود یا درس
          if (newRootGroup == null) {
            // Get.back(); //close waitning window
            hasError = true;
            await Future.delayed(Duration(seconds: 2)).then((value) {
              Get.snackbar('WARNING',
                  'Importing Books into Lessons Section!\nGo to the Books section and import it again.\n',
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
            });
            return;
          }
          subGroup.rootGroupId = newRootGroupId;
          isBook = true;
          //  subGroup.id = null ;
          int? subGroupId = await subGroup.save();
          for (var lesson in item['lessons']) {
            var lessonTemp = Lesson.fromMap(lesson);
            //  lessonTemp.id=null;
            lessonTemp.subGroupId = subGroupId;
            int? lessonId = await lessonTemp.save();
            for (var card in lesson['cards']) {
              var cardTemp = TblCard.fromMap(card);
              cardTemp.boxNumber = 0;
              cardTemp.reviewStart = false;
              cardTemp.examDone = false;
              cardTemp.boxVisibleDate = DateTime.now();
              // cardTemp.id=null;
              cardTemp.lessonId = lessonId;
              cardTemp.save();
            }
          }
        } else {
          var lesson = Lesson.fromMap(item);
          if (subgroup == null) {
            // Get.back(); //close waitning window
            hasError = true;
            await Future.delayed(Duration(seconds: 2)).then((value) {
              Get.snackbar('WARNING',
                  'Importing Lessons into Books Section!\nGo to the Lessons section and import it again.\n',
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
            });
            return;
          }
          lesson.subGroupId = subgroup.id;
          isBook = false;
          int? lessonId = await lesson.save();
          for (var card in item['cards']) {
            var cardTemp = TblCard.fromMap(card);
            cardTemp.boxNumber = 0;
            cardTemp.reviewStart = false;
            cardTemp.examDone = false;
            cardTemp.boxVisibleDate = DateTime.now();
            cardTemp.lessonId = lessonId;
            cardTemp.save();
          }
        }
      }
    }

    // Get.back();

    if (!hasError) {
      if (isBook != null && isBook) {
        await Future.delayed(Duration(seconds: 3)).then((value) {
          Get.snackbar('Done', 'All books imported to the database.',
              backgroundColor: Colors.green, colorText: Colors.white);
        });
      } else {
        await Future.delayed(Duration(seconds: 3)).then((value) {
          Get.snackbar('Done', 'All lessons imported to the database.',
              backgroundColor: Colors.green, colorText: Colors.white);
        });
      }
    }
  }
}

Future importCards(String zipFilePath,
    {RootGroup? rootGroup, SubGroup? subgroup}) async {
  bool? isBook;
  bool hasError = false;

  if (zipFilePath != null) {
    // print(path);

    String content = (await new File(zipFilePath).readAsString());
    if (Platform.isIOS) {
      final directory = await getApplicationPath();
      //TODO CHANGE PAHT FOR IOS FOMR USER/0/... TO IOS FORMAT
      content = content.replaceAll(
          '/data/user/0/com.drehsani.Fast_learning/app_flutter', directory);
      content = content.replaceAll(
          '/data/user/0/com.example.base_flutter_app/app_flutter', directory);

      // Android-specific code
    } else {
      // iOS-specific code
      content = content.replaceAll(
          'com.example.base_flutter_app', 'com.drehsani.Fast_learning');
    }
    Iterable iterable = json.decode(content);
    for (var item in iterable) {
      //var subGroup = SubGroup.fromMap(item, includeId: false);
      var subGroup = SubGroup.fromMap(item);

      if (subGroup.boxCount != null) {
        //شرط برای تشخیص اینکه حلقه برای کتاب تشکیل شود یا درس
        if (rootGroup == null) {
          // Get.back(); //close waitning window
          hasError = true;
          await Future.delayed(Duration(seconds: 2)).then((value) {
            Get.snackbar('WARNING',
                'Importing Books into Lessons Section!\nGo to the Books section and import it again.\n',
                duration: Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white);
          });
          return;
        }
        subGroup.rootGroupId = rootGroup.id;
        isBook = true;
        //  subGroup.id = null ;
        int? subGroupId = await subGroup.save();
        for (var lesson in item['lessons']) {
          var lessonTemp = Lesson.fromMap(lesson);
          //  lessonTemp.id=null;
          lessonTemp.subGroupId = subGroupId;
          int? lessonId = await lessonTemp.save();
          for (var card in lesson['cards']) {
            var cardTemp = TblCard.fromMap(card);
            cardTemp.boxNumber = 0;
            cardTemp.reviewStart = false;
            cardTemp.examDone = false;
            cardTemp.boxVisibleDate = DateTime.now();
            // cardTemp.id=null;
            cardTemp.lessonId = lessonId;
            cardTemp.save();
          }
        }
      } else {
        var lesson = Lesson.fromMap(item);
        if (subgroup == null) {
          // Get.back(); //close waitning window
          hasError = true;
          await Future.delayed(Duration(seconds: 2)).then((value) {
            Get.snackbar('WARNING',
                'Importing Lessons into Books Section!\nGo to the Lessons section and import it again.\n',
                duration: Duration(seconds: 5),
                backgroundColor: Colors.red,
                colorText: Colors.white);
          });
          return;
        }
        lesson.subGroupId = subgroup.id;
        isBook = false;
        int? lessonId = await lesson.save();
        for (var card in item['cards']) {
          var cardTemp = TblCard.fromMap(card);
          cardTemp.boxNumber = 0;
          cardTemp.reviewStart = false;
          cardTemp.examDone = false;
          cardTemp.boxVisibleDate = DateTime.now();
          cardTemp.lessonId = lessonId;
          cardTemp.save();
        }
      }
    }
    // Get.back();

    if (!hasError) {
      if (isBook != null && isBook) {
        await Future.delayed(Duration(seconds: 3)).then((value) {
          Get.snackbar('Done', 'All books imported to the database.',
              backgroundColor: Colors.green, colorText: Colors.white);
        });
      } else {
        await Future.delayed(Duration(seconds: 3)).then((value) {
          Get.snackbar('Done', 'All lessons imported to the database.',
              backgroundColor: Colors.green, colorText: Colors.white);
        });
      }
    }
  }
}

Future<Directory?> pickDirectory(BuildContext context) async {
  Directory? selectedDirectory;
  Directory? directory = selectedDirectory;
  if (directory == null) {
    directory = Directory(FolderPicker.rootPath);
  }
  Directory? newDirectory = await FolderPicker.pick(
      allowFolderCreation: true,
      context: context,
      rootDirectory: directory,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))));

  selectedDirectory = newDirectory;

  return selectedDirectory;
}

Future<Directory?> pickFolder() async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory != null) {
    return Directory(selectedDirectory);
  }
}

Future<File> createLocalFile(
    {required String fileName, required bool fileCreateIfNotExist}) async {
  final path = await getApplicationPath();
  return File('$path/$fileName').create(recursive: fileCreateIfNotExist);
}

Future<File> writeData({required String data, required String fileName}) async {
  bool isExisZipFile = await File(fileName).exists();
  if (isExisZipFile) {
    await File(fileName).delete();
  }
  final file =
      await createLocalFile(fileName: fileName, fileCreateIfNotExist: true);
  // Write the file.
  File jsonFile = await file.writeAsString('$data', mode: FileMode.writeOnly);
  return jsonFile;
}

/*
[ko-KR, mr-IN, ru-RU, zh-TW, hu-HU, th-TH, ur-PK, nb-NO, da-DK, tr-TR, et-EE, bs, sw, pt-PT,
 vi-VN, en-US, sv-SE, ar, su-ID, bn-BD, gu-IN, kn-IN, el-GR, hi-IN, fi-FI, km-KH, bn-IN,
 fr-FR, uk-UA, en-AU, nl-NL, fr-CA, sr, pt-BR, ml-IN, si-LK, de-DE, ku, cs-CZ, pl-PL, sk-SK,
 fil-PH, it-IT, ne-NP, ms-MY, hr, en-NG, zh-CN, es-ES, cy, ta-IN, ja-JP, sq, yue-HK, en-IN,
 es-US, jv-ID, la, id-ID, te-IN, ro-RO, ca, en-GB]

*/

String getLangForTTS(int? langIndex) {
  String result = 'en-us';
  switch (langIndex) {
    case 0:
      result = 'en-US';
      break;
    case 1:
      result = 'en-UK';
      break;
    case 2:
      result = 'fr-FR';
      break;
    case 3:
      result = 'de-DE';
      break;
    case 4:
      result = 'es-ES';
      break;
    case 5:
      result = 'ru-RU';
      break;
    case 6:
      result = 'tr-TR';
      break;
    case 7:
      result = 'ar';
      break;
    case 8:
      result = 'zh-CN';
      break;
    case 9:
      result = 'ja-JP';
      break;
    case 10:
      result = 'en-US';
      break;
  }
  return result;
}

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);
Future<String> fileUploadMultipart(
    {File? file, OnUploadProgressCallback? onUploadProgress}) async {
  assert(file != null);

  final url = 'http://192.168.1.105:5000/Upload/saveFile';

  final httpClient = getHttpClient();

  final request = await httpClient.postUrl(Uri.parse(url));

  int byteCount = 0;

  var multipart = await http.MultipartFile.fromPath(
    'file',
    file!.path,
    contentType: new MediaType('application', 'x-tar'),
  );

  // final fileStreamFile = file.openRead();

  // var multipart = MultipartFile("file", fileStreamFile, file.lengthSync(),
  //     filename: fileUtil.basename(file.path));

  var requestMultipart = http.MultipartRequest(
      "POST", Uri.parse("http://192.168.1.105:5000/Upload/saveFile"));

  requestMultipart.files.add(multipart);

  var msStream = requestMultipart.finalize();

  var totalByteLength = requestMultipart.contentLength;

  request.contentLength = totalByteLength;

  request.headers.set(HttpHeaders.contentTypeHeader,
      requestMultipart.headers[HttpHeaders.contentTypeHeader]!);

  Stream<List<int>> streamUpload = msStream.transform(
    new StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data);

        byteCount += data.length;

        if (onUploadProgress != null) {
          onUploadProgress(byteCount, totalByteLength);
          // CALL STATUS CALLBACK;
        }
      },
      handleError: (error, stack, sink) {
        throw error;
      },
      handleDone: (sink) {
        sink.close();
        // UPLOAD DONE;
      },
    ),
  );

  await request.addStream(streamUpload);

  final httpResponse = await request.close();
//
  var statusCode = httpResponse.statusCode;

  if (statusCode ~/ 100 != 2) {
    throw Exception(
        'Error uploading file, Status code: ${httpResponse.statusCode}');
  } else {
    return await readResponseAsString(httpResponse);
  }
}

Future<String> readResponseAsString(HttpClientResponse response) {
  var completer = new Completer<String>();
  var contents = new StringBuffer();
  response.transform(utf8.decoder).listen((String data) {
    contents.write(data);
  }, onDone: () => completer.complete(contents.toString()));
  return completer.future;
}

bool trustSelfSigned = true;
HttpClient getHttpClient() {
  HttpClient httpClient = new HttpClient()
    ..connectionTimeout = const Duration(seconds: 10)
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);

  return httpClient;
}
