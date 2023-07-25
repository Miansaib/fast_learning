import 'dart:async';

import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/tools/show_loading_widget.dart';
import 'package:Fast_learning/tools/tools.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../add_token.dart';
import '../../constants/custom_color.dart';
import '../../controllers/cards_controller.dart';
import '../../controllers/theme_controller.dart';
import 'lesson_page.dart';

class SelectLessons extends StatefulWidget {
  final List<Lesson> lessons;
  final SubGroup subGroup;
  SelectLessons({Key? key, required this.lessons, required this.subGroup})
      : super(key: key);

  @override
  _SelectLessonsState createState() => _SelectLessonsState();
}

class _SelectLessonsState extends State<SelectLessons> {
  CardsController _cardsController = Get.find<CardsController>();
  ThemeContoller themeContoller = Get.find<ThemeContoller>();
  List<Lesson> selectLessons = [];
  List<ListItem<Lesson>> list = [];
  @override
  void initState() {
    super.initState();
    getItems();
  }

  Future select_lessons_page_zip_without_token() async {
    List<int> selectedIdGroups = getSelectedId();

    await zipLessons(widget.subGroup, lessonIds: selectedIdGroups)
        .then((value) {
      _cardsController.rebind();
      Get.back();
    });
  }

  Future select_lessons_page_zip_with_token(List<String>? tokens) async {
    List<int> selectedIdGroups = getSelectedId();

    print(tokens);
    if (tokens != null && tokens.length != 0) {
      await zipLessons(widget.subGroup,
          lessonIds: selectedIdGroups, tokens: tokens);
      _cardsController.rebind();
      Get.back();
    } else {
      Get.back();
      Get.snackbar('warning', 'please add token',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
              height: 400,
              //color: Colors.white,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: _getListItemTile,
              ),
            ),
            Positioned(
                bottom: 10,
                right: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.of(context).size.width / 2 - 20,
                              40), // double.infinity is the width and 30 is the height
                        ),
                        onPressed: () async {
                          List<int> selectedIdGroups = getSelectedId();

                          if (selectedIdGroups.length == 0) {
                            Get.snackbar(
                                'warning'.tr, 'Select book is required',
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white);
                            return;
                          }
                          // await zipLessons(widget.subGroup,
                          //     lessonIds: selectedIdGroups);
                          // _cardsController.rebind();
                          // Get.back();
                          // setState(() {});
                          await Get.defaultDialog(
                              title: 'Warning',
                              middleText: 'Do you want to add tokens?',
                              confirmTextColor: Colors.white,
                              actions: get_popup_widget(
                                  "Without Token",
                                  select_lessons_page_zip_without_token,
                                  "With Token",
                                  select_lessons_page_zip_with_token,
                                  "Loading",
                                  context));
                        },
                        child: Text('ok')),
                    // Container(width: 10,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.of(context).size.width / 2 - 20,
                              40), // double.infinity is the width and 30 is the height
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('close')),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  List<ListItem<Lesson>> getItems() {
    //List<ListItem<String>> list = [];
    for (var item in widget.lessons) {
      list.add(ListItem<Lesson>(item));
    }
    return list;
  }

  List<int> getSelectedId() {
    List<int> result = [];
    for (var item in list) {
      if (item.isSelected) {
        result.add(item.data.id!);
      }
    }
    return result;
  }

  Widget _getListItemTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (list.any((item) => item.isSelected)) {
          setState(() {
            list[index].isSelected = !list[index].isSelected;
          });
        } else {
          list[index].isSelected = true;
          setState(() {});
        }
        // for(var item in list){
        //  item.isSelected = false;
        // }
        // list[index].isSelected = !list[index].isSelected;
        // setState(() {});
      },
      // onLongPress: () {
      //   setState(() {
      //     list[index].isSelected = true;
      //   });
      // },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        color: list[index].isSelected ? Colors.red[100] : Colors.white,
        child: ListTile(
          title: Text(list[index].data.title!,
              style:
                  themeContoller.themeData.value.textTheme.bodyText1!.copyWith(
                color: CustomColor.grey,
              )),
        ),
      ),
    );
  }
}

class ListItem<T> {
  bool isSelected = false; //Selection property to highlight or not
  T data; //Data of the user
  ListItem(this.data); //Constructor to assign the data
}
