import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatefulWidget {
  PdfViewPage({Key? key}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          SfPdfViewer.asset('assets/pdf/control.pdf'),
          Positioned(
            top:25,
            right: 25,
              child: InkWell(
                onTap: (){
                  Get.back();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.pink,
            child: Icon(Icons.cancel),
          ),
              )),
        ],
      )),
    );
  }
}
