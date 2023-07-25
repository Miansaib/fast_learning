import 'package:flutter/material.dart';
import 'package:get/get.dart';

class app_Bar extends StatelessWidget {
  app_Bar({Key? key, this.title_text, this.canGoBack = true}) : super(key: key);
  String? title_text;
  bool canGoBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          if (canGoBack)
            IconButton(
              onPressed: Navigator.of(context).pop,
              icon: Icon(Icons.arrow_back_ios_new_sharp,
                  size: 22, color: Color(0xff353535)),
            ),
          if (title_text != null) SizedBox(width: 16),
          if (title_text != null)
            Text(
              title_text!,
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            )
        ],
      ),
    );
  }
}
