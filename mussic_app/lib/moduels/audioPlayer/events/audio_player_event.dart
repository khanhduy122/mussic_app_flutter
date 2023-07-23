
import 'package:mussic_app/model/song.dart';

abstract class audioPlayerEvent {}

class audioPlayerSetMp3 extends audioPlayerEvent{
  final Song song;
  final bool isGetSongPlayed;

  audioPlayerSetMp3({required this.isGetSongPlayed, required this.song, });
}

class audioPlayerEventLoadURL extends audioPlayerEvent{
  final Song song;
  final bool isGetSongPlayed;
  audioPlayerEventLoadURL({required this.isGetSongPlayed, required this.song});
}

class audioPlayerLoadAsset extends audioPlayerEvent{
  final Song song;
  final bool isGetSongPlayed;

  audioPlayerLoadAsset({required this.song, required this.isGetSongPlayed});
}

class audioPlayerEventPlayPause extends audioPlayerEvent {
  final bool? isShuffle;
  final bool? isRepeate;

  audioPlayerEventPlayPause({this.isRepeate, this.isShuffle});
}

class audioPlayerEventSeekPosition extends audioPlayerEvent{
  final Duration duration;

  audioPlayerEventSeekPosition({required this.duration});
}

class audioPlayerEventUploadPosition extends audioPlayerEvent{
  final Duration currentPosition;

  audioPlayerEventUploadPosition({required this.currentPosition});
}

class audioPlayerEventShuffle extends audioPlayerEvent {
  bool isShuffle;

  audioPlayerEventShuffle({required this.isShuffle});
}

class audioPlayerEventRepeate extends audioPlayerEvent {
  bool isRepeate;

  audioPlayerEventRepeate({required this.isRepeate});
}

class audioPlayerEventHeart extends audioPlayerEvent {
  bool isHeart;

  audioPlayerEventHeart({required this.isHeart});
}

class audioPlayerEventCompleted extends audioPlayerEvent{
  bool isListMussic;

  audioPlayerEventCompleted({required this.isListMussic});
}

class audioPlayerEventNextMussic extends audioPlayerEvent{}

class audioPlayerEventBackMussic extends audioPlayerEvent{}



