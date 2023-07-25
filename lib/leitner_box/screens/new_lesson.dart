import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';

import 'newLessonDialog.dart';

class newLesson extends StatefulWidget {
  const newLesson({Key? key}) : super(key: key);

  @override
  State<newLesson> createState() => _newLessonState();
}

class _newLessonState extends State<newLesson> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                app_Bar(title_text: "French in 90 days"),
                SizedBox(height: 40),
                DottedBorder(
                  color: Color(0xff8A8A8A),
                  padding: EdgeInsets.all(0),
                  borderType: BorderType.RRect,
                  dashPattern: [10, 4],
                  radius: Radius.circular(10),
                  strokeWidth: 2,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return newLessonDialog();
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffF1F2F6),
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,
                                  size: 24, color: Color(0xff8A8A8A)),
                              SizedBox(width: 10),
                              Text(
                                "Make New Lessson",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff8A8A8A)),
                              )
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
                          Container(
                            width: 212,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("lesson.",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w300,
                                        fontSize: 9,
                                        color: Color(0xff8A8A8A))),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 24,
                                  color: Color(0xff8A8A8A),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: bottomBar(),
      ),
    );
  }
}

class bottomBar extends StatefulWidget {
  const bottomBar({Key? key}) : super(key: key);

  @override
  State<bottomBar> createState() => _bottomBarState();
}

class _bottomBarState extends State<bottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xff27187E),
      selectedLabelStyle: TextStyle(fontSize: 10, fontFamily: "Poppins"),
      unselectedLabelStyle: TextStyle(fontSize: 10, fontFamily: "Poppins"),
      unselectedItemColor: Color(0xff8a8a8a),
      // currentIndex: _currentIndex,
      // onTap: (value) {
      //   setState(() => _currentIndex = value);
      // },
      items: [
        BottomNavigationBarItem(
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Image.asset("assets/images/home-icon-active.png",
                width: 24, height: 24),
          ),
          label: "Home",
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Image.asset("assets/images/home-icon.png",
                width: 24, height: 24),
          ),
        ),
        BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset(
                "assets/images/courses-active-icon.png",
                width: 24,
                height: 24,
              ),
            ),
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
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/images/settings-icon-active.png",
                width: 24,
                height: 24,
              ),
            ),
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
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Image.asset(
                "assets/images/profile-icon-active.png",
                width: 24,
                height: 24,
              ),
            ),
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
