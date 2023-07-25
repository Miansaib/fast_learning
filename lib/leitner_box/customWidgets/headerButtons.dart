import 'package:flutter/material.dart';

class header_buttons extends StatelessWidget {
  header_buttons({Key? key, required this.containerbgcolor, required this.img_path, required this.clr, required this.txt1, required this.txt2}) : super(key: key);
  String img_path;
  String txt1;
  String txt2;
  Color clr;
  Color containerbgcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.17,
      decoration: BoxDecoration(
        color: containerbgcolor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: clr)
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          children: [
            Image.asset(img_path, width: 23, height: 23,),
            SizedBox(height: 7),
            Text(txt1, style: TextStyle(fontFamily: "Poppins", fontSize: 12, color: clr, fontWeight: FontWeight.w300)),
            Text(txt2, style: TextStyle(fontFamily: "Poppins", fontSize: 12, color: clr, fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}