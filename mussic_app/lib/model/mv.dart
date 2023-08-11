import 'package:mussic_app/model/artist.dart';

class MV {
  String? encodeId;
  String? title;
  String? alias;
  String? username;
  String? artistsNames;
  List<Artist>? artists;
  String? thumbnailM;
  String? thumbnail;
  int? duration;
  Artist? artist;
  int? startTime;
  int? endTime;
  String? lyric;
  List<String>? lyrics;
  List<MV>? recommends;
  Streaming? streaming;
  String? timestamp;

  MV(
      {this.encodeId,
      this.title,
      this.alias,
      this.username,
      this.artistsNames,
      this.artists,
      this.thumbnailM,
      this.thumbnail,
      this.duration,
      this.artist,
      this.startTime,
      this.endTime,
      this.lyric,
      this.lyrics,
      this.recommends,
      this.streaming,
      this.timestamp
    });

  MV.fromJson(Map<String, dynamic> json) {
    encodeId = json['encodeId'];
    title = json['title'];
    alias = json['alias'];
    username = json['username'];
    artistsNames = json['artistsNames'];
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add( Artist.fromJson(v));
      });
    }
    thumbnailM = json['thumbnailM'];
    thumbnail = json['thumbnail'];
    duration = json['duration'];
    artist =
        json['artist'] != null ?  Artist.fromJson(json['artist']) : null;
    startTime = json['startTime'];
    endTime = json['endTime'];
    
    if (json['recommends'] != null) {
      recommends = <MV>[];
      json['recommends'].forEach((v) {
        recommends!.add( MV.fromJson(v));
      });
    }
    if(json["streaming"] != null){
      streaming = Streaming.fromJson(json["streaming"]);
    }
  }

  MV.fromJsonFirebase(Map<String, dynamic> json){
    encodeId = json["encodeId"];
    title = json["title"];
    artistsNames = json["artistsNames"];
    thumbnail = json["thumbnail"];
    thumbnailM= json["thumbnail"];
    duration = json["duration"];
  }

  Map<String, dynamic> toJsonFirebase() => {
    "encodeId" : encodeId,
    "title" : title,
    "artistsNames" : artistsNames,
    "thumbnailM" : thumbnailM,
    "thumbnail" : thumbnail,
    "duration" : duration
  };
}

class Streaming {
  Mp4? mp4;
  Mp4? hls;

  Streaming({this.mp4, this.hls});

  Streaming.fromJson(Map<String, dynamic> json) {
    mp4 = json['mp4'] != null ?  Mp4.fromJson(json['mp4']) : null;
    hls = json['hls'] != null ?  Mp4.fromJson(json['hls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (mp4 != null) {
      data['mp4'] = mp4!.toJson();
    }
    if (hls != null) {
      data['hls'] = hls!.toJson();
    }
    return data;
  }
}

class Mp4 {
  String? s360p;
  String? s480p;
  String? s720p;
  String? s1080p;

  Mp4({this.s360p, this.s480p, this.s720p, this.s1080p});

  Mp4.fromJson(Map<String, dynamic> json) {
    s360p = json['360p'];
    s480p = json['480p'];
    s720p = json['720p'];
    s1080p = json['1080p'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['360p'] = s360p;
    data['480p'] = s480p;
    data['720p'] = s720p;
    data['1080p'] = s1080p;
    return data;
  }
}