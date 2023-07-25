import 'package:flutter/material.dart';

class addFolderDialog extends StatefulWidget {
  const addFolderDialog({Key? key}) : super(key: key);

  @override
  State<addFolderDialog> createState() => _addFolderDialogState();
}

class _addFolderDialogState extends State<addFolderDialog> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text(
          'Make new folder',
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              color: Color(0xff353535),
              fontWeight: FontWeight.w600),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextField(hinttxt: "Folder name"),
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xffF1F2F6)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/gallery-add.png",
                    width: 56,
                    height: 56,
                  ),
                  SizedBox(height: 10),
                  Text("Add photo",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8A8A8A))),
                  SizedBox(height: 10),
                  Text("• You can set a photo for the folder.",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 9,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff8A8A8A))),
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
                      fontSize: 18,
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
