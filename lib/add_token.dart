import 'package:Fast_learning/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTokens extends StatefulWidget {
  AddTokens({Key? key}) : super(key: key);

  @override
  _AddTokensState createState() => _AddTokensState();
}

class _AddTokensState extends State<AddTokens> {
  List<String> tokens = [];
  TextEditingController txtController = TextEditingController();
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50),
              child: ListView(
                children: tokens
                    .map((e) => Card(
                          child: ListTile(
                            title: Text(e),
                            trailing: InkWell(
                                onTap: () {
                                  tokens.remove(e);
                                  setState(() {});
                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  child: Icon(
                                    Icons.cancel,
                                    size: 30,
                                  ),
                                )),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                width: 300,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        style: themeContoller
                            .themeData.value.textTheme.bodyText1!
                            .copyWith(color: Colors.white),
                        controller: txtController,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (txtController.text.isNotEmpty) {
                          tokens.add(txtController.text);
                          txtController.clear();
                          setState(() {});
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Icon(Icons.add),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(start: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white)),
                      height: 35,
                      child: InkWell(
                        onTap: () {
                          Get.back(result: tokens);
                        },
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        splashColor: Colors.red,
                        child: Container(
                          child: Center(
                              child: Text(
                            'Add',
                            style: themeContoller
                                .themeData.value.textTheme.bodyText1!
                                .copyWith(color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(end: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white)),
                      height: 35,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        splashColor: Colors.red,
                        child: Container(
                          child: Center(
                              child: Text(
                            'Cancel',
                            style: themeContoller
                                .themeData.value.textTheme.bodyText1!
                                .copyWith(color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
