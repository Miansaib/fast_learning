import 'package:Fast_learning/controllers/download_controller.dart';
import 'package:Fast_learning/pages/childs/downloads_page/download_view.dart';
import 'package:Fast_learning/tools/extension.dart';
import 'package:Fast_learning/zcomponent/common_widget/hintdialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SinglePopScreen extends StatefulWidget {
  final Books book;
  SinglePopScreen(this.book);
  @override
  State<SinglePopScreen> createState() => _SinglePopScreenState();
}

class _SinglePopScreenState extends State<SinglePopScreen>
    with SingleTickerProviderStateMixin {
  DownloadController dc = Get.find();
  bool _isMaximized = false;

  @override
  Widget build(BuildContext context) {
    Categories? catgo = dc.categories.firstWhere((cat) {
      Categories? cc = cat;
      if (cc != null) return cc.id == widget.book.category;
      return false;
    });
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
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: MyOwnTabViewDownload(
                                                  book: widget.book,
                                                  fillImage: true),
                                            ),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: hintDialog(
                                                        widget.book.title,
                                                        widget
                                                            .book.description)),
                                                Text(
                                                    '${widget.book.title} - ${catgo.title}'),
                                              ],
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${widget.book.description}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: !widget.book.isNews
                                              ? buttonWithBorder("Download",
                                                  () async {
                                                  await myOwnDownloadDialog(
                                                      widget.book);
                                                },
                                                  height: 40,
                                                  width: 80,
                                                  color: Get.theme.primaryColor)
                                              // IconButton(
                                              //     icon: Icon(Icons
                                              //         .download_rounded),
                                              //     onPressed: () async {
                                              //       await myOwnDownloadDialog(
                                              //           widget.book);
                                              //     })
                                              : null,
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
                                    Get.back();
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
}
