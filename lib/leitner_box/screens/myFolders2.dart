import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/screens/addFolder.dart';
import '../customWidgets/_appBar.dart';

class myFolders2 extends StatefulWidget {
  const myFolders2({Key? key}) : super(key: key);

  @override
  State<myFolders2> createState() => _myFolders2State();
}

class _myFolders2State extends State<myFolders2> {
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
              app_Bar(
                title_text: 'My Folders',
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
              SizedBox(height: 25),
              lessonContainer(
                image_path: "assets/images/img-1.png",
                subject: "Language",
                books: "3 Books",
                lesson: "262 Lessons",
                circle1: "0",
                circle2: "0",
                circle3: "100",
              ),
              SizedBox(height: 20),
              lessonContainer(
                image_path: "assets/images/img-2.png",
                subject: "Chemistry",
                books: "4 Books",
                lesson: "170 Lessons",
                circle1: "20",
                circle2: "36",
                circle3: "57",
              ),
              SizedBox(height: 20),
              lessonContainer(
                image_path: "assets/images/img-3.png",
                subject: "Physics",
                books: "2 Books",
                lesson: "68 Lessons",
                circle1: "0",
                circle2: "200",
                circle3: "0",
              ),
              SizedBox(height: 20),
              lessonContainer(
                image_path: "assets/images/img-1.png",
                subject: "Language",
                books: "3 Books",
                lesson: "68 Lessons",
                circle1: "36",
                circle2: "14",
                circle3: "93",
              ),
              SizedBox(height: 20),
              lessonContainer(
                image_path: "assets/images/img-2.png",
                subject: "Chemistry",
                books: "4 Books",
                lesson: "170 Lessons",
                circle1: "20",
                circle2: "10",
                circle3: "0",
              ),
              SizedBox(height: 100),
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
  lessonContainer({
    Key? key,
    required this.image_path,
    required this.subject,
    required this.books,
    required this.lesson,
    required this.circle1,
    required this.circle2,
    required this.circle3,
  }) : super(key: key);
  String image_path;
  String subject;
  String books;
  String lesson;
  String circle1;
  String circle2;
  String circle3;

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
                      child: Text(subject,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ),
                    Positioned(
                      left: 0,
                      top: 40,
                      child: Text(books,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Text(lesson,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
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
        height: 60,
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => addFolder()),
              );
            },
            backgroundColor: Color(0xffF1F2F6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 24, color: Color(0xff8A8A8A)),
                    SizedBox(width: 10),
                    Text("Add Folder",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xff8A8A8A)))
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
