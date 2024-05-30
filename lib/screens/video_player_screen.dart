import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  String vdUrl;
   VideoPlayerScreen({required this.vdUrl}) ;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
 late VideoPlayerController _videoPlayerController;
late  ChewieController _chewieController;
  bool _isLoading = true;


 @override
 void initState() {
   super.initState();
   _initializeVideoPlayer();
 }

 Future<void> _initializeVideoPlayer() async {
   _videoPlayerController = VideoPlayerController.networkUrl(
     Uri.parse(widget.vdUrl),
   );

   await _videoPlayerController.initialize();

   setState(() {
     _chewieController = ChewieController(
       videoPlayerController: _videoPlayerController,
       aspectRatio: 16 / 9,
       autoPlay: true,
       looping: true,
       allowedScreenSleep: false,
       fullScreenByDefault: false,
     );
     _isLoading = false;
   });
 }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playing Video'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}

