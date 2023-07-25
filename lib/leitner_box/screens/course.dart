import 'package:flutter/material.dart';

import '../customWidgets/_appBar.dart';
import '../customWidgets/courseContainer.dart';

class course extends StatefulWidget {
  @override
  _courseState createState() => _courseState();
}

class _courseState extends State<course> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 15),
            child: Column(
              children: [
                app_Bar(title_text: "Courses"),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Stack(
                    children: [
                      Container(
                        height: 48,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Color(0xff27187E),
                          unselectedLabelColor: Color(0xff8A8A8A),
                          indicator: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xff27187E), width: 5))),
                          tabs: [
                            Tab(
                                child: Text('Trainings',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16))),
                            Tab(
                                child: Text('Reviews',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16))),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 0.8,
                          child: Container(
                            height: 2.5,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black26,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      trainingsTab(),
                      reviewsTab(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class trainingsTab extends StatefulWidget {
  const trainingsTab({Key? key}) : super(key: key);

  @override
  State<trainingsTab> createState() => _trainingsTabState();
}

class _trainingsTabState extends State<trainingsTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        courseContainer(
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
        courseContainer(
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
      ],
    );
  }
}

class reviewsTab extends StatefulWidget {
  const reviewsTab({Key? key}) : super(key: key);

  @override
  State<reviewsTab> createState() => _reviewsTabState();
}

class _reviewsTabState extends State<reviewsTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          width: 230,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Color(0xff27187E))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/undo-icon.png", width: 24, height: 24),
              SizedBox(width: 10),
              Text(
                "Reset Selected Books",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Color(0xff27187E),
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              )
            ],
          ),
        ),
        SizedBox(height: 25),
        courseContainer(
          percent: 0.87,
          circle2: '96',
          percent_bg_color: Color(0x204DAF15),
          image_path: 'assets/images/img-2.png',
          flashcard_text: '1026 Flashcards',
          percent_progress_color: Color(0xff4DAF15),
          lessons_text: '176 Lessons',
          notes_text: '100 Notes',
          circle3: '800',
          circle1: '120',
          percentage_text: '%87',
          book_name: 'French in 90 days',
        )
      ],
    );
  }
}
