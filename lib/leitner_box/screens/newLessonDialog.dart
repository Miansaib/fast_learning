import 'package:flutter/material.dart';

class newLessonDialog extends StatefulWidget {
  const newLessonDialog({Key? key}) : super(key: key);

  @override
  State<newLessonDialog> createState() => _newLessonDialogState();
}

class _newLessonDialogState extends State<newLessonDialog> {
  late String _selectedValue;
  List<String> _dropdownValues = [
    'French in 90 days',
    '504 English words',
    'German phrase book',
    '504 English words'
  ];

  @override
  void initState() {
    super.initState();
    _selectedValue = _dropdownValues[0];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text(
          'Make New Lesson',
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              color: Color(0xff353535),
              fontWeight: FontWeight.w600),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextField(hinttxt: "Name of the lesson"),
            SizedBox(height: 15),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.5 - 69,
                    decoration: BoxDecoration(
                        color: Color(0xffF1F2F6),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Image.asset("assets/images/gallery-add.png",
                            width: 56, height: 56),
                        SizedBox(height: 2),
                        Text("Add Photo",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xff8A8A8A))),
                        SizedBox(height: 10),
                        Text("• You can set a photo",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 9,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff8A8A8A))),
                        Text("for the Lesson.",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 9,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff8A8A8A))),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.5 - 69,
                    decoration: BoxDecoration(
                        color: Color(0xffF1F2F6),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/microphone-icon.png",
                            width: 56, height: 56),
                        SizedBox(height: 2),
                        Text("Add Voice",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xff8A8A8A))),
                        SizedBox(height: 10),
                        Text("• You can add voice",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 9,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff8A8A8A))),
                        Text("by microphone or",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 9,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff8A8A8A))),
                        Text("select sound file",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 9,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff8A8A8A))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Text(
              "Note 1",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: "Poppins",
                  color: Color(0xff353535)),
            ),
            SizedBox(height: 10),
            customTextField(hinttxt: "Title"),
            SizedBox(height: 15),
            customTextField(hinttxt: "Write your text here..."),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                        color: Color(0xffF1F2F6),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Image.asset("assets/images/gallery-add.png",
                            width: 44, height: 44),
                        SizedBox(height: 10),
                        Text("Add Photo",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                                color: Color(0xff8A8A8A))),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: AddVoiceContainer(txt: "Add first voice")),
                    SizedBox(height: 10),
                    GestureDetector(
                        onTap: () {},
                        child: AddVoiceContainer(txt: "Add second voice")),
                  ],
                )
              ],
            ),
            SizedBox(height: 25),
            Text(
              "Note 2",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: "Poppins",
                  color: Color(0xff353535)),
            ),
            SizedBox(height: 10),
            customTextField(hinttxt: "Title"),
            SizedBox(height: 15),
            customTextField(hinttxt: "Write your text here..."),
            SizedBox(height: 15),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                        color: Color(0xffF1F2F6),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Image.asset("assets/images/gallery-add.png",
                            width: 44, height: 44),
                        SizedBox(height: 10),
                        Text("Add Photo",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                                color: Color(0xff8A8A8A))),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: AddVoiceContainer(txt: "Add first voice")),
                    SizedBox(height: 10),
                    GestureDetector(
                        onTap: () {},
                        child: AddVoiceContainer(txt: "Add second voice")),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Book:",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xff353535))),
                SizedBox(width: 5),
                Icon(Icons.info_outline_rounded,
                    color: Color(0xff353535), size: 20),
                Spacer(),
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff353535), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down_outlined),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            color: Color(0xff353535)),
                        value: _selectedValue,
                        items: _dropdownValues.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedValue = newValue as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
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
