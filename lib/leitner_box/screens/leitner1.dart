import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/screens/myFolders2.dart';

class Leitner1 extends StatefulWidget {
  const Leitner1({Key? key}) : super(key: key);

  @override
  State<Leitner1> createState() => _Leitner1State();
}

class _Leitner1State extends State<Leitner1> {
  List<String> ImgPath = [
    'assets/images/folder-pic-1.png',
    'assets/images/folder-pic-2.png',
    'assets/images/folder-pic-3.png'
  ];
  List<String> Name = ['Language', 'Physics', 'Chemistry'];
  List<String> Books = ['3 Books', '4 Books', '2 Books'];

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
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          AssetImage("assets/images/Profile-Image.png"),
                    ),
                    SizedBox(width: 10),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff353535),
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Hi Jacob!\n'),
                          TextSpan(
                              text: 'Token Code',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 9,
                                  color: Color(0xff27187E))),
                        ],
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xffF1F2F6), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        width: 52,
                        height: 52,
                        child: Stack(
                          children: [
                            Center(
                                child: Image.asset(
                              "assets/images/notification-icon.png",
                              width: 24,
                              height: 24,
                            )),
                            Positioned(
                              top: 3.5,
                              left: 3.5,
                              child: CircleAvatar(
                                backgroundColor: Color(0xffE04318),
                                radius: 8,
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
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
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 50,
                          minHeight: 50,
                        ),
                        prefixIcon: Container(
                            width: 30,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child:
                                  Image.asset("assets/images/search-icon.png"),
                            )),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Image.asset(
                            "assets/images/microphone-2.png",
                            width: 24,
                            height: 24,
                          ),
                        ),
                        suffixIconConstraints:
                            BoxConstraints(minWidth: 50, minHeight: 50),
                        hintText: "Search",
                        contentPadding:
                            const EdgeInsets.only(left: 10, top: 14),
                        hintStyle: TextStyle(
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff8A8A8A)),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Text("Library",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            color: Color(0xff353535),
                            fontWeight: FontWeight.w700)),
                    Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: Center(
                            child: Text("See All",
                                style: TextStyle(
                                    color: Color(0xff27187E),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    fontFamily: "Poppins"))),
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Color(0xffF1F2F6), width: 2)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ImgPath.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: 150,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(ImgPath[index]),
                                SizedBox(height: 10),
                                Text(Name[index],
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Color(0xff353535),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 15),
                                Text(Books[index],
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Color(0xff353535),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("My Folders",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            color: Color(0xff353535),
                            fontWeight: FontWeight.w700)),
                    Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: Center(
                            child: Text("See All",
                                style: TextStyle(
                                    color: Color(0xff27187E),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    fontFamily: "Poppins"))),
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Color(0xffF1F2F6), width: 2)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                DottedBorder(
                    color: Color(0xff8A8A8A),
                    borderType: BorderType.RRect,
                    dashPattern: [10, 4],
                    strokeWidth: 1,
                    padding: EdgeInsets.all(0),
                    radius: Radius.circular(10),
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                          color: Color(0xffF1F2F6),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Icon(
                            Icons.add,
                            size: 24,
                            color: Color(0xff8A8A8A),
                          ),
                          SizedBox(height: 5),
                          Text("Add Folder",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff8A8A8A))),
                          SizedBox(height: 40),
                          Text("for making flashcards\nfirst you need to make",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff8A8A8A))),
                          Container(
                            width: 108,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("a new folder..",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff8A8A8A))),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 20,
                                  color: Color(0xff8A8A8A),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 8)
                        ],
                      ),
                    )),
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavBar(),
      ),
    );
  }
}
