import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final storage = GetStorage();
  final themeController = Get.find<ThemeContoller>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          app_Bar(title_text: "Back"),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/Profile-Image.png"),
                    radius: 60,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Color(0xffF1F2F6)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset("assets/images/profile-edit.png",
                          width: 24, height: 24),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(color: Color(0xffF1F2F6), height: 2),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Text("Token Code:",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff8A8A8A))),
          SizedBox(height: 18),
          FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder:
                (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
              if (prefs.hasData) {
                return Text(
                  prefs.data!.getString(Preference.token) ?? "",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      color: Color(0xff27187E)),
                );
              }
              return Container();
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = prefs.getString(Preference.token) ?? "";
                  Clipboard.setData(ClipboardData(text: token)).then((value) =>
                      Get.snackbar('Warning', 'Your token copied to clipboard',
                          backgroundColor: Colors.green,
                          colorText: Colors.white));
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Color(0xffF1F2F6))),
                  width: MediaQuery.of(context).size.width * 0.5 - 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/copy.png",
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Copy",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Color(0xff27187E)),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = prefs.getString(Preference.token) ?? "";
                  Share.share(token);
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Color(0xffF1F2F6))),
                  width: MediaQuery.of(context).size.width * 0.5 - 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/share.png",
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Share",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Color(0xff27187E)),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    )));
  }
}
