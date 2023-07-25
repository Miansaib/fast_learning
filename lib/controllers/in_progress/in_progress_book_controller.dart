import 'package:Fast_learning/model/model.dart';
import 'package:get/get.dart';

class InProgressBookController extends GetxController {
  Future<List<SubGroup>> getSubGroups() async {
    return await SubGroup().select().toList();
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
