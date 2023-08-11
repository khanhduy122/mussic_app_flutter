import 'package:mussic_app/model/song.dart';

class PlayList {
  String? encodeId;
  String? title;
  String? thumbnail;
  String? artistsNames;
  String? thumbnailM;
  String? userName;
  String? aliasTitle;
  List<Song>? songs;
  String? timestamp;

  PlayList(
      {this.encodeId,
      this.title,
      this.thumbnail,
      this.artistsNames,
      this.thumbnailM,
      this.userName,
      this.aliasTitle,
      this.songs,
      this.timestamp
    });

  PlayList.fromJson(Map<String, dynamic> json) {
    encodeId = json['encodeId'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    artistsNames = json['artistsNames'];
    thumbnailM = json['thumbnailM'];
    if(json["song"] != null){
        if (json['song']['items'] != null) {
        songs = <Song>[];
        json['song']['items'].forEach((v) {
          songs!.add( Song.fromJson(v));
        });
      }
    }
  }

  PlayList.fromJsonFirebase(Map<String, dynamic> json) {
    encodeId = json['encodeId'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    thumbnailM = json['thumbnailM'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['encodeId'] = encodeId;
    data['title'] = title;
    data['thumbnail'] = thumbnail;
    data['thumbnailM'] = thumbnailM;
    data['timestamp'] = timestamp;
    return data;
  }
  
}

