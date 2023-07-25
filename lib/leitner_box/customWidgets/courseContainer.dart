import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '_checkBox.dart';

class courseContainer extends StatelessWidget {
  courseContainer(
      {Key? key,
        required this.image_path,
        required this.book_name,
        required this.lessons_text,
        required this.notes_text,
        required this.flashcard_text,
        required this.percentage_text,
        required this.circle1,
        required this.circle2,
        required this.circle3,
        required this.percent,
        required this.percent_bg_color,
        required this.percent_progress_color})
      : super(key: key);
  String image_path;
  String book_name;
  String lessons_text;
  String notes_text;
  String flashcard_text;
  String percentage_text;
  String circle1;
  String circle2;
  String circle3;
  double percent;
  Color percent_bg_color;
  Color percent_progress_color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        checkBox(),
        SizedBox(width: 10),
        Image.asset(
          image_path,
          width: 102,
          height: 102,
        ),
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 100, spreadRadius: 1)
                  ]),
              height: 102,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Text(book_name,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ),
                    Positioned(
                      left: 0,
                      top: 30,
                      child: Text(lessons_text,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ),
                    Positioned(
                      left: 0,
                      top: 50,
                      child: Text(notes_text,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Text(flashcard_text,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                    ),
                    Positioned(
                      right: 0,
                      top: 5,
                      child: CircularPercentIndicator(
                        radius: 22,
                        backgroundColor: percent_bg_color,
                        progressColor: percent_progress_color,
                        percent: percent,
                        center: Text(
                          percentage_text,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xff02ACDB),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            circle3,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 10,
                                color: Color(0xff02ACDB)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      bottom: 0,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xff4DAF15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            circle2,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 10,
                                color: Color(0xff4DAF15)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 60,
                      bottom: 0,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xffE04318),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            circle1,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 10,
                                color: Color(0xffE04318)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        )
      ],
    );
  }
}