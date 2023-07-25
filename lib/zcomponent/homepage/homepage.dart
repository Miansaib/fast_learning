import 'dart:io';

import 'package:Fast_learning/controllers/download_controller.dart';
import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:Fast_learning/zcomponent/common_widget/dottedbtn.dart';
import 'package:Fast_learning/zcomponent/homepage/folder/controller/foldercontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import './folder/view/allfolder.dart';
import '../../controllers/inapp_purchase_controller.dart';
import '../../model/model.dart';
import '../../pages/buy_subscription/buy_subscription_page.dart';
import '../../tools/export/subgroup_page.dart';
import '../common_widget/searchbar.dart';
import 'folder/view/allfolder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return
        // Figma Flutter Generator AddfoldermainpageWidget - COMPONENT
        SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            app_Bar(
              title_text: 'My Folders',
              canGoBack: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 8.0),
                        child: Column(
                          children: [
                            topappbar_icon_notif(),
                            SearchBarWidget(),
                            // search_widget(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    library_generator(),
                    myfolder_generator()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myfolder_generator() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Folders",
                style: TextStyle(
                  color: Color(0xff353535),
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Get.to(() => MyFolders());
                  refreshPage();
                },
                child: Container(
                  width: 74,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color(0xfff1f2f6),
                      width: 1,
                    ),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(
                    left: 11,
                    right: 14,
                    top: 10,
                    bottom: 9,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "See All",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff27187e),
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: createfolderdottedbtn(
                    "Add",
                    hint: 'Add a new folder',
                    image: Icon(Icons.add),
                    width: 130,
                    height: 200,
                    onTap: () async {
                      InAppPurchaseController inappc = Get.find();

                      if (!inappc.isPremium) {
                        Get.to(() => BuySubscriptionPage());
                      } else {
                        // var x = await .getById(2);
                        await Get.defaultDialog(
                          content: RootGroupAdd(RootGroup()),
                        );
                        setState(() {
                          print('rebuild now');
                        });
                      }
                    },
                  )),
              Expanded(child: folder_item_generator())
            ],
          ),
        )
      ],
    );
  }

  // Widget createfolderdottedbtn() {
  //   return DottedBorder(
  //     borderType: BorderType.RRect,
  //     radius: Radius.circular(12),
  //     color: Colors.black,
  //     strokeWidth: 1,
  //     dashPattern: [8, 4],
  //     child: Container(
  //       width: 130,
  //       height: 180,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Color(0x14000000),
  //             blurRadius: 40,
  //             offset: Offset(0, 10),
  //           ),
  //         ],
  //         color: Colors.white,
  //       ),
  //       // padding: const EdgeInsets.only(
  //       //   left: 8,
  //       //   right: 40,
  //       //   top: 125,
  //       //   bottom: 5,
  //       // ),
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: Center(
  //               child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [Icon(Icons.add), Text("Add Folder")]),
  //             ),
  //           ),
  //           Row(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               Container(
  //                 width: 82,
  //                 height: 50,
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "for making flashcards first you need to make a new folder...",
  //                       style: TextStyle(
  //                         color: Color(0xff8a8a8a),
  //                         fontSize: 10,
  //                         fontFamily: "Poppins",
  //                         fontWeight: FontWeight.w300,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Column library_generator() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Library",
                style: TextStyle(
                  color: Color(0xff353535),
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                width: 74,
                height: 42,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 74,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color(0xfff1f2f6),
                          width: 1,
                        ),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(
                        left: 11,
                        right: 14,
                        top: 10,
                        bottom: 9,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "See All",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff27187e),
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: library_item_generator(),
        )
      ],
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
              return Container(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (!inappc.isPremium) {
                          Get.to(BuySubscriptionPage());
                        } else {
                          await Get.to(SubgroupPage(
                            rootGroup: groups.data![index],
                            refreshParentPageFunc: refreshPage,
                          ));
                        }
                        refreshPage();
                      },
                      child: Column(
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

  ListView library_item_generator() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 130,
              height: 180,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 40,
                          offset: Offset(0, 10),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    // padding: const EdgeInsets.only(
                    //   left: 8,
                    //   right: 40,
                    //   top: 125,
                    //   bottom: 5,
                    // ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'assets/images/icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: 82,
                          height: 50,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Language",
                                style: TextStyle(
                                  color: Color(0xff353535),
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "3 Books",
                                style: TextStyle(
                                  color: Color(0xff353535),
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Container search_widget() {
    return Container(
      width: 358,
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.search,
                          size: 24,
                        )),
                  ],
                ),
              ),
              SizedBox(width: 13),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: Color(0xff353535),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget topappbar_icon_notif() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Card(
                child: Icon(
                  Icons.emoji_people_rounded,
                  size: 46,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi Jacob!",
                    style: TextStyle(
                      color: Color(0xff353535),
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Token Code",
                    style: TextStyle(
                      color: Color(0xff27187e),
                      fontSize: 9,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Color(0xfff1f2f6),
                width: 1,
              ),
              color: Colors.white,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.notifications),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
