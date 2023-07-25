import 'package:flutter/material.dart';

class CustomWidgets {
  static Widget imageNetwork(String imageUrl) {
    return Image.network(imageUrl, fit: BoxFit.fill, loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
          child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ));
    });
  }

  static Widget customListTile(BuildContext context,
      {Widget? leading, Widget? title, Widget? subtitle, Widget? trailing,bool? selected,Color? selectedTileColor}) {
    return Container(
    
      width: MediaQuery.of(context).size.width * 0.94,
      child: Card(        
        shape: RoundedRectangleBorder(          
          borderRadius: BorderRadius.circular(5),
        ),
      //  color:  ( selected == true ) ? selectedTileColor! : Colors.white,
       // elevation: 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(5.0), child: leading
                // child: ConstrainedBox(
                //   constraints: BoxConstraints(
                //     maxWidth: MediaQuery.of(context).size.width * 0.28,
                //     maxHeight: MediaQuery.of(context).size.width * 0.28,
                //   ),
                //   child: Image.asset(
                //       'lib/images/burger_texas_angus.jpg',
                //       fit: BoxFit.fill
                //   ),
                // ),
                ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: title
                      // child: Text(
                      //   'Texas Angus Burger',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18,
                      //   ),
                      // ),
                      ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                    child: subtitle,
                  ),
                ),
              ],
            ),
            Container(
              child: trailing,
            )
            // Column(
            //   children: <Widget>[
            //     Padding(
            //       padding: const EdgeInsets.fromLTRB(5, 40, 0, 0),
            //       child: Text(
            //         '\$ 24.00',
            //         style: TextStyle(
            //           fontSize: 14,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
