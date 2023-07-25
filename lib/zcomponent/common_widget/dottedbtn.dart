import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'hintdialog.dart';

Widget createfolderdottedbtn(String text,
    {Widget? image,
    String? hint,
    double? width,
    double? height,
    Function? onTap}) {
  return InkWell(
    onTap: () => onTap != null ? onTap() : null,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        color: Colors.black,
        strokeWidth: 1,
        dashPattern: [8, 4],
        child: Container(
          width: width ?? (Get.width / 2) - 30,
          height: height ?? Get.size.height * .1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 40,
                offset: Offset(0, 10),
              ),
            ],
            color: Colors.white,
          ),
          // padding: const EdgeInsets.only(
          //   left: 8,
          //   right: 40,
          //   top: 125,
          //   bottom: 5,
          // ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (image != null)
                          Row(
                            children: [
                              Container(width: 20, height: 20, child: image),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        Text(text),
                      ]),
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: width ?? (Get.width / 2) - 30,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8.0),
                      child: Text(
                        hint ??
                            "for making flashcards first you need to make a new folder more more more info more info",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff8a8a8a),
                          fontSize: 10,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: hintDialog(text, hint))
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
