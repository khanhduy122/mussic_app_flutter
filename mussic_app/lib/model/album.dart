import 'package:mussic_app/model/artist.dart';


class Album {
  String? encodeId;
  String? title;
  String? thumbnail;
  bool? isoffical;
  String? link;
  bool? isIndie;
  String? releaseDate;
  String? sortDescription;
  int? releasedAt;
  List<String>? genreIds;
  bool? pR;
  List<Artist>? artists;
  String? artistsNames;
  String? name;
  String? thumbnailMedium;
  String? id;
  

  Album(
      {this.encodeId,
      this.title,
      this.thumbnail,
      this.isoffical,
      this.link,
      this.isIndie,
      this.releaseDate,
      this.sortDescription,
      this.releasedAt,
      this.genreIds,
      this.pR,
      this.artists,
      this.artistsNames});

  Album.fromJson(Map<String, dynamic> json) {
    encodeId = json['encodeId'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    isoffical = json['isoffical'];
    link = json['link'];
    isIndie = json['isIndie'];
    releaseDate = json['releaseDate'];
    sortDescription = json['sortDescription'];
    releasedAt = json['releasedAt'];
    pR = json['PR'];
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        artists!.add(Artist.fromJson(v));
      });
    }
    artistsNames = json['artistsNames'];
    name = json['name'];
    thumbnailMedium = json['thumbnail_medium'];
    id = json['id'];
  }
}