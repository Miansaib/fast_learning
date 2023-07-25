import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/music.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'date.dart';
import 'controllers/theme_controller.dart';

class HistoryCardReviewComplete extends StatefulWidget {
  final int cardId;
  HistoryCardReviewComplete({Key? key, required this.cardId}) : super(key: key);

  @override
  _HistoryCardReviewCompleteState createState() =>
      _HistoryCardReviewCompleteState();
}

class _HistoryCardReviewCompleteState extends State<HistoryCardReviewComplete> {
  int? selectedindex = 0;
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: selectedindex!);
    controller!.addListener(() {
      setState(() {
        selectedindex = controller!.page!.toInt();
        print(selectedindex);
      });
    });
  }

  PageController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeContoller.themeData.value.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            themeContoller.themeData.value.primaryColorDark,
            themeContoller.themeData.value.primaryColor,
          ],
        )),
        child: SafeArea(
            child: FutureBuilder(
                future: Tablehistory()
                    .select()
                    .tblCardId
                    .equals(widget.cardId)
                    .toList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Tablehistory>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      // builder: (BuildContext context,
                      //       AsyncSnapshot<List<Tablehistory>> snapshot) {
                      //     if (!snapshot.hasData) {
                      //       return Container();
                      //     }
                      // FutureBuilder(
                      //   future: Tablehistory().select().tblCardId.equals(widget.cardId).toList(),

                      Container(
                        margin: EdgeInsets.only(top: 45),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 100,
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            controller: controller,
                            children: snapshot.data!.map((e) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Text(
                                      'box_number'.tr,
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                    title: Text(
                                      e.nextBoxNumber.toString(),
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Text(
                                      'time_question'.tr,
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                    title: Text(
                                      miladiToShamsiDateTimeFormat(
                                          e.dateQuestion.toString()),
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Text(
                                      'reply'.tr,
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                    title: Text(
                                      e.reply!,
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Text(
                                      'your_time'.tr,
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                    title: Text(
                                      e.replyTimeInSecond.toString() +
                                          ' ' +
                                          'second'.tr,
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Text(
                                      'ex_time'.tr,
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                    title: Text(
                                      e.goodTimeInSecond.toString() +
                                          ' ' +
                                          'second'.tr,
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Text(
                                      'result'.tr,
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                    title: Text(
                                      getReplyStatus(e.resultQuestion ?? 0),
                                      style: themeContoller
                                          .themeData.value.textTheme.headline1!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  e.replyVoicePath!.isNotEmpty
                                      ? ControlButtonsOld(
                                          path: e.replyVoicePath,
                                        )
                                      : Container(),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        child: Container(
                          padding: EdgeInsetsDirectional.only(
                              start: 10, end: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          // color: Colors.red,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    // selectedindex = selectedindex!+1;
                                    controller!.previousPage(
                                        duration: Duration(seconds: 1),
                                        curve: Curves.bounceIn);
                                  },
                                  child: Visibility(
                                    visible: selectedindex! > 0,
                                    child: Container(
                                        width: 100,
                                        padding: EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            right: 15,
                                            left: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Center(child: Text('previous'))),
                                  )),
                              InkWell(
                                  onTap: () {
                                    controller!.nextPage(
                                        duration: Duration(seconds: 1),
                                        curve: Curves.bounceIn);
                                  },
                                  child: Visibility(
                                    visible: selectedindex! <
                                        snapshot.data!.length - 1,
                                    child: Container(
                                        width: 100,
                                        padding: EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            right: 15,
                                            left: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Center(child: Text('Next'))),
                                  )),
                            ],
                          ),
                        ),
                      ),

                      // Align(
                      //   //bottom: 5,
                      //   alignment: AlignmentDirectional.bottomCenter,
                      //   //right: MediaQuery.of(context).size.width / 2 - 40,
                      //   child: SizedBox(
                      //     width: MediaQuery.of(context).size.width,
                      //  // width: 40,
                      //     height: 100,
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Expanded(
                      //           child: SingleChildScrollView(
                      //             scrollDirection: Axis.horizontal,
                      //             child: Row( mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,children: _buildPageIndicator(snapshot.data!),),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.cancel_outlined,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })),
      ),
    );
  }

  String getReplyStatus(int replyIndex) {
    String result = '';
    switch (replyIndex) {
      case 1:
        result = 'dont_ask'.tr;
        break;
      case 2:
        result = 'very_easy'.tr;
        break;
      case 3:
        result = 'easy'.tr;
        break;
      case 4:
        result = 'medium'.tr;
        break;
      case 5:
        result = 'hard'.tr;
        break;
      case 6:
        result = 'dont_know'.tr;
        break;
    }
    return result;
  }

  List<Widget> _buildPageIndicator(List<Tablehistory> histories) {
    List<Widget> list = [];
    for (int i = 0; i < histories.length; i++) {
      list.add(i == selectedindex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 5),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Color(0XFF2FB7B2).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? Color(0XFF6BC4C9) : Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}
