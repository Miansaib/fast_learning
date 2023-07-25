import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_checkBox.dart';

import 'addNewLesson.dart';

class bookLesson extends StatefulWidget {
  const bookLesson({Key? key}) : super(key: key);

  @override
  State<bookLesson> createState() => _bookLessonState();
}

class _bookLessonState extends State<bookLesson> {
  bool changecolor = false;
  bool changecolor2 = false;
  bool changecolor3 = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 13, right: 13),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_back_ios_new_sharp,
                      size: 24, color: Color(0xff353535)),
                  SizedBox(width: 16),
                  Text(
                    "French in 90 days",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  )
                ],
              ),
              SizedBox(height: 27),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        changecolor = !changecolor;
                      });
                    },
                    child: headerButtons(
                      containerbgcolor:
                          changecolor ? Color(0xffAEB8FE) : Colors.transparent,
                      ImgPath: "assets/images/arrow-3.png",
                      clr: Color(0xff27187E),
                      txt1: 'Edit',
                      txt2: 'Position',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        changecolor2 = !changecolor2;
                      });
                    },
                    child: headerButtons(
                      containerbgcolor:
                          changecolor2 ? Color(0xffAEB8FE) : Colors.transparent,
                      ImgPath: "assets/images/edit-icon.png",
                      clr: Color(0xff27187E),
                      txt1: 'Edit',
                      txt2: 'Lesson',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        changecolor3 = !changecolor3;
                      });
                    },
                    child: headerButtons(
                      containerbgcolor:
                          changecolor3 ? Color(0xffAEB8FE) : Colors.transparent,
                      ImgPath: "assets/images/trash.png",
                      clr: Color(0xffE04318),
                      txt1: 'Delete',
                      txt2: 'Lesson',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 23),
              Row(
                children: [
                  checkBox(),
                  SizedBox(width: 12),
                  Text(
                    "Select All",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: "Poppins",
                        fontSize: 15,
                        color: Color(0xff353535)),
                  )
                ],
              ),
              SizedBox(height: 25),
              lessonContainer(
                image_path: "assets/images/img-1.png",
                lesson_name: "Lecon Un",
                story_text: "1 Story",
                flashcard_text: "27 Flashcards",
                circle1: "22",
                circle2: "10",
                circle3: "0",
                circle_tick_color: Color(0xffE04318),
                check_Box: checkBox(),
              ),
              SizedBox(height: 20),
              lessonContainer(
                  check_Box: checkBox(),
                  image_path: "assets/images/img-2.png",
                  lesson_name: "Lecon Deux",
                  story_text: "1 Story",
                  flashcard_text: "19 Flashcards",
                  circle1: "22",
                  circle2: "10",
                  circle3: "0",
                  circle_tick_color: Color(0xff4DAF15)),
              SizedBox(height: 20),
              lessonContainer(
                  check_Box: checkBox(),
                  image_path: "assets/images/img-3.png",
                  lesson_name: "Lecon Trois",
                  story_text: "1 Story",
                  flashcard_text: "11 Flashcards",
                  circle1: "22",
                  circle2: "10",
                  circle3: "0",
                  circle_tick_color: Color(0xffFF8600)),
              SizedBox(height: 20),
              lessonContainer(
                  check_Box: checkBox(),
                  image_path: "assets/images/img-1.png",
                  lesson_name: "Lecon Quatre",
                  story_text: "1 Story",
                  flashcard_text: "40 Flashcards",
                  circle1: "22",
                  circle2: "10",
                  circle3: "0",
                  circle_tick_color: Color(0xffE04318)),
              SizedBox(height: 20),
              lessonContainer(
                  check_Box: checkBox(),
                  image_path: "assets/images/img-2.png",
                  lesson_name: "French in 90 days",
                  story_text: "176 Lessons",
                  flashcard_text: "1026 Flashcards",
                  circle1: "22",
                  circle2: "10",
                  circle3: "0",
                  circle_tick_color: Color(0xff4DAF15)),
              SizedBox(height: 140),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(),
      floatingActionButton: floatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }
}

class headerButtons extends StatelessWidget {
  headerButtons(
      {Key? key,
      required this.ImgPath,
      required this.clr,
      required this.txt1,
      required this.txt2,
      required this.containerbgcolor})
      : super(key: key);
  String ImgPath;
  Color clr;
  String txt1;
  String txt2;
  Color containerbgcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: containerbgcolor,
            border: Border.all(color: clr),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 7, bottom: 7, left: 15, right: 15),
          child: Row(
            children: [
              Image.asset(
                ImgPath,
                width: 24,
                height: 24,
              ),
              SizedBox(width: 5),
              Text("$txt1\n$txt2",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: clr)),
            ],
          ),
        ));
  }
}

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xff27187E),
      selectedLabelStyle: TextStyle(fontSize: 10, fontFamily: "Poppins"),
      unselectedLabelStyle: TextStyle(fontSize: 10, fontFamily: "Poppins"),
      unselectedItemColor: Color(0xff8a8a8a),
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Image.asset("assets/images/home-icon-active.png",
                width: 24, height: 24),
          ),
        ),
        BottomNavigationBarItem(
            label: "Courses",
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset(
                "assets/images/courses-icon.png",
                width: 24,
                height: 24,
              ),
            )),
        BottomNavigationBarItem(
            label: "Settings",
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/images/setting-icon.png",
                width: 24,
                height: 24,
              ),
            )),
        BottomNavigationBarItem(
            label: "Profile",
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/images/profile-icon.png",
                width: 24,
                height: 24,
              ),
            )),
      ],
    );
  }
}

class lessonContainer extends StatelessWidget {
  lessonContainer(
      {Key? key,
      required this.image_path,
      required this.lesson_name,
      required this.story_text,
      required this.flashcard_text,
      required this.circle1,
      required this.circle2,
      required this.circle3,
      required this.circle_tick_color,
      required this.check_Box})
      : super(key: key);
  Widget check_Box;
  String image_path;
  String lesson_name;
  String story_text;
  String flashcard_text;
  String circle1;
  String circle2;
  String circle3;
  Color circle_tick_color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        check_Box,
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
                      child: Text(lesson_name,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ),
                    Positioned(
                      left: 0,
                      top: 40,
                      child: Text(story_text,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
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
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: circle_tick_color),
                            borderRadius: BorderRadius.circular(60)),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.check,
                            color: circle_tick_color,
                          ),
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

class floatingButton extends StatelessWidget {
  const floatingButton({Key? key}) : super(key: key);

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
                MaterialPageRoute(builder: (context) => newLesson()),
              );
            },
            backgroundColor: Color(0xffF1F2F6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: 270,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 24, color: Color(0xff8A8A8A)),
                      SizedBox(width: 10),
                      Text("Make New Lesson",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xff8A8A8A)))
                    ],
                  ),
                  SizedBox(height: 5),
                  Text("to make new flashcards first we need to make a",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w300,
                          fontSize: 9,
                          color: Color(0xff8A8A8A))),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("lesson.",
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
