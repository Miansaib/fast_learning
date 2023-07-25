import 'package:Fast_learning/constants/custom_color.dart';
import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/controllers/music_controller.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../controllers/theme_controller.dart';
import '../../../card_view_page.dart';
import '../../show_hint.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final storage = GetStorage();
  final themeController = Get.find<ThemeContoller>();
  final _1_token = GlobalKey();
  // final fontStream = BehaviorSubject.seeded(0.0);
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      themeController.mainContentFontSize(
          prefs.getDouble(Preference.mainContentFontSize) ?? 14);
      themeController.mainContentFontWeightBold(
          (prefs.getBool(Preference.mainContentFontWeightISBold) ?? true)
              ? FontWeight.bold
              : FontWeight.normal);
      SharedPreferences.getInstance().then((prefs) {
        final doShow = prefs.getBool(Preference.show_hint_setting_page) ?? true;
        show_hint(this.context, [_1_token], doShow);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // fontStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            app_Bar(
              title_text: 'setting'.tr,
              canGoBack: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                child: ListView(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Language",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                            // color: Color(0xff8A8A8A)
                          )),
                      Container(
                        height: 40,
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: Color(0xff353535), width: 1),
                        //     borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    // final storage = GetStorage();
                                    //  await storage.write(Preference.language, 'en');

                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(Preference.language, 'en');
                                    Get.updateLocale(Locale('en', 'US'));
                                  },
                                  focusColor: Get.theme.backgroundColor,
                                  highlightColor: Get.theme.backgroundColor,
                                  child: Obx(
                                    () => Container(
                                      padding: EdgeInsets.only(
                                          right: 10,
                                          left: 10,
                                          top: 5,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                          color:
                                              Get.locale!.languageCode == 'en'
                                                  ? themeController
                                                      .themeData
                                                      .value
                                                      .textTheme
                                                      .button!
                                                      .color
                                                  : themeController.themeData
                                                      .value.disabledColor,
                                          shape: BoxShape.rectangle,
                                          border: Border.all()),
                                      child: Text('En'),
                                    ),
                                  )),
                              Container(width: 20),
                              InkWell(
                                onTap: () async {
                                  // await storage.write(Preference.language, 'fa');
                                  // Get.updateLocale(Locale('fa', 'IR'));

                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString(Preference.language, 'fa');
                                  Get.updateLocale(Locale('fa', 'IR'));
                                },
                                // focusColor: Get.theme.backgroundColor,
                                // highlightColor: Get.theme.backgroundColor,
                                child: Obx(
                                  () => Container(
                                    padding: EdgeInsets.only(
                                        right: 10, left: 10, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        color: Get.locale!.languageCode == 'fa'
                                            ? themeController.themeData.value
                                                .textTheme.button!.color
                                            : themeController
                                                .themeData.value.disabledColor,
                                        shape: BoxShape.rectangle,
                                        border: Border.all()),
                                    child: Text('Fa'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // child: DropdownButton(
                          //   icon: Icon(Icons.arrow_drop_down_outlined),
                          //   style: TextStyle(
                          //       fontSize: 15,
                          //       fontWeight: FontWeight.w400,
                          //       fontFamily: "Poppins",
                          //       color: Color(0xff353535)),
                          //   value: _selectedValue,
                          //   items: _dropdownValues.map((value) {
                          //     return DropdownMenuItem(
                          //       value: value,
                          //       child: Text(value),
                          //     );
                          //   }).toList(),
                          //   onChanged: (newValue) {
                          //     setState(() {
                          //       _select = newValue as String;
                          //     });
                          //   },
                          // ),
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
                  Obx(() {
                    MusicController musicController = Get.find();

                    return SfSlider(
                      inactiveColor: Color(0xff8A8A8A),
                      // activeColor: Color(0xff27187E),
                      stepSize: 0.25,
                      min: 0.5,
                      max: 2.0,
                      value: musicController.speedController.speed.value,
                      interval: 0.5,
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      onChanged: (dynamic value) {
                        setState(() {
                          musicController.player.setSpeed(value);
                          musicController.speedController.changeSpeed(value);
                        });
                      },
                    );
                  }),
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
                      StreamBuilder<Object>(
                          initialData:
                              themeController.mainContentFontWeightBold ==
                                  FontWeight.bold,
                          stream:
                              themeController.mainContentFontWeightBold.stream,
                          builder: (context, snapshot) {
                            return Checkbox(
                                value:
                                    themeController.mainContentFontWeightBold ==
                                        FontWeight.bold,
                                onChanged: (value) {
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setBool(
                                        Preference.mainContentFontWeightISBold,
                                        value ?? true);
                                  });
                                  themeController.mainContentFontWeightBold(
                                      value!
                                          ? FontWeight.bold
                                          : FontWeight.normal);
                                });
                          }),
                    ],
                  ),
                  SfSlider(
                    inactiveColor: Color(0xff8A8A8A),
                    // activeColor: Color(0xff27187E),
                    stepSize: 1,
                    min: 10,
                    max: 30,
                    value: themeController.mainContentFontSize.value,
                    interval: 5,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    onChanged: (dynamic value) {
                      setState(() {
                        themeController.mainContentFontSize(value);
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setDouble(
                              Preference.mainContentFontSize, value);
                        });
                      });
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: StreamBuilder<Object>(
                          stream: themeController.mainContentFontSize.stream,
                          builder: (context, snapshot) {
                            return StreamBuilder<Object>(
                                stream: themeController
                                    .mainContentFontWeightBold.stream,
                                builder: (context, snapshot) {
                                  return Text("Example Text",
                                      style: themeController.mainContentStyle);
                                });
                          }),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Theme".tr,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                                color: Color(0xff8A8A8A))),
                        Wrap(
                          spacing: 8,
                          children: [
                            // theme_mod_item(3, Colors.white, CupertinoIcons.moon,
                            //     bg_color: Colors.black),
                            theme_mod_item(
                                0, Colors.white, CupertinoIcons.sun_dust,
                                bg_color: CustomColor.primaryMaterialColor),
                            theme_mod_item(
                                2, Colors.white, CupertinoIcons.sun_dust,
                                bg_color: Colors.orange),
                            theme_mod_item(
                                1, Colors.white, CupertinoIcons.sun_dust,
                                bg_color: Colors.teal),
                            theme_mod_item(
                                4, Colors.white, CupertinoIcons.sun_dust,
                                bg_color: Color(0xff27187E)),
                          ],
                        ),
                      ]),
                  //         Row(
                  //   children: [
                  //     Text("Night Mode",
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w600,
                  //             fontFamily: "Poppins",
                  //             color: Color(0xff8A8A8A))),
                  //     Spacer(),
                  //     CupertinoSwitch(
                  //         activeColor: Color(0xff27187E),
                  //         trackColor: Color(0xff8A8A8A),
                  //         value: _switchValue,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             _switchValue = value;
                  //           });
                  //         })
                  //   ],
                  // ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell theme_mod_item(int index, Color iconColor, IconData icon,
      {Color bg_color = Colors.white}) {
    return InkWell(
      onTap: () {
        Get.find<ThemeContoller>().buildThemeData(themeIndex: index);
        Get.changeTheme(Get.find<ThemeContoller>().themeData.value);
      },
      child: CircleAvatar(
        backgroundColor: bg_color,
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
