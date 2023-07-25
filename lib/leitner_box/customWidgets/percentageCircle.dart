import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class percetageCircle extends StatelessWidget {
  percetageCircle({
    Key? key,
    required this.image_widget,
    required this.txt1,
    required this.percentage_text,
    required this.percent,
    required this.percent_bg_color,
    required this.percent_progress_color,
    this.txt2 = '',
  }) : super(key: key);
  Image image_widget;
  String txt1;
  String txt2;
  String percentage_text;
  double percent;
  Color percent_bg_color;
  Color percent_progress_color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 70,
            height: 75,
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                child: image_widget)),
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  boxShadow: [
                    // BoxShadow(
                    //     color: Colors.black12, blurRadius: 100, spreadRadius: 1)
                  ]),
              height: 75,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              txt1,
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xff353535),
                                fontSize: 18,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Text(txt2,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: Color(0xff353535))),
                      ],
                    ),
                    ownCircle(
                        percent: percent, percentage_text: percentage_text),
                  ],
                ),
              )),
        )
      ],
    );
  }
}

CircularPercentIndicator ownCircle(
    {double percent = 0, String percentage_text = '0'}) {
  final colorIndex = (percent * 10).floor().toInt();

  const List<Color> colors = [
    Color(0xFFB71C1C),
    Colors.red,
    Color(0xFFEF6C00),
    Color(0xFFF57F17),
    Colors.orange,
    Colors.yellow,
    Colors.lightGreen,
    Color(0xFF689F38),
    Color(0xFF388E3C),
    Color(0xFF1B5E20),
    Color(0xFF1B5E20),
  ];
  return CircularPercentIndicator(
    radius: 22,
    backgroundColor: colors[colorIndex].withOpacity(.2),
    progressColor: colors[colorIndex],
    percent: percent,
    center: Text(
      percentage_text,
      style: TextStyle(
          fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 13),
    ),
  );
}
