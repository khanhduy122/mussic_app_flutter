import 'package:mussic_app/model/artist.dart';

class Song {
  String? encodeId;
  String? title;
  String? alias;
  String? artistsNames;
  List<Artist>? artists;
  String? thumbnailM;
  String? thumbnail;
  int? duration;
  bool? isPrivate;
  int? releaseDate;
  int? streamingStatus;
  bool? hasLyric;
  String? timestamp;
  

  Song(
      {this.encodeId,
      this.title,
      this.alias,
      this.artistsNames,
      this.artists,
      this.thumbnailM,
      this.thumbnail,
      this.duration,
      this.isPrivate,
      this.releaseDate,
      this.streamingStatus,
      this.hasLyric,
      this.timestamp
      });

  Song.fromJson(Map<String, dynamic> json) {
    encodeId = json['encodeId'];
    alias = json['alias'];
    artistsNames = json['artistsNames'];
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add(new Artist.fromJson(v));
      });
    }
    thumbnailM = json['thumbnailM'];
    thumbnail = json['thumbnail'];
    duration = json['duration'];
    isPrivate = json['isPrivate'];
    releaseDate = json['releaseDate'];
    streamingStatus = json['streamingStatus'];
    hasLyric = json['hasLyric'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() => {
    'encodeId': encodeId,
    'title': title,
    'alias': alias,
    'artistsNames': artistsNames,
    'artists': artists?.map((artist) => artist.toJsonFirebase()).toList(),
    'thumbnailM': thumbnailM,
    'thumbnail': thumbnail,
    'duration': duration,
    'isPrivate': isPrivate,
    'releaseDate': releaseDate,
    'streamingStatus': streamingStatus,
    'hasLyric': hasLyric,
  };

  Song.fromJsonFirebase(Map<String, dynamic> json) {
    encodeId = json['encodeId'];
    alias = json['alias'];
    artistsNames = json['artistsNames'];
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add(new Artist.fromJson(v));
      });
    }
    thumbnailM = json['thumbnailM'];
    thumbnail = json['thumbnail'];
    duration = json['duration'];
    isPrivate = json['isPrivate'];
    releaseDate = json['releaseDate'];
    streamingStatus = json['streamingStatus'];
    hasLyric = json['hasLyric'];
    title = json['title'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJsonFirebase() => {
    'encodeId': encodeId,
    'title': title,
    'alias': alias,
    'artistsNames': artistsNames,
    'artists': artists?.map((artist) => artist.toJsonFirebase()).toList(),
    'thumbnailM': thumbnailM,
    'thumbnail': thumbnail,
    'duration': duration,
    'isPrivate': isPrivate,
    'releaseDate': releaseDate,
    'streamingStatus': streamingStatus,
    'hasLyric': hasLyric,
    'timestamp' : timestamp,
  };
}