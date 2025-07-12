// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class VideoPlayerWidget extends StatefulWidget {
//   final List<String> videoIds;
//   final int startIndex;
//   final bool isAutoPlayAllowed;
//   const VideoPlayerWidget(
//       {super.key,
//       required this.videoIds,
//       required this.startIndex,
//       required this.isAutoPlayAllowed});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late YoutubePlayerController _controller;
//   late int currentIndex;
//     bool isFirstVideo = true;

//   @override
//   void initState() {
//     super.initState();
//     currentIndex = widget.startIndex;
//     _initController(widget.videoIds[currentIndex]);
//   }

//   void _initController(String videoId) {
//      final shouldAutoPlay = widget.isAutoPlayAllowed || isFirstVideo;
//     _controller = YoutubePlayerController(
//       initialVideoId: videoId,
//       flags: YoutubePlayerFlags(
//         autoPlay:shouldAutoPlay,
//         mute: false,
//         disableDragSeek: true,
//         enableCaption: false,
//         controlsVisibleAtStart: true,
//         forceHD: true,
//       ),
//     )..addListener(_videoListener);
//   }

//   void _videoListener() {
//     if (_controller.value.playerState == PlayerState.ended) {
//       if (currentIndex < widget.videoIds.length - 1) {
//         setState(() {
//           currentIndex++;
//           if (widget.isAutoPlayAllowed) {
//             _controller.load(widget.videoIds[currentIndex]);
//           } else {
//             _controller.cue(widget.videoIds[currentIndex]);
//           }
//         });
//       } else {
//         // Optional: Handle what happens when the last video ends
//         // For example, you could loop back to the first video:
//         // setState(() {
//         //   currentIndex = 0;
//         //   _controller.load(widget.videoIds[currentIndex]);
//         // });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(_videoListener);
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       player: YoutubePlayer(controller: _controller),
//       builder: (context, player) {
//         return Scaffold(
//           backgroundColor: Colors.black,
//           body: Center(child: player),
//         );
//       },
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../blocs/send_kids_activities_cubit/send_kids_activities_cubit.dart'
    show SendKidsActivitiesCubit;
import '../models/show_videos_model.dart';

class VideoPlayerWidget extends StatefulWidget {
  final List<String> videoIds;
  final Videos videoModel;
  final int startIndex;
  final bool isAutoPlayAllowed;
  final String childDeviceId;
  const VideoPlayerWidget(
      {super.key,
      required this.videoIds,
      required this.startIndex,
      required this.isAutoPlayAllowed,
      required this.videoModel,
      required this.childDeviceId});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;
  late int currentIndex;
  late SendKidsActivitiesCubit sendKidsActivitiesCubit;
  bool isFirstVideo = true;
  DateTime? startTime;
  DateTime? endTime;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.startIndex;
    _initController(widget.videoIds[currentIndex]);
    startTime = DateTime.now();
    sendKidsActivitiesCubit = BlocProvider.of<SendKidsActivitiesCubit>(context);
  }

  void _initController(String videoId) {
    final shouldAutoPlay = widget.isAutoPlayAllowed || isFirstVideo;

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: shouldAutoPlay,
        mute: false,
        disableDragSeek: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
        forceHD: true,
        hideControls: false,
      ),
    )..addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.playerState == PlayerState.ended) {
      if (currentIndex < widget.videoIds.length - 1) {
        setState(() {
          currentIndex++;
          if (widget.isAutoPlayAllowed) {
            _controller.load(widget.videoIds[currentIndex]);
          } else {
            _controller.cue(widget.videoIds[currentIndex]);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    endTime = DateTime.now();

    if (startTime != null && endTime != null) {
      final watchedDuration = endTime!.difference(startTime!).inSeconds;
      log("Sending data to API: Duration = $watchedDuration seconds");
      sendKidsActivitiesCubit.sendKidsActivities(
        childDeviceId: widget.childDeviceId,
        videoId: widget.videoIds[currentIndex],
        title: widget.videoModel.title.toString(),
        thumbnail: widget.videoModel.thumbnail.toString(),
        channelName: widget.videoModel.channel.toString(),
        duration: watchedDuration,
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          aspectRatio: 16 / 9,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          progressColors: ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
            bufferedColor: Colors.grey,
            backgroundColor: Colors.grey.withOpacity(0.2),
          ),
          onReady: () {
            _controller.updateValue(_controller.value.copyWith(
              isControlsVisible: true,
            ));
          },
          bottomActions: const [
            CurrentPosition(),
            ProgressBar(isExpanded: true),
            RemainingDuration(),
            FullScreenButton(),
          ],
        ),
      ),
    );
  }
}
