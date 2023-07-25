import 'package:http/http.dart' as http;
import 'dart:convert';

class Service {
  Future<bool> addImage(Map<String, String> body, String filepath) async {
    String addimageUrl = '<domain-name>/api/imageadd';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
