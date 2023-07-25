import 'package:Fast_learning/constants/preference.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Item {
  final String? title;
  final String? description;
  final bool? isImage;
  final String? url;

  Item({this.title, this.description, this.isImage = true, this.url});
}

class InitNotificationController extends GetxController {
  InitNotificationController() {
    SharedPreferences.getInstance().then((prefs) {
      notifVersion = prefs.getInt(Preference.notifVersion) ?? 0;
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

  var _notificationTitle = "New Notification".obs;
  String get notificationTitle => _notificationTitle.value;
  set notificationTitle(String value) {
    _notificationTitle(value);
  }

  var _notificationDescription = "New Books Are Available!".obs;
  String get notificationDescription => _notificationDescription.value;
  set notificationDescription(String value) {
    _notificationDescription(value);
  }

  var _items = <Item>[].obs;
  List<Item> get items => _items;
  set items(List<Item> value) {
    _items(value);
  }

  // Future<bool> fetchData() async {
  //   final url =
  //       "https://docs.google.com/spreadsheets/d/e/2PACX-1vQGTNBUtBz9qvzrSrv2hiBcqGVlY1zptdjrFhkdRxsrUP9N-BBKgdiAUgT-N7mTyqId5a2BjIvpb4Mt/pub?gid=0&single=true&output=csv";
  //   final dio = Dio();
  //   final path = (await getTemporaryDirectory()).path + 'file.csv';
  //   await dio.download(url, path);
  //   final file = File(path);
  //   final savedFile =
  //       File((await getApplicationDocumentsDirectory()).path + 'file.csv');

  //   final csv = file.readAsStringSync().split('\n');
  //   List<Item> items = [];
  //   final head = csv.removeAt(0).split(',');
  //   for (var item in csv) {
  //     final product = item.split(',');
  //     String imageUrl = product[2].startsWith('https://drive.google.com/file')
  //         ? 'https://drive.google.com/uc?export=view&id=' +
  //             product[2].split('//')[1].split('/')[3]
  //         : product[2];
  //     debugPrint(product[3].contains('TRUE').toString());
  //     items.add(Item(
  //       title: product[0],
  //       description: product[1],
  //       url: imageUrl,
  //       isImage: product[3].contains('TRUE'),
  //     ));
  //   }
  // }

}
