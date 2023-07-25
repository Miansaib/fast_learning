import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:Fast_learning/leitner_box/screens/addFolderDialog.dart';

import 'bookLesson.dart';

class addFolder extends StatefulWidget {
  const addFolder({Key? key}) : super(key: key);

  @override
  State<addFolder> createState() => _addFolderState();
}

class _addFolderState extends State<addFolder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show the alert dialog after the first frame is displayed
      showDialog(
        context: context,
        builder: (context) => alert_Dialog(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                app_Bar(title_text: "My Folders"),
                SizedBox(height: 30),
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
                              "You can import folders that your",
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
                              "You can export all the folders",
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Poppins",
                                  color: Color(0xff27187E))),
                          SizedBox(height: 2),
                          Container(
                            width: 130,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    textAlign: TextAlign.justify,
                                    "to other users",
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
                SizedBox(height: 20),
                DottedBorder(
                  color: Color(0xff8A8A8A),
                  borderType: BorderType.RRect,
                  dashPattern: [10, 4],
                  strokeWidth: 1,
                  padding: EdgeInsets.all(0),
                  radius: Radius.circular(15),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return addFolderDialog();
                        },
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffF1F2F6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add,
                                    size: 24, color: Color(0xff8A8A8A)),
                                SizedBox(width: 5),
                                Text("Add Folder",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xff8A8A8A)))
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                                "to make new flashcards first we need to make a",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 9,
                                    color: Color(0xff8A8A8A))),
                            SizedBox(height: 5),
                            Container(
                              width: 215,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("new folder.",
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
                              ),
                            )
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavBar(),
      ),
    );
  }
}

class alert_Dialog extends StatefulWidget {
  const alert_Dialog({Key? key}) : super(key: key);

  @override
  State<alert_Dialog> createState() => _alert_DialogState();
}

class _alert_DialogState extends State<alert_Dialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25))),
      insetPadding: EdgeInsets.all(0),
      backgroundColor: Color(0xff353535),
      title: Text(
        'Export and share all books',
        style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white),
      ),
      content: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
              'you can also Export all your books to other users. you can set a password or limit use for some users this option is very useful when you want to sell your books.',
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white))),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Skip',
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white))),
      ],
      alignment: Alignment.bottomCenter,
    );
  }
}
