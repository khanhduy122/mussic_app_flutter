import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/mv.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/song.dart';

class PlayMussicRepo {

  static Future<Song> fetchSongInfo(http.Client client, String songID)async{
    String url = 'https://api-zingmp3-vercel.vercel.app/api/infosong?id=' + songID;
    try {
      final response = await client.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        return Song.fromJson(mapResponse['data']);
      }else{
        throw Exception('không lây được data');
      }
    }else{
         throw Exception('không lây được data');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<PlayList> fetchInfoPlayList(http.Client client, String playListID) async {
    String url = 'https://api-zingmp3-vercel.vercel.app/api/detailplaylist?id=' + playListID;
    try {
      final respone = await client.get(Uri.parse(url));
      if(respone.statusCode == 200){
        Map<String, dynamic> mapResponse = json.decode(respone.body);
        if(mapResponse["msg"] == "Success"){
          return PlayList.fromJson(mapResponse["data"]);
        }else{
          throw Exception('không lây được data');
        }
      }else{
        throw Exception('không lây được data');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<MV> fetchInfoVideo(http.Client client, String encodeId) async {
    String url = 'https://api-zingmp3-vercel.vercel.app/api/video?id=' + encodeId;
    try {
      final respone = await client.get(Uri.parse(url));
      if(respone.statusCode == 200){
        Map<String, dynamic> mapResponse = json.decode(respone.body);
        if(mapResponse["msg"] == "Success"){
          return MV.fromJson(mapResponse["data"]);
        }else{
          throw Exception('không lây được data');
        }
      }else{
        throw Exception('không lây được data');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Artist> fetchArtist(http.Client client, String nameArtist)async{
    String url =  'https://api-zingmp3-vercel.vercel.app/api/artist?name=' + nameArtist;
    final response = await client.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        return Artist.fromJson(mapResponse['data']);
      }else{
        throw Exception('không lây được data');
      }
    }else{
         throw Exception('không lây được data');
      }
  }

}