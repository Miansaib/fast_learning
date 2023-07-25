import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:Fast_learning/leitner_box/screens/addBook.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../customWidgets/headerButtons.dart';
import 'bookLesson.dart';

class Books extends StatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  bool changecolor = false;
  bool changecolor2 = false;
  bool changecolor3 = false;
  bool changecolor4 = false;
  bool changecolor5 = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Column(
            children: [
              app_Bar(title_text: "Language books"),
              SizedBox(height: 20),
              Row(children: [
                DottedBorder(
                  color: Color(0xff8A8A8A),
                  borderType: BorderType.RRect,
                  dashPattern: [10, 4],
                  strokeWidth: 1,
                  padding: EdgeInsets.all(0),
                  radius: Radius.circular(15),
                  child: Container(
                    height: 107,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xffF1F2F6)),
                    width: MediaQuery.of(context).size.width * 0.5 - 24,
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/import-icon.png",
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Text("Import",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                    color: Color(0xff27187E))),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                            textAlign: TextAlign.justify,
                            "You can import books that your",
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Poppins",
                                color: Color(0xff27187E))),
                        SizedBox(height: 5),
                        Text(
                            textAlign: TextAlign.justify,
                            "friends or other users send to you,",
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Poppins",
                                color: Color(0xff27187E))),
                        SizedBox(height: 2),
                        Container(
                          width: 148,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  textAlign: TextAlign.justify,
                                  "and use them.",
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Poppins",
                                      color: Color(0xff27187E))),
                              Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xff27187E),
                                size: 20,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                DottedBorder(
                  color: Color(0xff8A8A8A),
                  borderType: BorderType.RRect,
                  dashPattern: [10, 4],
                  strokeWidth: 1,
                  padding: EdgeInsets.all(0),
                  radius: Radius.circular(15),
                  child: Container(
                    height: 107,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xffF1F2F6)),
                    width: MediaQuery.of(context).size.width * 0.5 - 24,
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/export-icon.png",
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Text("Export",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                    color: Color(0xff27187E))),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                            textAlign: TextAlign.justify,
                            "You can also Export all your books",
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Poppins",
                                color: Color(0xff27187E))),
                        SizedBox(height: 2),
                        Container(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  textAlign: TextAlign.justify,
                                  "to other users.",
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Poppins",
                                      color: Color(0xff27187E))),
                              Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xff27187E),
                                size: 20,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                )
              ]),
              SizedBox(height: 15),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          changecolor = !changecolor;
                        });
                      },
                      child: header_buttons(
                          containerbgcolor: changecolor
                              ? Color(0xffAEB8FE)
                              : Colors.transparent,
                          clr: Color(0xff27187E),
                          img_path: 'assets/images/arrow-3.png',
                          txt1: 'Edit',
                          txt2: 'Position')),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          changecolor2 = !changecolor2;
                        });
                      },
                      child: header_buttons(
                          containerbgcolor: changecolor2
                              ? Color(0xffAEB8FE)
                              : Colors.transparent,
                          clr: Color(0xff27187E),
                          img_path: 'assets/images/edit-icon.png',
                          txt1: 'Edit',
                          txt2: 'Card')),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        changecolor3 = !changecolor3;
                      });
                    },
                    child: header_buttons(
                        containerbgcolor: changecolor3
                            ? Color(0xffAEB8FE)
                            : Colors.transparent,
                        clr: Color(0xff27187E),
                        img_path: 'assets/images/note.png',
                        txt1: 'Send To',
                        txt2: 'Training'),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        changecolor4 = !changecolor4;
                      });
                    },
                    child: header_buttons(
                        containerbgcolor: changecolor4
                            ? Color(0xffAEB8FE)
                            : Colors.transparent,
                        clr: Color(0xff27187E),
                        img_path: 'assets/images/repeat.png',
                        txt1: 'Send To',
                        txt2: 'Review'),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        changecolor5 = !changecolor5;
                      });
                    },
                    child: header_buttons(
                        containerbgcolor: changecolor5
                            ? Color(0xffAEB8FE)
                            : Colors.transparent,
                        clr: Color(0xffE04318),
                        img_path: 'assets/images/trash.png',
                        txt1: 'Delete',
                        txt2: 'Card'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              booksContainer(
                  image_path: "assets/images/img-1.png",
                  book_name: "504 English words",
                  lessons_text: "50 Lessons",
                  notes_text: "20 Notes",
                  flashcard_text: "504 Flashcards",
                  percentage_text: "%23",
                  circle1: "86",
                  circle2: "14",
                  circle3: "20",
                  percent: 0.23,
                  percent_bg_color: Color(0x20E04318),
                  percent_progress_color: Color(0xffE04318)),
              SizedBox(height: 20),
              booksContainer(
                  image_path: "assets/images/img-2.png",
                  book_name: "French in 90 days",
                  lessons_text: "176 Lessons",
                  notes_text: "100 Notes",
                  flashcard_text: "1026 Flashcards",
                  percentage_text: "%87",
                  circle1: "120",
                  circle2: "96",
                  circle3: "800",
                  percent: 0.87,
                  percent_bg_color: Color(0x204DAF15),
                  percent_progress_color: Color(0xff4DAF15)),
              SizedBox(height: 20),
              booksContainer(
                  image_path: "assets/images/img-3.png",
                  book_name: "German phrase book",
                  lessons_text: "36 Lessons",
                  notes_text: "3 Notes",
                  flashcard_text: "227 Flashcards",
                  percentage_text: "%55",
                  circle1: "1",
                  circle2: "106",
                  circle3: "120",
                  percent: 0.55,
                  percent_bg_color: Color(0x20FF8600),
                  percent_progress_color: Color(0xffFF8600)),
              SizedBox(height: 140),
            ],
          ),
        ),
        bottomNavigationBar: NavBar(),
        floatingActionButton: floating_button(),
      ),
    );
  }
}

class floating_button extends StatefulWidget {
  const floating_button({Key? key}) : super(key: key);

  @override
  State<floating_button> createState() => _floating_buttonState();
}

class _floating_buttonState extends State<floating_button> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Color(0xff8A8A8A),
      borderType: BorderType.RRect,
      dashPattern: [10, 4],
      strokeWidth: 2,
      padding: EdgeInsets.all(0),
      radius: Radius.circular(10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 110,
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => addBook()),
              );
            },
            backgroundColor: Color(0xffF1F2F6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: 282,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 24, color: Color(0xff8A8A8A)),
                      SizedBox(width: 10),
                      Text("Add book",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xff8A8A8A)))
                    ],
                  ),
                  SizedBox(height: 5),
                  Text("inside the folder, you should make a book and put",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w300,
                          fontSize: 9,
                          color: Color(0xff8A8A8A))),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("your flashcards inside it.",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w300,
                              fontSize: 9,
                              color: Color(0xff8A8A8A))),
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xff8A8A8A),
                        size: 20,
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class booksContainer extends StatelessWidget {
  booksContainer(
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
