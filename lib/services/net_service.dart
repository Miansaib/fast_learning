import 'dart:convert';



import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NetService {
  
  static Future fetchJsonData(String url) {
    Uri uri = Uri.parse(url);
    return
      http.get(uri)
        .then((response) => response.statusCode == 200 ? jsonDecode(response.body) : null)
        .catchError((err) => print(err));
  }

  // static Future fetchLocalJsonData() async {
  //   await Future.delayed(Duration(seconds: 3));

  //   return jsonDecode(transactionData) as Map<String, dynamic>;
  // }
}