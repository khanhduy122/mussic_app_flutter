import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/mv.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/song.dart';

class UserProfile{
  String? userID;
  String? avatar;
  String? numberPhone;
  String? name;
  String? token;
  List<Song>? resendSongs;
  List<PlayList>? recentPlaylists;
  List<Artist>? recentArtists;
  List<MV>? recentVideo;
  List<Artist>? followArtists;
  List<Song>? likeSongs;
  List<PlayList>? likePlaylists;
  List<MV>? likeVideo;
  List<PlayList>? userPlaylist;

  UserProfile({
    this.userID,
    this.avatar,
    this.name,
    this.token,
    this.numberPhone,
    this.resendSongs, 
    this.recentPlaylists,
    this.recentVideo,
    this.followArtists,
    this.likePlaylists,
    this.likeSongs,
    this.likeVideo,
    this.recentArtists,
    this.userPlaylist
  });

  UserProfile.formJson(Map<String, dynamic> json){
    userID = json["userID"];
    avatar = json["avatar"];
    name = json["name"];
    token = json["token"];
  }

   Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data["userID"] = userID;
    data["avatar"] = avatar;
    data["name"] = name;
    data["token"] = token;
    return data;
   }
}