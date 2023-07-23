
import 'package:mussic_app/model/song.dart';

abstract class DowloadEvent{}

class DowloadSongEvent extends DowloadEvent{
  Song song;
  DowloadSongEvent({required this.song});
}

class DowloadAllSong extends DowloadEvent{
  List<Song> listSong;

  DowloadAllSong({required this.listSong});
}

class DeleteSongDownloadEvent extends DowloadEvent{
  Song song;
  DeleteSongDownloadEvent({required this.song});
}

class getIsDownLoad extends DowloadEvent {
  Song song;
  getIsDownLoad({required this.song});
}
