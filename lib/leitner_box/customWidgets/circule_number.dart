import 'package:flutter/material.dart';

Widget rounded_icon_folder_info(Color color, int reviewStart) {
  return Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: color,
        width: 1,
      ),
      color: Colors.white,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          reviewStart.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    ),
  );
}
