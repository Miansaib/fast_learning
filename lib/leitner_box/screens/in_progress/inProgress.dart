import 'package:Fast_learning/leitner_box/customWidgets/_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../zcomponent/homepage/folder/controller/foldercontroller.dart';
import '../../../zcomponent/homepage/folder/view/allfolder.dart';
import 'in_progress_items.dart';

class InProgressScreen extends StatelessWidget {
  const InProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FolderController fc = Get.find();

    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          app_Bar(
            title_text: "In Progress",
            canGoBack: false,
          ),
          Expanded(
            child: InProgressPage(
              [],
              function: fc.getReviewStarted,
            ),
          )
        ]),
      ),
    );
  }
}
