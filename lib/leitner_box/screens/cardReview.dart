import 'dart:async';
import 'package:flutter/material.dart';
import '../audio_player.dart';
import '../customWidgets/_appBar.dart';
import 'bookLesson.dart';

class cardReview extends StatefulWidget {
  const cardReview({Key? key}) : super(key: key);

  @override
  State<cardReview> createState() => _cardReviewState();
}

class _cardReviewState extends State<cardReview> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              app_Bar(title_text: "Lecon Quatre"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  SizedBox(width: 40),
                  Image.asset(
                    "assets/images/timer.png",
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 10),
                  showTimer(),
                  Spacer(),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Color(0xffF1F2F6))),
                    child: Center(
                      child: (Image.asset(
                        "assets/images/candle.png",
                        width: 24,
                        height: 24,
                      )),
                    ),
                  )
                ],
              ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Aeroport",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff353535))),
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
              Text("Your Reply",
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
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 12, bottom: 12),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(width: 1, color: Color(0xff353535)),
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
                                TextButton(
                                  onPressed: () {},
                                  child: Text("recorded my voice",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff27187E))),
                                )
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
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffF1F2F6),
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          cursorColor: Color(0xff8A8A8A),
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xff8A8A8A)),
                          decoration: InputDecoration(
                              hintText: "Enter Your Reply",
                              contentPadding: const EdgeInsets.only(left: 10),
                              hintStyle: TextStyle(
                                  fontFamily: "poppins",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xff8A8A8A)),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 1, color: Color(0xff27187E))),
                              child: Center(
                                  child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Check",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Poppins",
                                      color: Color(0xff27187E)),
                                ),
                              ))),
                          Spacer(),
                          Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 1, color: Color(0xff27187E))),
                              child: Center(
                                  child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Help",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Poppins",
                                      color: Color(0xff27187E)),
                                ),
                              ))),
                          Spacer(),
                          Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 1, color: Color(0xff27187E))),
                              child: Center(
                                  child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Hold to Show",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Poppins",
                                      color: Color(0xff27187E)),
                                ),
                              ))),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(width: 1, color: Color(0xff27187E))),
                      child: Center(
                          child: InkWell(
                        onTap: () {},
                        child: Text(
                          "Don't Ask Again",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Poppins",
                              color: Color(0xff27187E)),
                        ),
                      ))),
                  Spacer(),
                  Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(width: 1, color: Color(0xff27187E))),
                      child: Center(
                          child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Very Easy",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Poppins",
                              color: Color(0xff27187E)),
                        ),
                      ))),
                  Spacer(),
                  Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(width: 1, color: Color(0xff27187E))),
                      child: Center(
                          child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Easy",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Poppins",
                              color: Color(0xff27187E)),
                        ),
                      ))),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(width: 1, color: Color(0xff27187E))),
                      child: Center(
                          child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Medium",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Poppins",
                              color: Color(0xff27187E)),
                        ),
                      ))),
                  Spacer(),
                  Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(width: 1, color: Color(0xff27187E))),
                      child: Center(
                          child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Hard",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Poppins",
                              color: Color(0xff27187E)),
                        ),
                      ))),
                  Spacer(),
                  Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(width: 1, color: Color(0xff27187E))),
                      child: Center(
                          child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "I Don't Know",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Poppins",
                              color: Color(0xff27187E)),
                        ),
                      ))),
                ],
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0xffAEB8FE),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1, color: Color(0xff27187E))),
                    child: Center(
                        child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Next Card",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                            color: Color(0xff353535)),
                      ),
                    ))),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 250,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 2, color: Color(0xffF1F2F6))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {},
                          child: Image.asset("assets/images/Card-Count.png",
                              width: 28, height: 28)),
                      Container(
                        width: 2,
                        height: 25,
                        color: Color(0xffF1F2F6),
                      ),
                      InkWell(
                          onTap: () {},
                          child: Image.asset("assets/images/rotate-left.png",
                              width: 50, height: 50)),
                      Container(
                        width: 2,
                        height: 25,
                        color: Color(0xffF1F2F6),
                      ),
                      InkWell(
                          onTap: () {},
                          child: Image.asset("assets/images/refresh.png",
                              width: 30, height: 31)),
                    ],
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

class showTimer extends StatefulWidget {
  @override
  _showTimerState createState() => _showTimerState();
}

class _showTimerState extends State<showTimer> {
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int hours = _secondsElapsed ~/ 3600;
    int minutes = (_secondsElapsed % 3600) ~/ 60;
    int seconds = _secondsElapsed % 60;
    String timeString =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Text('$timeString',
        style: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xff353535),
            fontWeight: FontWeight.w300,
            fontSize: 13));
  }
}
