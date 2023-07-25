import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/screens/addNewLesson.dart';
import '../customWidgets/_appBar.dart';
import 'makeNewFlashcardDialog.dart';

class makeNewFlashcard extends StatefulWidget {
  @override
  _makeNewFlashcardState createState() => _makeNewFlashcardState();
}

class _makeNewFlashcardState extends State<makeNewFlashcard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(left: 13, right: 13, top: 15),
            child: Column(
              children: [
                app_Bar(title_text: "Lecon Quatre"),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Stack(
                    children: [
                      Container(
                        height: 48,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Color(0xff27187E),
                          unselectedLabelColor: Color(0xff8A8A8A),
                          indicator: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xff27187E), width: 5))),
                          tabs: [
                            Tab(
                                child: Text('Cards',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16))),
                            Tab(
                                child: Text('Note 1',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16))),
                            Tab(
                                child: Text('Note 2',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16))),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 0.8,
                          child: Container(
                            height: 2.5,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black26,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      cardsTab(),
                      Center(child: Text("This is Tab 2")),
                      Center(child: Text("This is Tab 3")),
                    ],
                  ),
                ),
              ],
            )),
        bottomNavigationBar: bottomBar(),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class cardsTab extends StatefulWidget {
  const cardsTab({Key? key}) : super(key: key);

  @override
  State<cardsTab> createState() => _cardsTabState();
}

class _cardsTabState extends State<cardsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
        child: DottedBorder(
          color: Color(0xff8A8A8A),
          padding: EdgeInsets.all(0),
          borderType: BorderType.RRect,
          dashPattern: [10, 4],
          radius: Radius.circular(10),
          strokeWidth: 2,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return makeNewFlashcardDialog();
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffF1F2F6),
                  borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 24, color: Color(0xff8A8A8A)),
                      SizedBox(width: 10),
                      Text(
                        "Make New Flashcard",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff8A8A8A)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
