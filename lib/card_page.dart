import 'dart:io';

import 'package:Fast_learning/date.dart';
import 'package:Fast_learning/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_to_speech/text_to_speech.dart';

import 'controllers/cards_controller.dart';
import 'tools/tools.dart';

class CardPage extends StatefulWidget {
  final Lesson lessson;
  CardPage({Key? key, required this.lessson}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  CardsController _cardsController = Get.find<CardsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.lessson.title!,
          style: Get.theme.textTheme.headline1!,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20, left: 20),
            child: GestureDetector(
              onTap: () async {
                await Get.to(TblCardAdd(TblCard(lessonId: widget.lessson.id)));
                _cardsController.rebind();
                setState(() {});
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future:
              TblCard().select().lessonId.equals(widget.lessson.id).toList(),
          builder: (BuildContext context, AsyncSnapshot<List<TblCard>> cards) {
            if (cards.data == null) {
              return Container();
            }
            return ListView(
              children: cards.data!.map((e) {
                return Card(
                  child: ListTile(
                    leading: (e.imagePath == null || e.imagePath!.isEmpty)
                        ? SizedBox(
                            height: 80,
                            width: 80,
                          )
                        : SizedBox(
                            height: 80,
                            width: 80,
                            child: Image.file(
                              File(e.imagePath!),
                              height: 80,
                              width: 80,
                            )),
                    title: Text(e.question!),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('date_created'.tr),
                        Text(miladiToShamsiDateTimeFormat(
                            e.dateCreated.toString())),
                        Text('time_question'.tr),
                        Text(miladiToShamsiDateTimeFormat(
                            e.boxVisibleDate.toString())),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //   InkWell(
                        //     onTap: () async {
                        //     //   TextToSpeech tts = TextToSpeech();
                        //     //  var voices = await tts.getLanguages();
                        //     //   print(voices);
                        //     //   String language = 'en-US';
                        //     //   tts.setLanguage(language);
                        //     //   String text = "HELLO WORLD";
                        //     //   tts.speak(text);
                        //     //   setState(() {});
                        //  //  print((await  calcBoxForCard()).length)  ;
                        //    //  await  e.delete(true);
                        //     //  setState(() {});
                        //     },
                        //     child: Icon(Icons.remove),
                        //   ),
                        // Container(
                        //   width: 8,
                        // ),
                        InkWell(
                          onTap: () async {
                            await Get.to(TblCardAdd(e));
                            _cardsController.rebind();
                            setState(() {});
                          },
                          child: Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
