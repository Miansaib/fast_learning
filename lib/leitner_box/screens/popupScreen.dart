import 'package:Fast_learning/controllers/download_controller.dart';
import 'package:Fast_learning/pages/childs/downloads_page/download_view.dart';
import 'package:Fast_learning/tools/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTabbedPopup extends StatefulWidget {
  @override
  State<MyTabbedPopup> createState() => _MyTabbedPopupState();
}

class _MyTabbedPopupState extends State<MyTabbedPopup>
    with SingleTickerProviderStateMixin {
  DownloadController dc = Get.find();
  late TabController _tabController;
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: dc.filterdBooks.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Do something when the tab selection is changing
      // print('Tab ${_tabController.index} is being selected');
    } else {
      // Do something when the tab selection is finished
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: (() => Get.back()),
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: _isMaximized ? Get.width : Get.width * 90 / 100,
              height: _isMaximized ? Get.height : 650,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: dc.filterdBooks.length == 0
                              ? Center(
                                  child: Text(
                                    "No new books to display!",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      child: DefaultTabController(
                                        length: dc.filterdBooks.length,
                                        child: TabBarView(
                                            controller: _tabController,
                                            children: [
                                              for (var book in dc.filterdBooks)
                                                Column(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          MyOwnTabViewDownload(
                                                              book: book,
                                                              fillImage: true),
                                                    ),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Row(
                                                          //   mainAxisAlignment:
                                                          //       MainAxisAlignment
                                                          //           .spaceBetween,
                                                          //   children: [
                                                          //     Text(
                                                          //       "${book.title}",
                                                          //       style: TextStyle(
                                                          //           fontSize:
                                                          //               16,
                                                          //           fontWeight:
                                                          //               FontWeight
                                                          //                   .bold),
                                                          //     ),

                                                          //   ],
                                                          // ),
                                                          // Text(
                                                          //     book.description
                                                          //         .toString(),
                                                          //     style: TextStyle(
                                                          //         fontFamily:
                                                          //             "Poppins",
                                                          //         fontSize:
                                                          //             14,
                                                          //         fontWeight:
                                                          //             FontWeight
                                                          //                 .w500)),
                                                        ])
                                                  ],
                                                ),
                                            ]),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            right: 30,
                                            left: 30.0,
                                            bottom: 8),
                                        child: Flex(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          direction: Axis.horizontal,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: buttonWithBorder(
                                                  "Prev Item", () {
                                                if (_tabController.index > 0)
                                                  _tabController.animateTo(
                                                      _tabController.index - 1);
                                              },
                                                  height: 40,
                                                  // width: 100,
                                                  color:
                                                      Get.theme.primaryColor),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Obx(
                                                () => Text(
                                                  "${(_tabController.index + 1).toString()}/${dc.filterdBooks.length.toString()}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: buttonWithBorder(
                                                  "Next Item", () {
                                                if (_tabController.index + 1 <
                                                    dc.filterdBooks.length)
                                                  _tabController.animateTo(
                                                      _tabController.index + 1);
                                              },
                                                  height: 40,
                                                  // width: 100,
                                                  color:
                                                      Get.theme.primaryColor),
                                            ),
                                            if (!dc
                                                .filterdBooks[
                                                    _tabController.index]
                                                .isNews)
                                              Flexible(
                                                flex: 3,
                                                child: buttonWithBorder(
                                                    "Download", () async {
                                                  await myOwnDownloadDialog(dc
                                                          .filterdBooks[
                                                      _tabController.index]);
                                                },
                                                    height: 40,
                                                    width: 80,
                                                    color:
                                                        Get.theme.primaryColor),
                                                // IconButton(
                                                //   onPressed: () {
                                                //     myOwnDownloadDialog(dc
                                                //             .filterdBooks[
                                                //         _tabController.index]);
                                                //   },
                                                //   icon: Icon(
                                                //       Icons.download_rounded),
                                                // ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(0, 0, 0, 0),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(41, 227, 227, 227)
                              .withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "New Books",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isMaximized = !_isMaximized;
                                    });
                                  },
                                  icon: Icon(_isMaximized
                                      ? Icons.fullscreen_exit_outlined
                                      : Icons.fullscreen),
                                  tooltip: 'Full Screen',
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: 'Confirmation',
                                      content: Text(
                                          'Do you want to dismiss popup until next update?'),
                                      textConfirm: 'Keep Showing',
                                      textCancel: 'Dismiss',
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        // Handle confirm button tap
                                        Get.back();
                                        Get.back();
                                        // Perform the delete operation or show another
                                        // popup confiming deletion and then perform the delete operation.
                                      },
                                      onCancel: () {
                                        Get.back();
                                        dc.notifVersion = dc.findMax();
                                        dc.notifLastTime = DateTime.now();
                                        dc.filterNew();
                                        Get.back();
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.close_rounded),
                                  tooltip: 'Close Window',
                                )
                              ],
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buttonWithBorder(
  String label,
  VoidCallback onTap, {
  double? height,
  double? width,
  Color? color,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text(label)),
    ),
  );
}
