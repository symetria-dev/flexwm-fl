
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

late VideoPlayerController _videoPlayerController;
late Future<void> _initializeVideoPlayerFuture;


Future<void> _initializeVideoPlayer(String filePath) async {
  _videoPlayerController = VideoPlayerController.file(File(filePath));
  _initializeVideoPlayerFuture = _videoPlayerController.initialize();
  _videoPlayerController.play();
}

void ShowVideoAlert(BuildContext context, String url) {
  _initializeVideoPlayer(url);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero, //this right here
          content: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      );
    },
  );
}