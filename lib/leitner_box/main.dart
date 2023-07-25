import 'package:flutter/material.dart';
import 'package:Fast_learning/leitner_box/screens/cardReview2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: cardReview2(),
    );
  }
}
