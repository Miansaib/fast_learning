import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_checkBox.dart';

class makeNewFlashcardDialog extends StatefulWidget {
  const makeNewFlashcardDialog({Key? key}) : super(key: key);

  @override
  State<makeNewFlashcardDialog> createState() => _makeNewFlashcardDialogState();
}

class _makeNewFlashcardDialogState extends State<makeNewFlashcardDialog> {
  bool ischeck = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text(
          'Make New Flashcard',
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              color: Color(0xff353535),
              fontWeight: FontWeight.w600),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextField(hinttxt: "Question"),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {},
              child: addVoiceContainer(),
            ),
            SizedBox(height: 20),
            customTextField(hinttxt: "Answer"),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: addVoiceContainer(),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xffF1F2F6),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 18, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8A8A8A),
                            fontFamily: "Poppins")),
                    Container(
                      height: 25,
                      child: TextFormField(
                        cursorColor: Color(0xff8A8A8A),
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                            fontSize: 9,
                            color: Color(0xff8A8A8A)),
                        decoration: InputDecoration(
                            hintText:
                                "• more detail for an answer if it is needed",
                            hintStyle: TextStyle(
                                fontFamily: "poppins",
                                fontWeight: FontWeight.w300,
                                fontSize: 9,
                                color: Color(0xff8A8A8A)),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: addVoiceContainer(),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                    color: Color(0xffF1F2F6),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/gallery-add.png",
                        width: 56, height: 56),
                    SizedBox(height: 10),
                    Text("Add Photo",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff8A8A8A))),
                    SizedBox(height: 10),
                    Text("• You can set a photo for the flashcard.",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                            fontSize: 9,
                            color: Color(0xff8A8A8A))),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      ischeck = !ischeck;
                    });
                  },
                  child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff8A8A8A), width: 2),
                          borderRadius: BorderRadius.circular(6)),
                      child: ischeck
                          ? Icon(Icons.check,
                              color: Color(0xff27187E), size: 14)
                          : Container()),
                ),
                SizedBox(width: 10),
                Text(
                  "Spell ask?",
                  style: TextStyle(
                      color: Color(0xff8A8A8A),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                )
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("•   It means the user has to write the answer",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 9,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff8A8A8A))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 39),
              child: Row(
                children: [
                  Text("and check the spell by app or not.",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 9,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff8A8A8A))),
                  SizedBox(width: 5),
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0x958A8A8A),
                    size: 20,
                  )
                ],
              ),
            )
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xff27187E)),
                child: Center(
                    child: Text(
                  "Make it!",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class customTextField extends StatefulWidget {
  customTextField({Key? key, required this.hinttxt}) : super(key: key);
  String hinttxt;

  @override
  State<customTextField> createState() => _customTextFieldState();
}

class _customTextFieldState extends State<customTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        cursorColor: Color(0xff8A8A8A),
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff8A8A8A)),
        decoration: InputDecoration(
            hintText: widget.hinttxt,
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff8A8A8A)),
            border: InputBorder.none),
      ),
    );
  }
}

class AddVoiceContainer extends StatelessWidget {
  AddVoiceContainer({Key? key, required this.txt}) : super(key: key);
  String txt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.41,
      height: 55,
      decoration: BoxDecoration(
          color: Color(0xffF1F2F8), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Image.asset("assets/images/microphone-icon.png",
              width: 40, height: 40),
          Text(
            txt,
            style: TextStyle(
                fontFamily: "Poppins",
                color: Color(0xff8A8A8A),
                fontSize: 12,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

class addVoiceContainer extends StatelessWidget {
  const addVoiceContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color(0xffF1F2F6), borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/images/microphone-icon.png",
                width: 42, height: 42),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Voice",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xff8A8A8A))),
                SizedBox(height: 7),
                Container(
                  width: MediaQuery.of(context).size.width * 0.395,
                  child: Text(
                      "You can add voice by micro phone or select sound file",
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 9,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff8A8A8A))),
                ),
                Text("",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 9,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff8A8A8A))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
