import 'package:mussic_app/model/album.dart';
import 'package:mussic_app/model/artist.dart';

class zingWeek {
  SongCountry? vn;
  SongCountry? us;
  SongCountry? korea;

  zingWeek({this.vn, this.us, this.korea});

  zingWeek.fromJson(Map<String, dynamic> json) {
    vn = json['vn'] != null ? new SongCountry.fromJson(json['vn']) : null;
    us = json['us'] != null ? new SongCountry.fromJson(json['us']) : null;
    korea = json['korea'] != null ? new SongCountry.fromJson(json['korea']) : null;
  }
}

class SongCountry{
  String? banner;
  String? playlistId;
  int? chartId;
  String? cover;
  String? country;
  String? type;
  String? link;
  int? week;
  int? year;
  int? latestWeek;
  String? startDate;
  String? endDate;
  List<ItemsSongCountry>? items;
  String? sectionId;

  SongCountry(
      {this.banner,
      this.playlistId,
      this.chartId,
      this.cover,
      this.country,
      this.type,
      this.link,
      this.week,
      this.year,
      this.latestWeek,
      this.startDate,
      this.endDate,
      this.items,
      this.sectionId});

  SongCountry.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    playlistId = json['playlistId'];
    chartId = json['chartId'];
    cover = json['cover'];
    country = json['country'];
    type = json['type'];
    link = json['link'];
    week = json['week'];
    year = json['year'];
    latestWeek = json['latestWeek'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    if (json['items'] != null) {
      items = <ItemsSongCountry>[];
      json['items'].forEach((v) {
        items!.add(new ItemsSongCountry.fromJson(v));
      });
    }
    sectionId = json['sectionId'];
  }
}

class ItemsSongCountry {
  String? encodeId;
  String? title;
  String? alias;
  bool? isOffical;
  String? username;
  String? artistsNames;
  List<Artist>? artists;
  bool? isWorldWide;
  String? thumbnailM;
  String? link;
  String? thumbnail;
  int? duration;
  bool? zingChoice;
  bool? isPrivate;
  bool? preRelease;
  int? releaseDate;
  List<String>? genreIds;
  Album? album;
  bool? isIndie;
  int? streamingStatus;
  bool? allowAudioAds;
  bool? hasLyric;
  int? rakingStatus;
  int? score;
  String? mvlink;
  List<int>? downloadPrivileges;

  ItemsSongCountry(
      {this.encodeId,
      this.title,
      this.alias,
      this.isOffical,
      this.username,
      this.artistsNames,
      this.artists,
      this.isWorldWide,
      this.thumbnailM,
      this.link,
      this.thumbnail,
      this.duration,
      this.zingChoice,
      this.isPrivate,
      this.preRelease,
      this.releaseDate,
      this.genreIds,
      this.album,
      this.isIndie,
      this.streamingStatus,
      this.allowAudioAds,
      this.hasLyric,
      this.rakingStatus,
      this.score,
      this.mvlink,
      this.downloadPrivileges});

  ItemsSongCountry.fromJson(Map<String, dynamic> json) {
    encodeId = json['encodeId'];
    title = json['title'];
    alias = json['alias'];
    isOffical = json['isOffical'];
    username = json['username'];
    artistsNames = json['artistsNames'];
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add(new Artist.fromJson(v));
      });
    }
    isWorldWide = json['isWorldWide'];
    thumbnailM = json['thumbnailM'];
    link = json['link'];
    thumbnail = json['thumbnail'];
    duration = json['duration'];
    zingChoice = json['zingChoice'];
    isPrivate = json['isPrivate'];
    preRelease = json['preRelease'];
    releaseDate = json['releaseDate'];
    genreIds = json['genreIds'].cast<String>();
    album = json['album'] != null ? new Album.fromJson(json['album']) : null;
    isIndie = json['isIndie'];
    streamingStatus = json['streamingStatus'];
    allowAudioAds = json['allowAudioAds'];
    hasLyric = json['hasLyric'];
    rakingStatus = json['rakingStatus'];
    score = json['score'];
    mvlink = json['mvlink'];
  }
}