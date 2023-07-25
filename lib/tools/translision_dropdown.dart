import 'package:Fast_learning/controllers/translation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranslateDropDown extends StatefulWidget {
  final int initialChoice;
  final Function(int) onChange;
  final bool isSourceLang;
  TranslateDropDown(
      {Key? key,
      required this.initialChoice,
      required this.onChange,
      required this.isSourceLang})
      : super(key: key);

  @override
  _TranslateDropDownState createState() => _TranslateDropDownState();
}

class _TranslateDropDownState extends State<TranslateDropDown> {
  int curentValue = 0;
  @override
  void initState() {
    curentValue = widget.initialChoice;
    super.initState();
  }

  TranslationController trc = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: DropdownButton<int>(
        value: curentValue,
        items: [
          if (widget.isSourceLang)
            DropdownMenuItem<int>(
              value: -1,
              child: Text(
                'Auto',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          for (var i = 0; i < trc.options.length; i++)
            DropdownMenuItem<int>(
              value: i,
              child: Text(
                trc.options[i],
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
        ],
        onChanged: (value) {
          setState(() {
            curentValue = value!;
            widget.onChange(value);
          });
        },
      ),
    );
  }
}
