import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/moduels/videoPlayer/events/video_player_event.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState>{

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  VideoPlayerBloc() : super(VideoPlayerState()){

    on((event, emit) async {
      if(event is VideoPlayerLoadURLEvent){
        emit(VideoPlayerState(isLoading: true));
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(event.url));
        await _videoPlayerController.initialize().then((_) {
          _chewieController = ChewieController(
            aspectRatio: 16/9,
            videoPlayerController: _videoPlayerController,
            autoPlay: true,
            customControls: const CupertinoControls(
              iconColor: Colors.white,
              backgroundColor: Colors.black,
            ),
          );
          emit(VideoPlayerState(isLoading: false, chewieController: _chewieController));
          _videoPlayerController.addListener(VideoPlayerComopleteState);
        });
      }
      if(event is VideoPlayerCompleteEvent){
        _videoPlayerController.removeListener(VideoPlayerComopleteState);
        emit(VideoPlayerState(isLoading: false, chewieController: _chewieController, isNextVideo: true));
      }
    });
  }

  void VideoPlayerComopleteState (){
    if(_videoPlayerController.value.position >= _videoPlayerController.value.duration){
      add(VideoPlayerCompleteEvent());
    }
  }

  void dispose(){
    _chewieController.dispose();
    _videoPlayerController.dispose();

  }
}


class VideoPlayerState {
  bool? isLoading;
  ChewieController? chewieController;
  bool? isNextVideo;

  VideoPlayerState({this.isLoading, this.chewieController, this.isNextVideo});
}
