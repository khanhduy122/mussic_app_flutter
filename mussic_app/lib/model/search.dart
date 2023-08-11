import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/mv.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/song.dart';

class Search {
  Song? topSong;
  Artist? topArtist;
  PlayList? topPlaylist;
  List<Artist>? artists;
  List<Song>? songs;
  List<MV>? videos;
  List<PlayList>? playlists;

  Search(
      {this.topSong,
      this.topArtist,
      this.topPlaylist,
      this.artists,
      this.songs,
      this.videos,
      this.playlists,
      });

  Search.fromJson(Map<String, dynamic> json) {
    if(json['top'] != null){
      if(json['top']['objectType'] == 'song'){
        topSong = json['top'] != null ?  Song.fromJson(json['top']) : null;
      }
      if(json['top']['objectType'] == 'artist'){
          topArtist = json['top'] != null ?  Artist.fromJson(json['top']) : null;
      }else{
        topPlaylist = json['top'] != null ?  PlayList.fromJson(json['top']) : null;
      }   
    }
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add( Artist.fromJson(v));
      });
    }
    if (json['songs'] != null) {
      songs = <Song>[];
      json['songs'].forEach((v) {
        songs!.add( Song.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      videos = <MV>[];
      json['videos'].forEach((v) {
        videos!.add( MV.fromJson(v));
      });
    }
    if (json['playlists'] != null) {
      playlists = <PlayList>[];
      json['playlists'].forEach((v) {
        playlists!.add( PlayList.fromJson(v));
      });
    }
  }
}
