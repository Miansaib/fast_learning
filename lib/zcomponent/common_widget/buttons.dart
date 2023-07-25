import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildButton(
    {String? label,
    IconData? icon,
    Color? borderColor,
    Color? iconColor,
    VoidCallback? onPressed,
    double? width = 50,
    double? iconSize = 24,
    bool? isEnabled,
    double? fontSize = 12,
    Image? image}) {
  return ElevatedButton(
    style: ButtonStyle(
        backgroundColor: onPressed != null
            ? (isEnabled ?? false
                ? MaterialStateProperty.all(Get.theme.primaryColor)
                : MaterialStateProperty.all(Colors.white))
            : null,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: borderColor ?? Colors.black,
                )))),
    onPressed: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null)
          Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        if (image != null) image,
        SizedBox(
          width: width,
          child: Text(
            label ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: borderColor,
              fontSize: fontSize,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget textButton(
    {String? label,
    Color? borderColor,
    VoidCallback? onPressed,
    bool? isEnabled}) {
  return ElevatedButton(
    style: ButtonStyle(
        backgroundColor: onPressed != null
            ? (isEnabled ?? false
                ? MaterialStateProperty.all(Get.theme.primaryColor)
                : MaterialStateProperty.all(Color(0xff27187e)))
            : null,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: borderColor ?? Color(0xff27187e),
                )))),
    onPressed: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Make it!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
