
abstract class VideoPlayerEvent{}

class VideoPlayerLoadURLEvent extends VideoPlayerEvent{
  String url;

  VideoPlayerLoadURLEvent({required this.url});
}

class VideoPlayerCompleteEvent extends VideoPlayerEvent{}