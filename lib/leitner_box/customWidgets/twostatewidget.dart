import 'package:flutter/material.dart';

typedef MyAsyncFunction = Future<void> Function(bool);

class TwoStateWidget extends StatefulWidget {
  final String playingImage;
  final String stoppedImage;
  final MyAsyncFunction onEnable;
  final MyAsyncFunction onDisable;

  TwoStateWidget({
    required this.playingImage,
    required this.stoppedImage,
    required this.onEnable,
    required this.onDisable,
    Key? key,
  }) : super(key: key);

  @override
  _TwoStateWidgetState createState() => _TwoStateWidgetState();
}

class _TwoStateWidgetState extends State<TwoStateWidget> {
  bool _isPlaying = false;

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        _togglePlay();
        if (_isPlaying) {
          widget.onEnable(_isPlaying);
        } else {
          widget.onDisable(_isPlaying);
        }
      },
      child: Image.asset(
        !_isPlaying ? widget.playingImage : widget.stoppedImage,
        fit: BoxFit.cover,
        width: 24,
        height: 24,
      ),
    );
  }
}
