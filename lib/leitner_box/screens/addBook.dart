import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:Fast_learning/leitner_box/screens/addBookDialog.dart';

import 'bookLesson.dart';

class addBook extends StatefulWidget {
  const addBook({Key? key}) : super(key: key);

  @override
  State<addBook> createState() => _addBookState();
}

class _addBookState extends State<addBook> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                app_Bar(title_text: "Language books"),
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
                              "You can import books that your",
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
                              "You can also Export all your books",
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Poppins",
                                  color: Color(0xff27187E))),
                          SizedBox(height: 2),
                          Container(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    textAlign: TextAlign.justify,
                                    "to other users.",
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
                          return addBookDialog();
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
                                Text("Add book",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xff8A8A8A)))
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                                "inside the folder, you should make a book and put",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 9,
                                    color: Color(0xff8A8A8A))),
                            SizedBox(height: 5),
                            Container(
                              width: 225,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("your flashcards inside it.",
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
