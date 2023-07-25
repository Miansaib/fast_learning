import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../PlayerWithoutActions.dart';
import '../audio_player.dart';
import '../customWidgets/_appBar.dart';
import 'bookLesson.dart';

class leitner84 extends StatefulWidget {
  const leitner84({Key? key}) : super(key: key);

  @override
  State<leitner84> createState() => _leitner84State();
}

class _leitner84State extends State<leitner84> {
  bool changecolor = false;
  bool changecolor2 = false;
  bool changecolor3 = false;
  bool changecolor4 = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              app_Bar(title_text: "Lecon Quatre"),
              SizedBox(height: 20),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          changecolor = !changecolor;
                        });
                      },
                      child: headerButtons(
                          containerbgcolor: changecolor
                              ? Color(0xffAEB8FE)
                              : Colors.transparent,
                          clr: Color(0xff27187E),
                          img_path: "assets/images/auto-next-icon.png",
                          txt1: "Auto next",
                          txt2: "flashcard")),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        setState(() {
                          changecolor2 = !changecolor2;
                        });
                      },
                      child: headerButtons(
                          containerbgcolor: changecolor2
                              ? Color(0xffAEB8FE)
                              : Colors.transparent,
                          clr: Color(0xff27187E),
                          img_path: "assets/images/musicnote-icon.png",
                          txt1: "Auto play",
                          txt2: "")),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        setState(() {
                          changecolor3 = !changecolor3;
                        });
                      },
                      child: headerButtons(
                          containerbgcolor: changecolor3
                              ? Color(0xffAEB8FE)
                              : Colors.transparent,
                          clr: Color(0xff27187E),
                          img_path: "assets/images/note-2.png",
                          txt1: "Show",
                          txt2: "Decription")),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        setState(() {
                          changecolor4 = !changecolor4;
                        });
                      },
                      child: headerButtons(
                          containerbgcolor: changecolor4
                              ? Color(0xffAEB8FE)
                              : Colors.transparent,
                          clr: Color(0xff27187E),
                          img_path: "assets/images/auto-next-icon.png",
                          txt1: "Auto next",
                          txt2: "flashcard")),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        showDialog(
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (context) => Dialog_Box(),
                        );
                      },
                      child: headerButtons(
                          containerbgcolor: Color(0xffF1F2F6),
                          clr: Color(0xff27187E),
                          img_path: "assets/images/menu.png",
                          txt1: "Others",
                          txt2: "")),
                ],
              ),
              SizedBox(height: 15),
              Text("Question",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff353535))),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 100,
                          spreadRadius: 1)
                    ]),
                height: 102,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Aeroport",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff353535))),
                          Spacer(),
                          Image.asset("assets/images/volume-high.png",
                              width: 24, height: 24)
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                textAlign: TextAlign.start,
                                "1.0X",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: Color(0xff353535)),
                              )),
                          Expanded(
                            child: CustomAudioPlayerV2(
                                audio_url:
                                    'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text("Answer",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff353535))),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 100,
                          spreadRadius: 1)
                    ]),
                height: 102,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/volume-slash.png",
                              width: 24, height: 24),
                          Spacer(),
                          Text("فرودگاه",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff353535))),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                textAlign: TextAlign.start,
                                "1.0X",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: Color(0xff353535)),
                              )),
                          Expanded(
                            child: CustomAudioPlayerV2(
                                audio_url:
                                    'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text("Description",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff353535))),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 100,
                          spreadRadius: 1)
                    ]),
                height: 102,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/volume-slash.png",
                              width: 24, height: 24),
                          Spacer(),
                          Text("محل عبور و مرور هواپیماها",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff353535))),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                textAlign: TextAlign.start,
                                "1.0X",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: Color(0xff353535)),
                              )),
                          Expanded(
                            child: CustomAudioPlayerV2(
                                audio_url:
                                    'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text("Image",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff353535))),
              SizedBox(height: 15),
              Center(child: Image.asset("assets/images/airport.png")),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: Color(0xff353535)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/microphone-2.png",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 10),
                        Text("recorded my voice",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff27187E)))
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                        "that is useful to listen and compare with the answer\nespecially while you are learning a new language",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 9,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffAEB8FE))),
                    SizedBox(height: 10)
                  ],
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xff27187E),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        "I know the answer and sure never forget.",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  "Or",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 14),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xffF1F2F6),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        "Transfer this flash cart to review and\nstart memorizing and never forget.",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: Color(0xff353535),
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(),
    ));
  }
}

class headerButtons extends StatelessWidget {
  headerButtons(
      {Key? key,
      required this.containerbgcolor,
      required this.img_path,
      required this.clr,
      required this.txt1,
      required this.txt2})
      : super(key: key);
  String img_path;
  String txt1;
  String txt2;
  Color clr;
  Color containerbgcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width * 0.17,
      decoration: BoxDecoration(
          color: containerbgcolor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: clr)),
      child: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              img_path,
              width: 23,
              height: 23,
            ),
            SizedBox(height: 7),
            Text(txt1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 11,
                    color: clr,
                    fontWeight: FontWeight.w300)),
            // Text(txt2,
            //     style: TextStyle(
            //         fontFamily: "Poppins",
            //         fontSize: 11,
            //         color: clr,
            //         fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}

class Dialog_Box extends StatefulWidget {
  Dialog_Box({Key? key}) : super(key: key);

  @override
  State<Dialog_Box> createState() => _Dialog_BoxState();
}

class _Dialog_BoxState extends State<Dialog_Box> {
  bool isSpellCheck = false;
  bool isAutoNext = false;
  bool isAutoLeitner = false;
  bool isScreenAwake = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            side: BorderSide(color: Color(0xff353535), width: 1)),
        insetPadding: EdgeInsets.all(16),
        backgroundColor: Color(0xffF1F2F6),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: 325,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isSpellCheck = !isSpellCheck;
                      });
                    },
                    child: Others_Dialog_Button(
                        img_path: "assets/images/smallcaps.png",
                        clr: Color(0xff27187E),
                        txt1: "Show Spell",
                        txt2: "Check",
                        containerbgcolor: isSpellCheck
                            ? Color(0xffAEB8FE)
                            : Colors.transparent),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isAutoNext = !isAutoNext;
                      });
                    },
                    child: Others_Dialog_Button(
                        img_path: "assets/images/format-circle.png",
                        clr: Color(0xff27187E),
                        txt1: "Auto Next",
                        txt2: "Lesson",
                        containerbgcolor: isAutoNext
                            ? Color(0xffAEB8FE)
                            : Colors.transparent),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isAutoLeitner = !isAutoLeitner;
                      });
                    },
                    child: Others_Dialog_Button(
                        img_path: "assets/images/task.png",
                        clr: Color(0xff27187E),
                        txt1: "Auto",
                        txt2: "Leitner",
                        containerbgcolor: isAutoLeitner
                            ? Color(0xffAEB8FE)
                            : Colors.transparent),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isScreenAwake = !isScreenAwake;
                      });
                    },
                    child: Others_Dialog_Button(
                        img_path: "assets/images/devices.png",
                        clr: Color(0xff27187E),
                        txt1: "Screen",
                        txt2: "Awake",
                        containerbgcolor: isScreenAwake
                            ? Color(0xffAEB8FE)
                            : Colors.transparent),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/timer-icon.png",
                      width: 24, height: 24),
                  SizedBox(width: 10),
                  Text(
                    "Set delay to",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff353535),
                        fontFamily: "Poppins"),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("Play Answer     ",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff8A8A8A))),
                  SizedBox(width: 10),
                  Expanded(child: Player(audio_url: '')),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Repeat Answer",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff8A8A8A))),
                  SizedBox(width: 10),
                  Expanded(child: Player(audio_url: '')),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Go Next Lesson",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff8A8A8A))),
                  SizedBox(width: 10),
                  Expanded(child: Player(audio_url: '')),
                ],
              ),
            ],
          ),
        ),
        alignment: Alignment.topCenter,
      ),
    );
  }
}

class Others_Dialog_Button extends StatelessWidget {
  Others_Dialog_Button(
      {Key? key,
      required this.containerbgcolor,
      required this.img_path,
      required this.clr,
      required this.txt1,
      required this.txt2})
      : super(key: key);
  String img_path;
  String txt1;
  String txt2;
  Color clr;
  Color containerbgcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: containerbgcolor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: clr)),
      child: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
        child: Column(
          children: [
            Image.asset(
              img_path,
              width: 23,
              height: 23,
            ),
            SizedBox(height: 7),
            Text(txt1,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 11,
                    color: clr,
                    fontWeight: FontWeight.w300)),
            Text(txt2,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 11,
                    color: clr,
                    fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}
