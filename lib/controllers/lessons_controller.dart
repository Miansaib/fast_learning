import 'package:get/get.dart';

import '../model/model.dart';

class MainLessonsController extends GetxController {
  Future<List<SubGroup>> getSubGroups() async {
    lessonItem = await SubGroup().select().toList();
    return lessonItem;
  }

  var _lessonItem = <SubGroup>[].obs;
  List<SubGroup> get lessonItem => _lessonItem;
  // Define a setter for the lessonItem
  set lessonItem(List<SubGroup> value) {
    _lessonItem(value);
  }

  var _lessonId = <int>[].obs;
  List<int> get lessonId => _lessonId;
  // Define a setter for the lessonId
  set lessonId(List<int> value) {
    _lessonId(value);
  }

  var _isSelection = false.obs;
  bool get isSelection => _isSelection.value;
  // Define a setter for the isSelection
  set isSelection(bool value) {
    _isSelection(value);
  }

  var _editLesson = false.obs;
  bool get editLesson => _editLesson.value;
  // Define a setter for the editLesson
  set editLesson(bool value) {
    _editLesson(value);
  }

  var _isEditPosition = false.obs;
  bool get isEditPosition => _isEditPosition.value;
  // Define a setter for the isEditPosition
  set isEditPosition(bool value) {
    _isEditPosition(value);
  }

  void selectionMethod(int index) {
    if (lessonId.contains(index)) {
      lessonId.remove(index);
    } else {
      lessonId.add(index);
    }
    if (lessonId.length > 0)
      isSelection = true;
    else
      isSelection = false;

    if (lessonId.length == 1)
      editLesson = true;
    else
      editLesson = false;

    update();
  }

  Future<double> getinfo(Lesson e) async {
    final book = await e.getSubGroup();
    final cards = await e.getTblCards()!.toList();
    final total = book!.boxCount! * cards.length;
    if (total == 0) return 0;
    int sumOfProgress = 0;
    for (var card in cards) {
      sumOfProgress += card.boxNumber!;
    }
    return (sumOfProgress / total);
  }
}
