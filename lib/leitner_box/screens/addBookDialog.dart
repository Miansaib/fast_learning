import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_checkBox.dart';

class addBookDialog extends StatefulWidget {
  const addBookDialog({Key? key}) : super(key: key);

  @override
  State<addBookDialog> createState() => _addBookDialogState();
}

class _addBookDialogState extends State<addBookDialog> {
  late String _queslang;
  late String _anslang;
  late String _desclang;
  late String _folderlang;
  late String _days;
  List<String> _dropdownValues = [
    'En',
    'Fr',
    'Fa',
  ];

  List<String> _folderdropdownValues = [
    'English',
    'French',
    'Spanish',
  ];

  List<String> _daysdropdownValues = [
    'Days',
    '1',
    '2',
    '3',
    '4',
  ];

  @override
  void initState() {
    super.initState();
    _queslang = _dropdownValues[0];
    _anslang = _dropdownValues[0];
    _desclang = _dropdownValues[0];
    _folderlang = _folderdropdownValues[0];
    _days = _daysdropdownValues[0];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text(
          'Make a new book',
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              color: Color(0xff353535),
              fontWeight: FontWeight.w600),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextField(hinttxt: "Name of the book"),
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
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "Set Language",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      color: Color(0xff353535)),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Color(0xff353535),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Question Language:",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Color(0xff8A8A8A))),
                Spacer(),
                Container(
                  height: 35,
                  width: 55,
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
                        value: _queslang,
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
                            _queslang = newValue as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text("Answer Language:",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Color(0xff8A8A8A))),
                Spacer(),
                Container(
                  height: 35,
                  width: 55,
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
                        value: _anslang,
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
                            _anslang = newValue as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text("Description Language:",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Color(0xff8A8A8A))),
                Spacer(),
                Container(
                  height: 35,
                  width: 55,
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
                        value: _desclang,
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
                            _desclang = newValue as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "Set Password",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      color: Color(0xff353535)),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Color(0xff353535),
                )
              ],
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xffF1F2F6),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Color(0xff8A8A8A),
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xff8A8A8A)),
                      decoration: InputDecoration(
                          hintText: "Set Password",
                          contentPadding: const EdgeInsets.only(left: 10),
                          hintStyle: TextStyle(
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xff8A8A8A)),
                          border: InputBorder.none),
                    ),
                  ),
                  Spacer(),
                  Image.asset("assets/images/eye.png", width: 24, height: 24),
                  SizedBox(width: 10)
                ],
              ),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "Folder",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      color: Color(0xff353535)),
                ),
                SizedBox(width: 5),
                Icon(Icons.info_outline_rounded,
                    size: 20, color: Color(0xff353535)),
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
                        value: _folderlang,
                        items: _folderdropdownValues.map((value) {
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
                            _folderlang = newValue as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                checkBox(),
                SizedBox(width: 10),
                Text(
                  "Leithner Box setting:",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      color: Color(0xff353535)),
                ),
                SizedBox(width: 5),
                Icon(Icons.info_outline_rounded,
                    size: 20, color: Color(0xff353535)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: Color(0xffF1F2F6),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          cursorColor: Color(0xff8A8A8A),
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xff8A8A8A)),
                          decoration: InputDecoration(
                              hintText: "Time Stamp",
                              contentPadding: const EdgeInsets.only(left: 10),
                              hintStyle: TextStyle(
                                  fontFamily: "poppins",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Color(0xff8A8A8A)),
                              border: InputBorder.none),
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.info_outline_rounded,
                          size: 20, color: Color(0xff8A8A8A)),
                      SizedBox(width: 12),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.21,
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
                        value: _days,
                        items: _daysdropdownValues.map((value) {
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
                            _days = newValue as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xffF1F2F6),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Color(0xff8A8A8A),
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Color(0xff8A8A8A)),
                      decoration: InputDecoration(
                          hintText: "Leithner box",
                          contentPadding: const EdgeInsets.only(left: 10),
                          hintStyle: TextStyle(
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xff8A8A8A)),
                          border: InputBorder.none),
                    ),
                  ),
                  Icon(Icons.info_outline_rounded,
                      size: 20, color: Color(0xff8A8A8A)),
                  SizedBox(width: 12),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xffF1F2F6),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.16,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Color(0xff8A8A8A),
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Color(0xff8A8A8A)),
                      decoration: InputDecoration(
                          hintText: "Ratio",
                          contentPadding: const EdgeInsets.only(left: 10),
                          hintStyle: TextStyle(
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xff8A8A8A)),
                          border: InputBorder.none),
                    ),
                  ),
                  Icon(Icons.info_outline_rounded,
                      size: 20, color: Color(0xff8A8A8A)),
                  SizedBox(width: 12),
                ],
              ),
            ),
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
