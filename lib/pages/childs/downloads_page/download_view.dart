import 'dart:convert';

import 'package:Fast_learning/controllers/cards_controller.dart';
import 'package:Fast_learning/controllers/download_controller.dart';
import 'package:Fast_learning/controllers/inapp_purchase_controller.dart';
import 'package:Fast_learning/controllers/theme_controller.dart';
import 'package:Fast_learning/leitner_box/screens/popupScreen.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:Fast_learning/pages/buy_subscription/buy_subscription_page.dart';
import 'package:Fast_learning/pages/childs/downloads_page/image_view.dart';
import 'package:Fast_learning/pages/childs/downloads_page/video_player.dart';
import 'package:Fast_learning/tools/download_dialog.dart';
import 'package:Fast_learning/zcomponent/common_widget/hintdialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadsView extends StatelessWidget {
  DownloadsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DownloadController dc = Get.find();
    dc.getall(showpopup: false);
    if (dc.books.isEmpty) {}
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh_rounded),
          onPressed: () {
            dc.getall(showpopup: false);
          },
        ),
        appBar: AppBar(
          title: Text("Downloads"),
        ),
        body: Obx(() {
          if (dc.books.isEmpty)
            return Align(
                alignment: Alignment.center,
                child: Center(child: CircularProgressIndicator()));
          else
            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GetBuilder<DownloadController>(builder: (tx) {
                        ThemeContoller themeController = Get.find();
                        return Row(
                            children: dc.categories.map(
                          (category) {
                            Categories _category = category;
                            return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onLongPress: () {
                                    Get.bottomSheet(
                                      myBottomSheetWidget(category.title,
                                          category.description, null),
                                      isScrollControlled: true,
                                    );
                                  },
                                  child: FilterChip(
                                      // avatar: Image.network(category.image),
                                      selectedColor: themeController
                                          .currentTheme
                                          .value
                                          .theme!
                                          .primaryColor,
                                      // avatar: CircleAvatar(
                                      //     child: Text(_category.name ??
                                      //         // _category.id?.toString() ??
                                      //         "Various Category")),
                                      label: Text(
                                        _category.title ??
                                            // _category.id?.toString() ??
                                            "Various Category",
                                      ),
                                      selected: dc.filters
                                          .contains(_category.id ?? 0),
                                      onSelected: (bool value) {
                                        if (value) {
                                          dc.filters.add(_category.id ?? 0);
                                        } else {
                                          dc.filters.removeWhere((int id) {
                                            return id == _category.id;
                                          });
                                        }
                                        tx.update();
                                        // dc.filters.length
                                      }),
                                ));
                          },
                        ).toList());
                      })
                    ],
                  ),
                ),
                Expanded(
                  child: GetBuilder<DownloadController>(builder: (tx) {
                    final _books = [];
                    for (var item in tx.booksWithoutNews) {
                      Books book = item;
                      if (dc.filters.contains(book.category ?? -1)) {
                        Categories? catgo = dc.categories.firstWhere((cat) {
                          Categories? cc = cat;
                          if (cc != null) return cc.id == book.category;
                          return false;
                        });
                        _books.add(Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      spreadRadius: 1)
                                ]),
                            child: Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 200,
                                    child: MyOwnTabViewDownload(book: book)),
                                ListTile(
                                  title: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: hintDialog(
                                                book.title, book.description)),
                                        Text('${book.title} - ${catgo.title}'),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${book.description}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: buttonWithBorder("Download",
                                      () async {
                                    await myOwnDownloadDialog(book);
                                  },
                                      height: 40,
                                      width: 80,
                                      color: Get.theme.primaryColor),
                                  //  IconButton(
                                  //     icon: Icon(Icons.download_rounded),
                                  //     onPressed: () async {}),
                                ),
                              ],
                            ),
                          ),
                        ));
                      }
                    }
                    return ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        return _books[index];
                      },
                    );
                  }),
                )
              ],
            );
        }));
  }
}

class MyOwnTabViewDownload extends StatefulWidget {
  const MyOwnTabViewDownload({
    Key? key,
    required this.book,
    this.fillImage = false,
  }) : super(key: key);

  final Books book;
  final bool fillImage;

  @override
  State<MyOwnTabViewDownload> createState() => _MyOwnTabViewDownloadState();
}

class _MyOwnTabViewDownloadState extends State<MyOwnTabViewDownload>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.book.images.length, vsync: this);
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
    return Stack(
      children: [
        Center(
          child: TabBarView(
            controller: _tabController,
            children: [
              for (var item in widget.book.images)
                if (item.isVideo)
                  getVideoPlayer(item)
                else
                  InkWell(
                    child: Image.network(item.image,
                        fit: widget.fillImage ? BoxFit.fill : BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
                    onTap: () {
                      Get.to(() => MyFullScreenImage(imageUrl: item.image));
                    },
                  ),
            ],
          ),
        ),
        if (widget.book.images.isNotEmpty)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "${(_tabController.index + 1).toString()}/${widget.book.images.length}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
      ],
    );
  }

  getVideoPlayer(ImageData image) {
    String? videoId;
    RegExp regExp = new RegExp(
        // r"(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))([\w-]{11})");
        r"^https?:\/\/(?:www\.)?youtube.com\/(?:watch\?v=|embed\/|v\/|shorts\/)([a-zA-Z0-9_-]+)(?:\S+)?$");
    Match? match = regExp.firstMatch(image.videoLink);
    if (match != null) {
      videoId = match.group(1)!;
      return MyOwnVideoPlayer(videoId);
    }
    return LocalVideoPlayer(image.videoLink);
  }
}

Future<void> myOwnDownloadDialog(Books book) async {
  final dropdownMenuItems =
      await RootGroup().select().toDropDownMenuInt('title');
  // Choose RootGroup
  var rootGroups = await getRootGroupsByRootId();
  RootGroup? rootGroup = await Get.defaultDialog(
      title: "Where to Download?",
      content: Container(
        height: Get.width * .7,
        child: Scaffold(
          floatingActionButton: DottedBorder(
            borderType: BorderType.RRect,
            dashPattern: [10, 4],
            strokeWidth: 2,
            padding: EdgeInsets.all(0),
            radius: Radius.circular(10),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // border: Border.all(color: Color(0xff27187E), width: 1.5, style: BorderStyle.)
                ),
                width: Get.size.width - 100,
                height: 50,
                child: FloatingActionButton(
                  onPressed: () async {
                    InAppPurchaseController inappc = Get.find();

                    if (!inappc.isPremium) {
                      Get.to(() => BuySubscriptionPage());
                    } else {
                      // var x = await .getById(2);
                      RootGroup? rootGroup = await createRootGroup();
                      Get.back(result: rootGroup);
                    }
                  },
                  backgroundColor: Color(0xffF1F2F6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Color(0xff8A8A8A), size: 24),
                      SizedBox(width: 5),
                      Text(
                        "Make New Folder",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff8A8A8A)),
                      ),
                    ],
                  ),
                )),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: ListView(
            padding: const EdgeInsets.only(bottom: 80.0),
            children: rootGroups.map((item) {
              final rg = item;
              return Container(
                child: Card(
                    child: ListTile(
                  title: Text(
                    rg.title ?? "No Title",
                  ),
                  onTap: () => Get.back(result: rg),
                )),
              );
            }).toList(),
          ),
        ),
      ));
  SubGroup? subGroup;
  //  Choose SubGroup
  if (rootGroup != null && 12 == 21) {
    var subGroups = await getSubGroupsByRootId(rootGroup.id!);
    SubGroup? subGroup = await Get.defaultDialog(
        title: "Choose Book",
        textConfirm: "Create Book",
        //  Create RootGroup not choose
        onConfirm: () async {
          SubGroup? subGroup = await createSubGroup(rootGroup);
          Get.back(result: subGroup);
        },
        content: Expanded(
            child: Scaffold(
          body: ListView.builder(
            itemCount: subGroups.length,
            itemBuilder: (context, index) {
              final sg = subGroups[index];
              return Card(
                  child: ListTile(
                title: Text(
                  sg.title ?? "No Title",
                ),
                onTap: () => Get.back(result: sg),
              ));
            },
          ),
        )));
  }
  // print(book!.link);
  //  Download
  if (rootGroup != null) {
    await download_dialog(
      showUrlSection: false,
      onPressed: () async {
        CardsController _cardsController = Get.find();
        await _cardsController.download_books(
          rootGroup,
          subgroup: subGroup,
          url: book.file,
        );
      },
      onPressedUseLastDownload: () {
        CardsController _cardsController = Get.find();
        _cardsController.download_books(RootGroup(),
            subgroup: subGroup, useLastDownload: true);
      },
    );
  }
}

Future<RootGroup?> createRootGroup() async {
  String _value = '';

  return await Get.defaultDialog(
      title: "Create Folder",
      textConfirm: "Create",
      confirmTextColor: Colors.white,
      content: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: TextFormField(
                enabled: true,
                autocorrect: false,
                enableSuggestions: false,
                autofocus: false,
                onChanged: (value) {
                  _value = value;
                },
                keyboardType: TextInputType.text,
                maxLines: 2,
                minLines: 1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Folder\'s Name'),
              ),
            )
          ])),
      onConfirm: () async {
        final rg = RootGroup(
          title: _value,
          imagePath: '',
        );
        await rg.save();
        Get.back(result: rg);
      });
}

Future<SubGroup?> createSubGroup(RootGroup rg) async {
  String _value = '';

  return await Get.defaultDialog(
      title: "Create Book",
      textConfirm: "Create",
      content: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: TextFormField(
                enabled: true,
                autocorrect: false,
                enableSuggestions: false,
                autofocus: false,
                onChanged: (value) {
                  _value = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                minLines: 1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Book\'s Name'),
              ),
            )
          ])),
      onConfirm: () async {
        final sg = SubGroup();
        var txtOrderIndex =
            sg.orderIndex == null ? '' : sg.orderIndex.toString();
        var txtTitle = sg.title == null ? '' : sg.title.toString();
        var txtRatio = sg.ratio == null ? '' : sg.ratio.toString();

        var txtPassword = sg.password == null ? '' : sg.password.toString();
        var txtCaseType = sg.caseType == null ? '' : sg.caseType.toString();
        var txtCountTime = sg.countTime == null ? '' : sg.countTime.toString();
        var txtUnitTime = sg.unitTime == null ? '' : sg.unitTime.toString();
        var txtBoxCount = sg.boxCount == null ? '' : sg.boxCount.toString();
        var txtLanguageItemOne =
            sg.languageItemOne == null ? '' : sg.languageItemOne.toString();
        var txtLanguageItemTwo =
            sg.languageItemTwo == null ? '' : sg.languageItemTwo.toString();
        var txtLanguageItemThree =
            sg.languageItemThree == null ? '' : sg.languageItemThree.toString();
        var txtImagePath = sg.imagePath == null ? '' : sg.imagePath.toString();

        sg
          ..title = _value
          ..ratio = double.tryParse(txtRatio)
          ..caseType = int.tryParse(txtCaseType)
          ..countTime = int.tryParse(txtCountTime)
          ..unitTime = int.tryParse(txtUnitTime)
          ..boxCount = int.tryParse(txtBoxCount)
          ..password = (sg.id == null && txtPassword.isNotEmpty)
              ? utf8.encode(txtPassword).toString()
              : txtPassword
          ..orderIndex =
              (txtOrderIndex.isNotEmpty) ? int.parse(txtOrderIndex) : 0
          ..languageItemOne = int.tryParse(txtLanguageItemOne)
          ..languageItemTwo = int.tryParse(txtLanguageItemTwo)
          ..languageItemThree = int.tryParse(txtLanguageItemThree)
          ..rootGroupId = rg.id
          ..imagePath = '';
        if (sg.id == null && sg.password != null && sg.password!.isNotEmpty) {
          sg.passwordConfirmed = true;
        }
        await sg.save();
        Get.back(result: sg);
      });
}

Future<List<SubGroup>> getSubGroupsByRootId(int rootId,
    {bool preload = true, bool loadParents = true}) async {
// await RootGroup().select().delete();
  var subGroups = await SubGroup()
      .select()
      .rootGroupId
      .equals(rootId)
      .orderBy('orderIndex')
      .toList(preload: preload, loadParents: loadParents);
  //     .toList(preloadFields: [
  //   'id,title,ratio,caseType,countTime,unitTime,languageItemOne,languageItemTwo,languageItemThree,rootGroupId,imagePath'
  // ]);
  if (subGroups.length == 0) {
    return [];
  }
  return subGroups;
}

Future<List<RootGroup>> getRootGroupsByRootId(
    {bool preload = true, bool loadParents = true}) async {
  var rootGroup = await RootGroup()
      .select()
      .orderBy('id')
      .toList(preload: preload, loadParents: loadParents);
  //     .toList(preloadFields: [
  //   'id,title,ratio,caseType,countTime,unitTime,languageItemOne,languageItemTwo,languageItemThree,rootGroupId,imagePath'
  // ]);
  if (rootGroup.length == 0) {
    return [];
  }
  return rootGroup;
}
