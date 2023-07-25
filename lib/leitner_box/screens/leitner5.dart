import 'dart:io';

import 'package:Fast_learning/constants/preference.dart';
import 'package:Fast_learning/controllers/download_controller.dart';
import 'package:Fast_learning/controllers/inapp_purchase_controller.dart';
import 'package:Fast_learning/leitner_box/screens/popupScreen.dart';
import 'package:Fast_learning/leitner_box/screens/singlePopscreen.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/pages/buy_subscription/buy_subscription_page.dart';
import 'package:Fast_learning/pages/childs/downloads_page/download_view.dart';
import 'package:Fast_learning/tools/export/subgroup_page.dart';
import 'package:Fast_learning/tools/extension.dart';
import 'package:Fast_learning/zcomponent/common_widget/hintdialog.dart';
import 'package:Fast_learning/zcomponent/homepage/folder/controller/foldercontroller.dart';
import 'package:Fast_learning/zcomponent/homepage/folder/view/allfolder.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/screens/myFolders2.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Leitner5 extends StatefulWidget {
  const Leitner5({Key? key}) : super(key: key);

  @override
  State<Leitner5> createState() => _Leitner5State();
}

class _Leitner5State extends State<Leitner5> {
  List<String> LibImgPath = [
    'assets/images/folder-pic-1.png',
    'assets/images/folder-pic-2.png',
    'assets/images/folder-pic-3.png'
  ];
  List<String> LibSubject = ['Language', 'Physics', 'Chemistry'];
  List<String> LibBooks = ['3 Books', '4 Books', '2 Books'];

  List<String> MyImgPath = [
    'used to show add folder',
    'assets/images/folder-pic-4.png',
    'assets/images/folder-pic-5.png',
  ];
  List<String> MySubject = ['used to show add folder', 'Language', 'History'];
  List<String> MyBooks = ['used to show add folder', '3 Books', '3 Books'];
  DownloadController dc = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Icon
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.defaultDialog(
                            title: "Token Code",
                            content: Container(
                                height: 300, child: getTokenDialog(context)));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                AssetImage("assets/images/Profile-Image.png"),
                          ),
                          SizedBox(width: 10),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xff353535),
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'My Token'),
                                // TextSpan(
                                // text: 'Token Code',
                                // style: TextStyle(
                                //     fontWeight: FontWeight.w300,
                                //     fontSize: 9,
                                //     color: Color(0xff27187E))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notifications
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.dialog(MyTabbedPopup());
                      },
                      child: Obx(
                        () {
                          DownloadController dc = Get.find();
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xffF1F2F6), width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            width: 52,
                            height: 52,
                            child: Stack(
                              children: [
                                Center(
                                    child: Image.asset(
                                  "assets/images/notification-icon.png",
                                  width: 24,
                                  height: 24,
                                )),
                                Positioned(
                                  top: 3.5,
                                  left: 3.5,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffE04318),
                                    radius: 8,
                                    child: Text(
                                      dc.filterdBooks.length.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                // SizedBox(height: 20),
                // Search
                // Container(
                //   decoration: BoxDecoration(
                //       color: Color(0xffF1F2F6),
                //       borderRadius: BorderRadius.circular(15)),
                //   child: TextFormField(
                //     cursorColor: Color(0xff8A8A8A),
                //     style: TextStyle(
                //         fontFamily: "Poppins",
                //         fontWeight: FontWeight.w400,
                //         fontSize: 16,
                //         color: Color(0xff8A8A8A)),
                //     decoration: InputDecoration(
                //         prefixIconConstraints: BoxConstraints(
                //           minWidth: 50,
                //           minHeight: 50,
                //         ),
                //         prefixIcon: Container(
                //             width: 30,
                //             child: Padding(
                //               padding:
                //                   const EdgeInsets.only(left: 12, right: 12),
                //               child:
                //                   Image.asset("assets/images/search-icon.png"),
                //             )),
                //         suffixIcon: Padding(
                //           padding: const EdgeInsets.only(left: 12, right: 12),
                //           child: Image.asset(
                //             "assets/images/microphone-2.png",
                //             width: 24,
                //             height: 24,
                //           ),
                //         ),
                //         suffixIconConstraints:
                //             BoxConstraints(minWidth: 50, minHeight: 50),
                //         hintText: "Search",
                //         contentPadding:
                //             const EdgeInsets.only(left: 10, top: 14),
                //         hintStyle: TextStyle(
                //             fontFamily: "poppins",
                //             fontWeight: FontWeight.w400,
                //             fontSize: 16,
                //             color: Color(0xff8A8A8A)),
                //         border: InputBorder.none),
                //   ),
                // ),

                SizedBox(height: 30),
                // Library
                Row(
                  children: [
                    Text("Library",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            color: Color(0xff353535),
                            fontWeight: FontWeight.w700)),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        InAppPurchaseController controller = Get.find();

                        // var x = await .getById(2);
                        if (!controller.isPremium) {
                          Get.to(() => BuySubscriptionPage());
                        } else {
                          // var x = await .getById(2);
                          await Navigator.of(context).push(
                            CupertinoPageRoute<void>(
                              builder: (BuildContext context) {
                                return DownloadsView();
                              },
                            ),
                          );
                          // await Get.to(() => DownloadsView());
                        }
                      },
                      child: Container(
                        child: Center(
                            child: Text("See All",
                                style: TextStyle(
                                    color: Color(0xff27187E),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    fontFamily: "Poppins"))),
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Color(0xffF1F2F6), width: 2)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Obx(() {
                  return Container(
                    height: 210,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dc.booksWithoutNews.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Get.dialog(
                              SinglePopScreen(dc.booksWithoutNews[index]),
                            );
                          },
                          child: SizedBox(
                            width: 150,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: dc.booksWithoutNews[index].images
                                              .isNotEmpty
                                          ? Image.network(
                                              dc.booksWithoutNews[index].images
                                                  .first.image,
                                              height: 130,
                                              width: 140,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/noimage.png',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                        dc.booksWithoutNews[index].title
                                            .capitalizer(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: Color(0xff353535),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    // SizedBox(height: 15),
                                    // Text(
                                    //     dc.booksWithoutNews[index].category
                                    //         .toString(),
                                    //     style: TextStyle(
                                    //         fontFamily: "Poppins",
                                    //         color: Color(0xff353535),
                                    //         fontSize: 14,
                                    //         fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                SizedBox(height: 20),
                // My Folder
                Row(
                  children: [
                    Text("My Folders",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            color: Color(0xff353535),
                            fontWeight: FontWeight.w700)),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        // await Get.to(() => MyFolders());
                        await Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (BuildContext context) {
                              return CupertinoPageScaffold(
                                  resizeToAvoidBottomInset: true,
                                  child: MyFolders());
                            },
                          ),
                        );
                        refreshPage();
                      },
                      child: Container(
                        child: Center(
                            child: Text("See All",
                                style: TextStyle(
                                    color: Color(0xff27187E),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    fontFamily: "Poppins"))),
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Color(0xffF1F2F6), width: 2)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 220,
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: InkWell(
                              onTap: () async {
                                InAppPurchaseController inappc = Get.find();

                                if (!inappc.isPremium) {
                                  Get.to(() => BuySubscriptionPage());
                                } else {
                                  // var x = await .getById(2);
                                  await Get.defaultDialog(
                                    content: RootGroupAdd(RootGroup()),
                                  );
                                  setState(() {});
                                }
                              },
                              child: DottedBorder(
                                color: Color(0xff8A8A8A),
                                borderType: BorderType.RRect,
                                dashPattern: [10, 4],
                                strokeWidth: 1,
                                padding: EdgeInsets.all(1),
                                radius: Radius.circular(10),
                                child: Container(
                                  width: 130,
                                  height: 220,
                                  decoration: BoxDecoration(
                                      color: Color(0xffF1F2F6),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 50),
                                        Icon(
                                          Icons.add,
                                          size: 24,
                                          color: Color(0xff8A8A8A),
                                        ),
                                        SizedBox(height: 5),
                                        Text("Add Folder",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff8A8A8A))),
                                        SizedBox(height: 50),
                                        Text(
                                            "for making flashcards first you need to make folder. In each folder you can create your books, inside of each books you can add some lessons and inside of each lesson, you create flashcard.",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300,
                                                color: Color(0xff8A8A8A))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: hintDialog('Add Folder',
                                  '"for making flashcards first you need to make folder. In each folder you can create your books, inside of each books you can add some lessons and inside of each lesson, you create flashcard."'))
                        ],
                      ),
                      Expanded(child: folder_item_generator()),
                    ],
                  ),
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
        // bottomNavigationBar: NavBar(),
      ),
    );
  }

  Widget getTokenDialog(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                future: SharedPreferences.getInstance(),
                builder: (BuildContext context,
                    AsyncSnapshot<SharedPreferences> prefs) {
                  if (prefs.hasData) {
                    return Text(
                      prefs.data!.getString(Preference.token) ?? "",
                      maxLines: 3,
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
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String token = prefs.getString(Preference.token) ?? "";
                      Clipboard.setData(ClipboardData(text: token)).then(
                          (value) => Get.snackbar(
                              'Done!', 'Your token copied to clipboard',
                              backgroundColor: Colors.green,
                              colorText: Colors.white));
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(width: 1, color: Color(0xffF1F2F6))),
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
                          border:
                              Border.all(width: 1, color: Color(0xffF1F2F6))),
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
            ]),
      ),
    );
  }

  void refreshPage() {
    setState(() {});
  }

  Widget folder_item_generator({Axis? axis}) {
    FolderController fc = Get.find();
    InAppPurchaseController inappc = Get.find();

    return FutureBuilder(
        future: fc.getrootGroups(),
        builder: (context, AsyncSnapshot<List<RootGroup>> groups) {
          if (groups.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            scrollDirection: axis ?? Axis.horizontal,
            itemCount: groups.data!.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 150,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (!inappc.isPremium) {
                          Get.to(BuySubscriptionPage());
                        } else {
                          Navigator.of(context).push(
                            CupertinoPageRoute<void>(
                              builder: (BuildContext context) {
                                return CupertinoPageScaffold(
                                    child: SubgroupPage(
                                  rootGroup: groups.data![index],
                                  refreshParentPageFunc: refreshPage,
                                ));
                              },
                            ),
                          );
                          // await Get.to(() => SubgroupPage(
                          //       rootGroup: groups.data![index],
                          //       refreshParentPageFunc: refreshPage,
                          //     ));
                        }
                        refreshPage();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 128,
                            width: 128,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: groups.data![index].imagePath != ''
                                  ? Image.file(
                                      File(groups.data![index].imagePath!),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/noimage.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 82,
                            height: 50,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  groups.data![index].title ?? '',
                                  style: TextStyle(
                                    color: Color(0xff353535),
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 5),
                                FutureBuilder(
                                    future: SubGroup()
                                        .select()
                                        .rootGroupId
                                        .equals(groups.data![index].id)
                                        .toCount(),
                                    builder:
                                        (context, AsyncSnapshot<int> data) {
                                      if (data.hasData)
                                        return Text(
                                          "${data.data.toString()} Books",
                                          style: TextStyle(
                                            color: Color(0xff353535),
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        );
                                      return Text(
                                        '0 Books',
                                        style: TextStyle(
                                          color: Color(0xff353535),
                                          fontSize: 14,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
