import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class languagebook extends StatelessWidget {
  const languagebook({Key? key}) : super(key: key);

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
                    "Language books",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  )
                ],
              ),
              SizedBox(height: 27),
              Row(
                children: [
                  Custom_Container(
                    ImgPath: "assets/images/arrow-3.png",
                    clr: Color(0xff27187E),
                  ),
                  Spacer(),
                  Custom_Container(
                    ImgPath: "assets/images/edit-icon.png",
                    clr: Color(0xff27187E),
                  ),
                  Spacer(),
                  Custom_Container(
                    ImgPath: "assets/images/note.png",
                    clr: Color(0xff27187E),
                  ),
                  Spacer(),
                  Custom_Container(
                    ImgPath: "assets/images/repeat.png",
                    clr: Color(0xff27187E),
                  ),
                  Spacer(),
                  Custom_Container(
                    ImgPath: "assets/images/lock.png",
                    clr: Color(0xff27187E),
                  ),
                  Spacer(),
                  Custom_Container(
                    ImgPath: "assets/images/trash.png",
                    clr: Color(0xffE04318),
                  ),
                ],
              ),
              SizedBox(height: 23),
              Row(
                children: [
                  Select_Box(),
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
              Books_Container(
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
              Books_Container(
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
              Books_Container(
                  image_path: "assets/images/img-3.png",
                  book_name: "German phrase book",
                  lessons_text: "36 Lessons",
                  notes_text: "3 Notes",
                  flashcard_text: "227 Flashcards",
                  percentage_text: "%55",
                  circle1: "1",
                  circle2: "106",
                  circle3: "20",
                  percent: 0.55,
                  percent_bg_color: Color(0x20FF8600),
                  percent_progress_color: Color(0xffFF8600)),
              SizedBox(height: 20),
              Books_Container(
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
              Books_Container(
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
      floatingActionButton: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xff27187E), width: 1.5)),
          width: 200,
          height: 50,
          child: FloatingActionButton(
            backgroundColor: Color(0xffAEB8FE),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {},
            child: Text(
              "Send To Training",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff353535)),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }
}

class Custom_Container extends StatelessWidget {
  Custom_Container({Key? key, required this.ImgPath, required this.clr})
      : super(key: key);
  String ImgPath;
  Color clr;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: clr),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 7, bottom: 7, left: 11, right: 11),
          child: Image.asset(
            ImgPath,
            width: 24,
            height: 24,
          ),
        ));
  }
}

class Select_Box extends StatelessWidget {
  const Select_Box({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff353535), width: 2),
            borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 3, right: 3),
          child: Icon(Icons.check, color: Color(0xff353535), size: 13),
        ));
  }
}

class Books_Container extends StatelessWidget {
  Books_Container(
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
        Select_Box(),
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

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({Key? key}) : super(key: key);

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
            child:
                Image.asset("assets/images/home-2.png", width: 24, height: 24),
          ),
        ),
        BottomNavigationBarItem(
            label: "Courses",
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset(
                "assets/images/book-icon.png",
                width: 24,
                height: 24,
              ),
            )),
        BottomNavigationBarItem(
            label: "Settings",
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/images/setting-2.png",
                width: 24,
                height: 24,
              ),
            )),
        BottomNavigationBarItem(
            label: "Profile",
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/images/user-icon.png",
                width: 24,
                height: 24,
              ),
            )),
      ],
    );
  }
}
