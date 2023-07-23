import 'package:mussic_app/model/mv.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/song.dart';

class Artist {
  String? id;
  String? name;
  String? alias;
  String? thumbnail;
  String? biography;
  String? sortBiography;
  String? thumbnailM;
  String? national;
  String? birthday;
  String? realname;
  int? totalFollow;
  int? follow;
  List<Sections>? sections;
  Sections? sectionSong;
  Sections? sectionMV;
  List<Sections>? listSectionPlayList;
  Sections? sectionArtist;
  String? timestamp;

  Artist(
      {this.id,
      this.name,
      this.alias,
      this.thumbnail,
      this.biography,
      this.sortBiography,
      this.thumbnailM,
      this.national,
      this.birthday,
      this.realname,
      this.totalFollow,
      this.follow,
      this.sections,
      this.sectionArtist,
      this.sectionMV, 
      this.listSectionPlayList,
      this.sectionSong,
      this.timestamp
    });
  
  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alias = json['alias'];
    thumbnail = json['thumbnail'];
    biography = json['biography'];
    sortBiography = json['sortBiography'];
    thumbnailM = json['thumbnailM'];
    national = json['national'];
    birthday = json['birthday'];
    realname = json['realname'];
    totalFollow = json['totalFollow'];
    follow = json['follow'];
    if (json['sections'] != null) {
      listSectionPlayList = <Sections>[];
      json['sections'].forEach((value){
        if(value['sectionType'] == "song"){
          sectionSong = Sections.fromJson(value);
        }
        
        if(value['sectionType'] == 'artist'){
          sectionArtist = Sections.fromJson(value);
        }

        if(value['sectionType'] == 'video'){
          sectionMV = Sections.fromJson(value);
        }

        if(value['sectionType'] == 'playlist' ){
          listSectionPlayList!.add(Sections.fromJson(value));
        }
      });
      
    }
  }

  Artist.fromJsonprefs(Map<String, dynamic> json){
    id = json["id"];
    name = json["name"];
    alias = json["alias"];
    thumbnail = json["thumbnail"];
    totalFollow = json["totalFollow"];
  }

  Map<String, dynamic> toJson() => {
    "id" : id,
    'name': name,
    'alias': alias,
    'thumbnail': thumbnail,
    'totalFollow': totalFollow,
  };

  Artist.fromJsonFirebase(Map<String, dynamic> json){
    id = json["id"];
    name = json["name"];
    alias = json["alias"];
    thumbnail = json["thumbnail"];
    totalFollow = json["totalFollow"];
    timestamp = json["timestamp"];
  }

  Map<String, dynamic> toJsonFirebase() => {
    "id" : id,
    'name': name,
    'alias': alias,
    'thumbnail': thumbnail,
    'totalFollow': totalFollow,
    'timestamp' : timestamp,
  };
}

class Sections {
  String? sectionType;
  String? title;
  List<Song>? songItems;
  List<MV>? MVItems;
  List<Artist>? artistIteam;
  List<PlayList>? playListitems;

  Sections(
      {this.sectionType,
      this.title,
      this.MVItems,
      this.artistIteam,
      this.playListitems,
      this.songItems,
      });

  Sections.fromJson(Map<String, dynamic> json) {
    sectionType = json['sectionType'];
    title = json['title'];
    if(json['items'] != null){
      if(sectionType == 'song'){
        songItems = <Song>[];
        json['items'].forEach((value){
          songItems!.add(Song.fromJson(value));
        });
      }
      if(sectionType == 'artist'){
        artistIteam = <Artist>[];
        json['items'].forEach((value){
          artistIteam!.add(Artist.fromJson(value));
        });
      }
      if(sectionType == 'video'){
        MVItems = <MV>[];
        json['items'].forEach((value){
          MVItems!.add(MV.fromJson(value));
        });
      }
      if(sectionType == 'playlist'){
        playListitems = <PlayList>[];
        json['items'].forEach((value){
          playListitems!.add(PlayList.fromJson(value));
        });
      }
    }
  }

  Sections.fromJsonFirebase(Map<String, dynamic> json) {
    sectionType = json['sectionType'];
    title = json['title'];
    if (json['songItems'] != null) {
      songItems = [];
      json['songItems'].forEach((s) {
        songItems!.add(Song.fromJsonFirebase(s));
      });
    }
    if (json['MVItems'] != null) {
      MVItems = [];
      json['MVItems'].forEach((m) {
        MVItems!.add(MV.fromJson(m));
      });
    }
    if (json['artistIteam'] != null) {
      artistIteam = [];
      json['artistIteam'].forEach((a) {
        artistIteam!.add(Artist.fromJson(a));
      });
    }
    if (json['playListitems'] != null) {
      playListitems = [];
      json['playListitems'].forEach((p) {
        playListitems!.add(PlayList.fromJson(p));
      });
    }
  }
  
}
