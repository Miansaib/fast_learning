import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomProgressiveIndicator extends StatefulWidget {
  final StreamController<double> indicatorValueController;
  CustomProgressiveIndicator({Key? key, required this.indicatorValueController})
      : super(key: key);

  @override
  _CustomProgressiveIndicatorState createState() =>
      _CustomProgressiveIndicatorState();
}

class _CustomProgressiveIndicatorState
    extends State<CustomProgressiveIndicator> {
      @override
  void dispose() {
   //widget.indicatorValueController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
  
      child: StreamBuilder(
        stream: widget.indicatorValueController.stream,
        initialData: 0.0,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if( snapshot.data == 1.0){
           Get.back();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  value: snapshot.data,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('progress : '),
                  Text((snapshot.data!*100).round().toString()),
                  Text(' % '),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
