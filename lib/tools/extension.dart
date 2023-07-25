import 'package:Fast_learning/model/model.dart';

extension StringExtension on String {
  String capitalizer() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension customGroup on RootGroup {
  Map toCustomJson() {
    var books = this.plSubGroups == null
        ? null
        : this.plSubGroups!.map((e) => e.toCustomJson()).toList();
    return {
      'serverId': this.serverId,
      'videoUrl': this.videoUrl,
      'serverSync': this.serverSync,
      'title': this.title,
      'imagePath': this.imagePath,
      'isDeleted': this.isDeleted,
      'books': books,
    };
  }
}

extension customSubGroup on SubGroup {
  Map toCustomJson() {
    var lessons = this.plLessons == null
        ? null
        : this.plLessons!.map((e) => e.toCustomJson()).toList();
    return {
      'title': this.title,
      'orderIndex': this.orderIndex,
      'password': this.password,
      'ratio': this.ratio,
      'caseType': this.caseType,
      'countTime': this.countTime,
      'unitTime': this.unitTime,
      'boxCount': this.boxCount,
      'languageItemOne': this.languageItemOne,
      'languageItemTwo': this.languageItemTwo,
      'languageItemThree': this.languageItemThree,
      'rootGroupId': this.rootGroupId,
      'imagePath': this.imagePath,
      'lessons': lessons,
    };
  }
}

extension customLesson on Lesson {
  Map toCustomJson() {
    var cards = this.plTblCards == null
        ? null
        : this.plTblCards!.map((e) => e.toCustomJson()).toList();
    return {
      'title': this.title,
      'orderIndex': this.orderIndex,
      'imagePath': this.imagePath,
      'storyTitle': this.storyTitle,
      'storyDesc': this.storyDesc,
      'storyImagePath': this.storyImagePath,
      'storyVoicePathOne': this.storyVoicePathOne,
      'storyVoicePathTwo': this.storyVoicePathTwo,
      'descriptionTitle': this.descriptionTitle,
      'descriptionDesc': this.descriptionDesc,
      'descriptionImagePath': this.descriptionImagePath,
      'descriptionVoicePathOne': this.descriptionVoicePathOne,
      'descriptionVoicePathTwo': this.descriptionVoicePathTwo,
      'subGroupId': this.subGroupId,
      'cards': cards
    };
  }
}

extension customCard on TblCard {
  Map toCustomJson() {
    return {
      'question': this.question,
      'orderIndex': this.orderIndex,
      'questionVoicePath': this.questionVoicePath,
      'ratio': this.ratio,
      'reply': this.reply,
      'replyVoicePath': this.replyVoicePath,
      'description': this.description,
      'descriptionVoicePath': this.descriptionVoicePath,
      'imagePath': this.imagePath,
      'dateCreated': this.dateCreated.toString(),
      'examDone': this.examDone,
      'boxNumber': this.boxNumber,
      'boxVisibleDate': this.boxVisibleDate.toString(),
      'lessonId': this.lessonId
    };
  }
}
