import 'dart:convert';
import 'dart:math';

import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/leitner_box/screens/popupScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Fast_learning/tools/extension.dart';

class AllData {
  List<Categories>? categories;
  List<Books>? books;

  AllData({this.categories, this.books});

  AllData.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(new Books.fromJson(v));
      });
    }
  }
}

class Categories {
  int id;
  String title;
  String description;
  String image;

  Categories(
      {required this.id,
      required this.title,
      required this.description,
      required this.image});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
        id: json['id'],
        title: json['title'].toString().capitalizer(),
        description: json['description'].toString().capitalizer(),
        image: json['image'].toString().replaceFirstMapped(
            RegExp('(?:[0-9]{1,3}\.){3}[0-9]{1,3}'),
            (match) => match[0]! + ':8000'));
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'description': description, 'image': image};
}

class ImageData {
  final int id;
  final String videoLink;
  final bool isVideo;
  final String image;

  ImageData({
    required this.id,
    required this.videoLink,
    required this.isVideo,
    required this.image,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'],
      videoLink: json['video_link'] ?? "",
      isVideo: json['isVideo'],
      image: (json['image'] ?? "").toString().replaceFirstMapped(
          RegExp('(?:[0-9]{1,3}\.){3}[0-9]{1,3}'),
          (match) => match[0]! + ':8000'),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}

class Books {
  late int id;
  late String title;
  late String description;
  late List<ImageData> images;
  late String file;
  late bool isPreview;
  late int category;
  late String categoryType;
  late DateTime updatedAt;

  Books({
    required this.id,
    required this.title,
    required this.description,
    required this.file,
    required this.category,
    required this.isPreview,
    required this.images,
    required this.categoryType,
    required this.updatedAt,
  });

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'].toString().capitalizer();
    description = json['description'].toString().capitalizer();

    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images.add(ImageData.fromJson(v));
      });
    }
    file = json['file'].toString().replaceFirstMapped(
        RegExp('(?:[0-9]{1,3}\.){3}[0-9]{1,3}'),
        (match) => match[0]! + ':8000');
    category = json['category'];
    categoryType = json['category_type'];
    updatedAt = DateTime.parse(json['updated_at']);
  }

  bool get isNews => this.categoryType == 'NW';
}

class DownloadController extends GetxController {
  DownloadController() {
    getall();
    SharedPreferences.getInstance().then((prefs) {
      notifVersion = prefs.getInt(Preference.notifVersion) ?? 0;
      if (prefs.getString(Preference.notifLastTime) != null)
        notifLastTime =
            DateTime.parse(prefs.getString(Preference.notifLastTime)!);
      else
        notifLastTime = DateTime.now().subtract(Duration(
          days: 60,
        ));
    });
  }

  var _notifLastTime = DateTime.now()
      .subtract(Duration(
        days: 60,
      ))
      .toString();
  DateTime get notifLastTime => DateTime.parse(_notifLastTime);
  set notifLastTime(DateTime value) {
    _notifLastTime = value.toString();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(Preference.notifLastTime, _notifLastTime);
    });
  }

  var _notifVersion = 0.obs;
  int get notifVersion => _notifVersion.value;
  set notifVersion(int value) {
    _notifVersion(value);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(Preference.notifVersion, value);
    });
  }

  var _index = 0.obs;
  int get index => _index.value;
  set index(int value) {
    _index(value);
  }

  var _filters = <int>[].obs;
  List<int> get filters => _filters;
  set filters(List<int> value) {
    _filters(value);
  }

  var _books = <Books>[].obs;
  List<Books> get books => _books;
  List<Books> get booksWithoutNews => _books.where((p0) => !p0.isNews).toList();
  set books(List<Books> value) {
    _books(value);
  }

  var _filterdBooks = <Books>[].obs;
  List<Books> get filterdBooks => _filterdBooks;
  set filterdBooks(List<Books> value) {
    _filterdBooks(value);
  }

  var _categories = <Categories>[].obs;
  List<Categories> get categories => _categories;
  set categories(List<Categories> value) {
    _categories(value);
  }

  int findMax() {
    return books.reduce((curr, next) => curr.id > next.id ? curr : next).id;
  }

  filterNew({bool showpopup = true}) {
    final maxId = findMax();
    filterdBooks = books
        .where((element) =>
            element.id > notifVersion ||
            element.updatedAt.isAfter(notifLastTime))
        .toList();
    if (filterdBooks.length > 0 && showpopup)
      Get.dialog(
        MyTabbedPopup(),
      );
  }

  void getall({bool showpopup = true}) async {
    var categoryUrl =
        Uri.parse('http://51.222.106.104:8000/categories/?format=json');
    var cardsUrl = Uri.parse('http://51.222.106.104:8000/cards/?format=json');

    Dio().getUri(categoryUrl).then((Response response) {
      if (response.statusCode == 200) {
        List<dynamic> decoded = (response.data);

        categories = decoded.map((e) => Categories.fromJson(e)).toList();
        filters.clear();

        categories.forEach((item) {
          Categories _item = item;
          filters.add(_item.id);
        });
        update();
      }
      print(response);
    });
    Dio().getUri(cardsUrl).then((Response response) {
      if (response.statusCode == 200) {
        List<dynamic> decoded = (response.data);

        books = decoded.map((e) => Books.fromJson(e)).toList();
        books.sort(((a, b) {
          return b.updatedAt.compareTo(a.updatedAt);
        }));
        filterNew(showpopup: showpopup);
      }
    });
  }
}
