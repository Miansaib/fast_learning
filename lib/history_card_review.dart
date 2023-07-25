import 'package:Fast_learning/model/model.dart';
import 'package:flutter/material.dart';
import 'music.dart';
import 'tools/extension.dart';

class HistoryCardWidget extends StatefulWidget {
  final TblCard? card;
  HistoryCardWidget({Key? key, this.card}) : super(key: key);

  @override
  _HistoryCardWidgetState createState() => _HistoryCardWidgetState();
}

class _HistoryCardWidgetState extends State<HistoryCardWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Container(
        // margin: EdgeInsets.only(
        //     top: size.height / 4, bottom: size.height / 4, right: 5, left: 5),
        // color: Colors.yellow,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: Tablehistory()
                  .select()
                  .tblCardId
                  .equals(widget.card!.id)
                  .toList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Tablehistory>> snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                List<String> pathes = snapshot.data!.map((t) {
                  return t.replyVoicePath!;
                }).toList();
                if (pathes.length == 0) {
                  return Container(
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    child: Text(
                      'Empty History',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  );
                }
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 100.0),
                  // margin:EdgeInsets.only(bottom: 50),
                  // color:Colors.red,
                  // height: 100,
                  child: ControlButtonsOld(
                    pathes: pathes,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
