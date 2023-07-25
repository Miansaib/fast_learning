import 'package:get/get.dart';

import '../model/model.dart';

class MainBookController extends GetxController {
  Future<List<SubGroup>> getSubGroups() async {
    bookItem = await SubGroup().select().toList();
    return bookItem;
  }

  var _bookItem = <SubGroup>[].obs;
  List<SubGroup> get bookItem => _bookItem;
  // Define a setter for the bookItem
  set bookItem(List<SubGroup> value) {
    _bookItem(value);
  }

  var _bookId = <int>[].obs;
  List<int> get bookId => _bookId;
  // Define a setter for the bookId
  set bookId(List<int> value) {
    _bookId(value);
  }

  var _isSelection = false.obs;
  bool get isSelection => _isSelection.value;
  // Define a setter for the isSelection
  set isSelection(bool value) {
    _isSelection(value);
  }

  var _editBook = false.obs;
  bool get editBook => _editBook.value;
  // Define a setter for the editBook
  set editBook(bool value) {
    _editBook(value);
  }

  var _isEditPosition = false.obs;
  bool get isEditPosition => _isEditPosition.value;
  // Define a setter for the isEditPosition
  set isEditPosition(bool value) {
    _isEditPosition(value);
  }

  var _isLock = false.obs;
  bool get isLock => _isLock.value;
  // Define a setter for the isLock
  set isLock(bool value) {
    _isLock(value);
  }

  void selectionMethod(int index) {
    if (bookId.contains(index)) {
      bookId.remove(index);
    } else {
      bookId.add(index);
    }
    if (bookId.length > 0)
      isSelection = true;
    else
      isSelection = false;

    if (bookId.length == 1)
      editBook = true;
    else
      editBook = false;

    update();
  }

  Future<Map<String, num>> getInfo(SubGroup book) async {
    final Map<String, num> data = {};
    int total = 0;

    int sumOfLesson = 0;
    int allCards = 0;
    int sumOfProgress = 0;

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

    print(sumOfProgress / total);

    data['lessons'] = sumOfLesson;
    data['cards'] = allCards;
    if (total == 0)
      data['progress'] = 0;
    else
      data['progress'] = (sumOfProgress / total);
    return data;
  }

  Future<double> getinfo1(SubGroup book) async {
    final lessons = await Lesson()
        .select(columnsToSelect: [
          LessonFields.id.toString(),
          LessonFields.subGroupId.toString(),
        ])
        .subGroupId
        .equals(book.id)
        .toList();

    int sumOfProgress = 0;
    int sumOfCards = 0;
    for (var lesson in lessons) {
      final cards = await TblCard()
          .select(columnsToSelect: [
            TblCardFields.lessonId.toString(),
            TblCardFields.boxNumber.toString(),
          ])
          .lessonId
          .equals(lesson.id)
          .toList();
      for (var card in cards) {
        sumOfProgress += card.boxNumber!;
        sumOfCards += cards.length;
      }
    }

    final total = book.boxCount! * sumOfCards;
    if (total == 0) return 0;
    return (sumOfProgress / total);

    return .33;
  }

  Future<int> getFlashCardCount(SubGroup book) async {
    return 2;
  }
}
