import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/song.dart';

class Chart {
  RTChart? rTChart;
  List<NewRelease>? newRelease;
  WeekChart? weekChart;

  Chart({this.rTChart, this.newRelease, this.weekChart});

  Chart.fromJson(Map<String, dynamic> json) {
    rTChart =
        json['RTChart'] != null ? RTChart.fromJson(json['RTChart']) : null;
    if (json['newRelease'] != null) {
      newRelease = <NewRelease>[];
      json['newRelease'].forEach((v) {
        newRelease!.add( NewRelease.fromJson(v));
      });
    }
    weekChart = json['weekChart'] != null
        ?  WeekChart.fromJson(json['weekChart'])
        : null;
  }
}

class RTChart {
  List<Song>? songs;
  Chart? chart;
  String? chartType;
  String? sectionType;
  String? sectionId;

  RTChart({
      this.songs,
      this.chart,
      this.chartType,
      this.sectionType,
      this.sectionId
      });

  RTChart.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      songs = <Song>[];
      json['items'].forEach((v) {
        songs!.add( Song.fromJson(v));
      });
    }
    chart = json['chart'] != null ?  Chart.fromJson(json['chart']) : null;
    chartType = json['chartType'];
    sectionType = json['sectionType'];
    sectionId = json['sectionId'];
  }
}

class NewRelease {
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
  String? distributor;
  bool? isIndie;
  int? streamingStatus;
  bool? allowAudioAds;
  bool? hasLyric;
  String? mvlink;
  List<int>? downloadPrivileges;

  NewRelease(
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
      this.distributor,
      this.isIndie,
      this.streamingStatus,
      this.allowAudioAds,
      this.hasLyric,
      this.mvlink,
      this.downloadPrivileges});

  NewRelease.fromJson(Map<String, dynamic> json) {
    encodeId = json['encodeId'];
    title = json['title'];
    alias = json['alias'];
    isOffical = json['isOffical'];
    username = json['username'];
    artistsNames = json['artistsNames'];
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add( Artist.fromJson(v));
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
    if(json['genreIds'] != null){
     genreIds =  json['genreIds'].cast<String>();
    }
    distributor = json['distributor'];
    isIndie = json['isIndie'];
    streamingStatus = json['streamingStatus'];
    allowAudioAds = json['allowAudioAds'];
    hasLyric = json['hasLyric'];
    mvlink = json['mvlink'];
    if(json['downloadPrivileges'] != null){
      downloadPrivileges = json['downloadPrivileges'].cast<int>();
    }
    
  }
}

class WeekChart {
  ItemWeekChart? vn;
  ItemWeekChart? us;
  ItemWeekChart? korea;

  WeekChart({this.vn, this.us, this.korea});

  WeekChart.fromJson(Map<String, dynamic> json) {
    vn = json['vn'] != null ?  ItemWeekChart.fromJson(json['vn']) : null;
    us = json['us'] != null ?  ItemWeekChart.fromJson(json['us']) : null;
    korea = json['korea'] != null ?  ItemWeekChart.fromJson(json['korea']) : null;
  }
}

class ItemWeekChart {
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
  List<Song>? songs;
  String? sectionId;

  ItemWeekChart(
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
      this.songs,
      this.sectionId});

  ItemWeekChart.fromJson(Map<String, dynamic> json) {
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
      songs = <Song>[];
      json['items'].forEach((v) {
        songs!.add( Song.fromJson(v));
      });
    }
    sectionId = json['sectionId'];
  }
}


