import 'package:flutter/material.dart';

class checkBox extends StatelessWidget {
  checkBox({this.isCheck = false, Key? key}) : super(key: key);

  bool isCheck;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xff353535), width: 2),
              borderRadius: BorderRadius.circular(6)),
          child: isCheck
              ? Icon(Icons.check, color: Color(0xff353535), size: 14)
              : Container()),
    );
  }
}
