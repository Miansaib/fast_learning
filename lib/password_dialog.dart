import 'dart:convert';
import 'dart:math';

import 'package:Fast_learning/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordDialog extends StatefulWidget {
  final String password;
  PasswordDialog({Key? key, required this.password}) : super(key: key);

  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
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
                      onPressed: () {
                        if (utf8.encode(txtPassword.text).toString() ==
                            widget.password) {
                          Get.back(result: true);
                        } else {
                          Get.snackbar('warning'.tr, 'wrong_password'.tr,
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
                      },
                      child: Text('Ok')),
                ),
              )
            ],
          ),
        ));
  }
}
