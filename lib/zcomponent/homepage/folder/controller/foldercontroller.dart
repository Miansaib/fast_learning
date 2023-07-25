import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../../../../model/model.dart';

class FolderController extends GetxController {
  Future<List<RootGroup>> getrootGroups() async {
    foldersItem = await RootGroup().select().orderBy('serverId').toList();
    return foldersItem;
  }

  Future<List<RootGroup>> getReviewStarted() async {
    bool flagBazi = false;
    final Map<String, num> data = {};
    final selectedFolders = <RootGroup>[];
    int total = 0;
    final folders = await RootGroup().select().orderBy('serverId').toList();
    for (var folder in folders) {
      final books = await SubGroup()
          .select(columnsToSelect: [
            SubGroupFields.id.toString(),
            SubGroupFields.rootGroupId.toString(),
            SubGroupFields.boxCount.toString(),
          ])
          .rootGroupId
          .equals(folder.id)
          .toList();
      int sumOfLesson = 0;
      int allCards = 0;
      int sumOfProgress = 0;
      flagBazi = false;
      for (var book in books) {
        final lessons = await Lesson()
            .select(columnsToSelect: [
              LessonFields.id.toString(),
              LessonFields.subGroupId.toString(),
            ])
            .subGroupId
            .equals(book.id)
            .toList();
        sumOfLesson += lessons.length;

        int sumOfCardsinLesson = 0;
        for (var lesson in lessons) {
          final cards = await TblCard()
              .select(columnsToSelect: [
                TblCardFields.lessonId.toString(),
                TblCardFields.boxNumber.toString(),
                TblCardFields.reviewStart.toString(),
              ])
              .lessonId
              .equals(lesson.id)
              .toList();
          if (cards.any((element) => element.reviewStart!)) {
            selectedFolders.add(folder);
            flagBazi = true;
            break;
          }
        }
        if (flagBazi) break;
      }
    }
    return selectedFolders;
    return await RootGroup().select().orderBy('serverId').toList();
  }

  Future<List<RootGroup>> getInProgress() async {
    final Map<String, num> data = {};
    final selectedFolders = <RootGroup>[];
    int total = 0;
    final folders = await RootGroup().select().orderBy('serverId').toList();
    for (var folder in folders) {
      final books = await SubGroup()
          .select(columnsToSelect: [
            SubGroupFields.id.toString(),
            SubGroupFields.rootGroupId.toString(),
            SubGroupFields.boxCount.toString(),
          ])
          .rootGroupId
          .equals(folder.id)
          .toList();
      int sumOfLesson = 0;
      int allCards = 0;
      int sumOfProgress = 0;

      for (var book in books) {
        final lessons = await Lesson()
            .select(columnsToSelect: [
              LessonFields.id.toString(),
              LessonFields.subGroupId.toString(),
            ])
            .subGroupId
            .equals(book.id)
            .toList();
        sumOfLesson += lessons.length;

        int sumOfCardsinLesson = 0;
        for (var lesson in lessons) {
          final cards = await TblCard()
              .select(columnsToSelect: [
                TblCardFields.lessonId.toString(),
                TblCardFields.boxNumber.toString(),
              ])
              .lessonId
              .equals(lesson.id)
              .toList();

          allCards += cards.length;
          sumOfCardsinLesson += cards.length;

          for (var card in cards) {
            sumOfProgress += card.boxNumber!;
          }
        }
        total += (book.boxCount! * sumOfCardsinLesson);
      }

      print("->-> ${sumOfProgress / total}");
      data['books'] = books.length;
      data['lessons'] = sumOfLesson;
      data['cards'] = allCards;
      if (total == 0) {
        data['progress'] = 0;
      } else {
        data['progress'] = (sumOfProgress / total);
        if (data['progress']!.toDouble() > 0) selectedFolders.add(folder);
      }
      // return data;
    }
    return selectedFolders;
    return await RootGroup().select().orderBy('serverId').toList();
  }

  var _foldersItem = <RootGroup>[].obs;
  List<RootGroup> get foldersItem => _foldersItem;
  // Define a setter for the foldersItem
  set foldersItem(List<RootGroup> value) {
    _foldersItem(value);
  }

  var _foldersId = <int>[].obs;
  List<int> get foldersId => _foldersId;
  // Define a setter for the foldersId
  set foldersId(List<int> value) {
    _foldersId(value);
  }

  var _isSelection = false.obs;
  bool get isSelection => _isSelection.value;
  // Define a setter for the isSelection
  set isSelection(bool value) {
    _isSelection(value);
  }

  var _editFolder = false.obs;
  bool get editFolder => _editFolder.value;
  // Define a setter for the editFolder
  set editFolder(bool value) {
    _editFolder(value);
  }

  var _isEditPosition = false.obs;
  bool get isEditPosition => _isEditPosition.value;
  // Define a setter for the isEditPosition
  set isEditPosition(bool value) {
    _isEditPosition(value);
  }

  Future<Map<String, num>> getInfo(RootGroup folder) async {
    final Map<String, num> data = {};
    int total = 0;
    final books = await SubGroup()
        .select(columnsToSelect: [
          SubGroupFields.id.toString(),
          SubGroupFields.rootGroupId.toString(),
          SubGroupFields.boxCount.toString(),
        ])
        .rootGroupId
        .equals(folder.id)
        .toList();
    int sumOfLesson = 0;
    int allCards = 0;
    int sumOfProgress = 0;

    for (var book in books) {
      final lessons = await Lesson()
          .select(columnsToSelect: [
            LessonFields.id.toString(),
            LessonFields.subGroupId.toString(),
          ])
          .subGroupId
          .equals(book.id)
          .toList();
      sumOfLesson += lessons.length;

      int sumOfCardsinLesson = 0;
      for (var lesson in lessons) {
        final cards = await TblCard()
            .select(columnsToSelect: [
              TblCardFields.lessonId.toString(),
              TblCardFields.boxNumber.toString(),
            ])
            .lessonId
            .equals(lesson.id)
            .toList();

        allCards += cards.length;
        sumOfCardsinLesson += cards.length;

        for (var card in cards) {
          sumOfProgress += card.boxNumber!;
        }
      }
      total += (book.boxCount! * sumOfCardsinLesson);
    }
    print(sumOfProgress / total);
    data['books'] = books.length;
    data['lessons'] = sumOfLesson;
    data['cards'] = allCards;
    if (total == 0)
      data['progress'] = 0;
    else
      data['progress'] = (sumOfProgress / total);
    return data;
  }

  void selectionMethod(int index) {
    if (foldersId.contains(index)) {
      foldersId.remove(index);
    } else {
      foldersId.add(index);
    }
    if (foldersId.length > 0)
      isSelection = true;
    else
      isSelection = false;

    if (foldersId.length == 1)
      editFolder = true;
    else
      editFolder = false;

    update();
  }
}
