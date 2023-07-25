import 'package:get/get.dart';

import '../model/model.dart';

class MainReviewController extends GetxController {
  Future<List<SubGroup>> getSubGroups() async {
    // booksItem = await SubGroup().select().toList();
    return booksItem;
  }

  var _booksItem = <SubGroup>[].obs;
  List<SubGroup> get booksItem => _booksItem;
  // Define a setter for the booksItem
  set booksItem(List<SubGroup> value) {
    _booksItem(value);
  }

  var _booksId = <int>[].obs;
  List<int> get booksId => _booksId;
  // Define a setter for the booksId
  set booksId(List<int> value) {
    _booksId(value);
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

  void selectionMethod(int index) {
    if (booksId.contains(index)) {
      booksId.remove(index);
    } else {
      booksId.add(index);
    }
    if (booksId.length > 0)
      isSelection = true;
    else
      isSelection = false;

    if (booksId.length == 1)
      editBook = true;
    else
      editBook = false;

    update();
  }

  Future<double> getinfo(SubGroup book) async {
    final lessons = await Lesson()
        .select(columnsToSelect: [
          LessonFields.id.toString(),
          LessonFields.subGroupId.toString(),
        ])
        .subGroupId
        .equals(book.id)
        .toList();

    print('hi');

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
}
