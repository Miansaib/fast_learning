import 'dart:convert';
import 'dart:math';

import 'package:Fast_learning/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordChange extends StatefulWidget {
  final SubGroup subGroup;
  PasswordChange({Key? key, required this.subGroup}) : super(key: key);

  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  TextEditingController txtPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width - 100,
        height: min(200, size.height),
        child: Center(
          child: Stack(
            children: [
              TextFormField(
                controller: txtPassword,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        widget.subGroup.password =
                            utf8.encode(txtPassword.text).toString();
                        int? result = await widget.subGroup.save();
                        Get.back(result: true);
                        // if( utf8.encode(txtPassword.text).toString()  == widget.password){
                        //      Get.back(result: true);
                        // }else{
                        //   Get.snackbar('warning'.tr, 'wrong_password'.tr,backgroundColor: Colors.red,colorText: Colors.white);
                        // }
                      },
                      child: Text('Ok')),
                ),
              )
            ],
          ),
        ));
  }
}
