import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/song.dart';


class HomeData{
  List<homeItem>? playlists;
  homeItem? banner;
  homeItem? newRelease;
  homeItem? newReleaseChart;
  homeItem? chartSong;
	HomeData({
    this.banner,
    this.newRelease,
    this.newReleaseChart, 
    this.playlists,
    this.chartSong
  });

	HomeData.fromJson(Map<String, dynamic> json) {
    playlists = <homeItem>[];
		json["items"].forEach((value){
      if(value['sectionType'] == 'banner'){
        banner = homeItem.fromJson(value);
      }
      if(value['sectionType'] == 'new-release'){
        newRelease = homeItem.fromJson(value);
      }
      if(value['sectionType'] == 'newReleaseChart'){
        newReleaseChart = homeItem.fromJson(value);
      }
      if(value['sectionType'] == 'playlist'){
        playlists!.add(homeItem.fromJson(value));
      }
      if(value['sectionType'] == 'RTChart'){
        chartSong = homeItem.fromJson(value);
      }
    });
	}
}

class homeItem {
  String? sectionType;
  String? title;
  String? sectionId;
  Items? itemNewRelease;
  List<Song>? listSongNewReleaseChart;
  List<Items>? items;
  List<PlayList>? listPlayList;
  List<Song>? listSongChart;
  homeItem(
      {
      this.sectionType,
      this.title,
      this.sectionId,
      this.listSongNewReleaseChart,
      this.itemNewRelease,
      this.items,
      this.listPlayList,
      this.listSongChart
  });

  homeItem.fromJson(Map<String, dynamic> json) {
    sectionType = json['sectionType'];
    title = json['title'];
    sectionId = json['sectionId'];

    if(json['items'] != null && sectionType == "RTChart"){
      listSongChart = <Song>[];
      json['items'].forEach((value){
        listSongChart!.add(Song.fromJson(value));
      });
    }

    if(json['items'] != null && sectionType == "playlist"){
      listPlayList = <PlayList>[];
      json['items'].forEach((value){
        listPlayList!.add(PlayList.fromJson(value));
      });
    }

    if(json['items'] != null && sectionType == "banner"){
      items = <Items>[];
      json['items'].forEach((value){
        items!.add(Items.fromJson(value));
      });
    }

    if(sectionType == 'new-release' && json['items'] != null){
      itemNewRelease = Items.fromJson(json['items']);
    }

    if(sectionType == 'newReleaseChart' && json['items'] != null){
      listSongNewReleaseChart = <Song>[];
      json['items'].forEach((value){
        listSongNewReleaseChart!.add(Song.fromJson(value));
      });
    }
  }
}

class Items {
  int? type;
  String? banner;
  String? cover;
  String? title;
  String? description;
  String? encodeId;
  String? thumbnail;
  List<Artist>? artists;
  String? artistsNames;
  int? uid;
  String? thumbnailM;
  String? id;
  String? thumbnailV;
  String? thumbnailH;
  String? alias;
  int? totalTopZing;
  Artist? artist;
  int? thumbType;
  List<Song>? allSongs;
  List<Song>? vpop;
  List<Song>? other;


  Items(
      {this.type,
      this.banner,
      this.cover,
      this.title,
      this.description,
      this.encodeId,
      this.thumbnail,
      this.artists,
      this.artistsNames,
      this.uid,
      this.thumbnailM,
      this.id,
      this.thumbnailV,
      this.thumbnailH,
      this.alias,
      this.totalTopZing,
      this.artist,
      this.allSongs,
      this.vpop,
      this.other,
      this.thumbType,
  });

  Items.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    cover = json['cover'];
    title = json['title'];
    description = json['description'];
    encodeId = json['encodeId'];
    thumbnail = json['thumbnail'];
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add(new Artist.fromJson(v));
      });
    }
    if(json['all'] != null){
      allSongs = <Song>[];
      json['all'].forEach((v){
        allSongs!.add(new Song.fromJson(v));
      });
    }
    if(json['vPop'] != null){
      vpop = <Song>[];
      json['vPop'].forEach((v){
        vpop!.add(new Song.fromJson(v));
      });
    }
    if(json['others'] != null){
      other = <Song>[];
      json['others'].forEach((v){
        other!.add(new Song.fromJson(v));
      });
    }
    artistsNames = json['artistsNames'];
    uid = json['uid'];
    thumbnailM = json['thumbnailM'];
    id = json['id'];
    thumbnailV = json['thumbnailV'];
    thumbnailH = json['thumbnailH'];
    alias = json['alias'];
    totalTopZing = json['totalTopZing'];
    artist =
        json['artist'] != null ? new Artist.fromJson(json['artist']) : null;
    thumbType = json['thumbType'];
    type = json["type"];
  }
}

