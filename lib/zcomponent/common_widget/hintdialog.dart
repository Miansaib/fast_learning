import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget hintDialog(String? title, String? hint, {String? backbtn}) {
  return IconButton(
      icon: Icon(Icons.info_outline),
      onPressed: () {
        Get.bottomSheet(
          myBottomSheetWidget(title, hint, backbtn),
          isScrollControlled: true,
        );
      });
}

Container myBottomSheetWidget(String? title, String? hint, String? backbtn) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(8), topLeft: Radius.circular(8)),
      color: Color(0xff353535),
    ),
    child: Container(
      height: Get.size.height * 0.3, // set a maximum height
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sticky title
              Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    title ?? "Export and share all books: ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              // Body
              Expanded(
                child: ListView(
                  children: [
                    // Add your content here
                    SizedBox(
                      width: 342,
                      child: Text(
                        hint ??
                            "you can also Export all your books to other users. you can set a password or limit use for some users this option is very useful when you want to sell your books.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  backbtn ?? "SKIP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
