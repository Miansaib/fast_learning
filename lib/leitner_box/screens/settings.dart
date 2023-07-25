import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_checkBox.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../customWidgets/_appBar.dart';

void main() => runApp(Settings());

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String _selectedValue;
  bool ischeck = false;
  double _value = 2;
  double _value2 = 20;
  bool _switchValue = false;

  List<String> _dropdownValues = [
    'English (US)',
    'British',
    'Spanish',
    'French'
  ];

  @override
  void initState() {
    super.initState();
    _selectedValue = _dropdownValues[0];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              app_Bar(
                title_text: 'Settings',
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Language",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          color: Color(0xff8A8A8A))),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff353535), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: DropdownButton(
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
                            child: Text(value),
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
                ],
              ),
              SizedBox(height: 20),
              Text("Player Speed",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: Color(0xff8A8A8A))),
              SfSlider(
                inactiveColor: Color(0xff8A8A8A),
                activeColor: Color(0xff27187E),
                stepSize: 0.5,
                min: 0.5,
                max: 2.0,
                value: _value,
                interval: 0.5,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                onChanged: (dynamic value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("Font Size",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          color: Color(0xff8A8A8A))),
                  Spacer(),
                  Text("Bold",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                          color: Color(0xff8A8A8A))),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ischeck = !ischeck;
                      });
                    },
                    child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff8A8A8A), width: 2),
                            borderRadius: BorderRadius.circular(6)),
                        child: ischeck
                            ? Icon(Icons.check,
                                color: Color(0xff353535), size: 14)
                            : Container()),
                  )
                ],
              ),
              SfSlider(
                inactiveColor: Color(0xff8A8A8A),
                activeColor: Color(0xff27187E),
                stepSize: 2,
                min: 14,
                max: 20,
                value: _value2,
                interval: 2,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                onChanged: (dynamic value) {
                  setState(() {
                    _value2 = value;
                  });
                },
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text("Night Mode",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          color: Color(0xff8A8A8A))),
                  Spacer(),
                  CupertinoSwitch(
                      activeColor: Color(0xff27187E),
                      trackColor: Color(0xff8A8A8A),
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
