import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MyFullScreenImage extends StatelessWidget {
  final String imageUrl;

  const MyFullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // set background color of app bar
        iconTheme: IconThemeData(color: Colors.white), // set color of icons
        brightness: Brightness
            .dark, // set brightness of status bar and system navigation bar
        automaticallyImplyLeading: true, // show back button on app bar
        actions: [
          // add any actions here
        ],
        title: Text(''), // set empty text to remove title space
      ),
      body: Container(
        color: Colors.black, // set background color of image
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
          loadingBuilder: (context, event) =>
              Center(child: CircularProgressIndicator()),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
          initialScale: PhotoViewComputedScale.contained,
        ),
      ),
    );
  }
}
