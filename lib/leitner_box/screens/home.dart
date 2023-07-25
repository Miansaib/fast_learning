import 'dart:io';

import 'package:Fast_learning/history_card_review_complete.dart';
import 'package:Fast_learning/password_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/screens/makeNewFlashcard.dart';
import 'package:get/get.dart';
import '../audio_player.dart';
import '../customWidgets/_appBar.dart';
import '../customWidgets/headerButtons.dart';
import '../customWidgets/percentageCircle.dart';

class LessonPage_V2 extends StatefulWidget {
  @override
  _LessonPage_V2State createState() => _LessonPage_V2State();
}

class _LessonPage_V2State extends State<LessonPage_V2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 15),
            child: Column(
              children: [
                app_Bar(title_text: "Lecon Quatre"),
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
                                child: Text('Cards',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16))),
                            Tab(
                                child: Text('Lesson 4',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16))),
                            Tab(
                                child: Text('درس 4',
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
                      cardsTab(),
                      lessonTab(
                          lesson_title: 'Demander qu’on vous indique le chemin',
                          lesson_body:
                              "Amy: Salut Michael. \nMichael: Salut Amy. Quoi de neuf? \nAmy: Je cherche l’aeroport. Peux-tu me dire \ncomment y aller? \nMichael: Desole. Je ne sais pas."),
                      lessonTab(
                          lesson_title:
                              "از کسی تقاضا کردن که مسیر را به شما نشان دهد.",
                          lesson_body:
                              "امی: سلام میکائیل.\nمیکائیل: سلام امی. چه خبر؟\nامی: در جستجوی فرودگاه هستم. میدانی چه جوری می توانم به آنجا بروم؟\nمیکائیل: متاسفم. نمی دانم. ",
                          txtdir: TextDirection.rtl)
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

class cardsTab extends StatefulWidget {
  const cardsTab({Key? key}) : super(key: key);

  @override
  State<cardsTab> createState() => _cardsTabState();
}

class _cardsTabState extends State<cardsTab> {
  @override
  Widget build(BuildContext context) {
    bool changecolor = false;
    bool changecolor2 = false;
    bool changecolor3 = false;
    bool changecolor4 = false;
    bool changecolor5 = false;

    return Scaffold(
      floatingActionButton: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: [10, 4],
        strokeWidth: 2,
        padding: EdgeInsets.all(0),
        radius: Radius.circular(10),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // border: Border.all(color: Color(0xff27187E), width: 1.5, style: BorderStyle.)
            ),
            width: MediaQuery.of(context).size.width - 100,
            height: 50,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => makeNewFlashcard(),
                  ),
                );
              },
              backgroundColor: Color(0xffF1F2F6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Color(0xff8A8A8A), size: 24),
                  SizedBox(width: 5),
                  Text(
                    "Make New Flashcard",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff8A8A8A)),
                  ),
                ],
              ),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
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
                      containerbgcolor:
                          changecolor3 ? Color(0xffAEB8FE) : Colors.transparent,
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
                      containerbgcolor:
                          changecolor4 ? Color(0xffAEB8FE) : Colors.transparent,
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
                      containerbgcolor:
                          changecolor5 ? Color(0xffAEB8FE) : Colors.transparent,
                      clr: Color(0xffE04318),
                      img_path: 'assets/images/trash.png',
                      txt1: 'Delete',
                      txt2: 'Card'),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                percetageCircle(
                  percentage_text: '%20',
                  percent_progress_color: Color(0xffE04318),
                  percent_bg_color: Color(0x20E04318),
                  image_widget: Image.asset('assets/images/pink-box.png'),
                  txt1: 'Demander',
                  percent: 0.2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class lessonTab extends StatefulWidget {
  lessonTab(
      {Key? key,
      required this.lesson_title,
      required this.lesson_body,
      this.txtdir})
      : super(key: key);
  String lesson_title;
  String lesson_body;
  TextDirection? txtdir;

  @override
  State<lessonTab> createState() => _lessonTabState();
}

class _lessonTabState extends State<lessonTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 256,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 100, spreadRadius: 0.5)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.lesson_title,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Color(0xff353535)),
                      textDirection: widget.txtdir),
                  SizedBox(height: 10),
                  Text(widget.lesson_body,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: Color(0xff353535)),
                      textDirection: widget.txtdir),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Image.asset("assets/images/airport.png"),
          SizedBox(height: 20),
          Align(
              alignment: Alignment.centerLeft,
              child: Text("First Voice",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: Color(0xff353535)))),
          SizedBox(height: 10),
          CustomAudioPlayerV2(
              audio_url:
                  'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3'),
          SizedBox(height: 20),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Second Voice",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    color: Color(0xff353535)),
              )),
          SizedBox(height: 10),
          CustomAudioPlayerV2(
              audio_url:
                  'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3'),
          SizedBox(height: 30)
        ],
      ),
    );
  }
}
