

import 'dart:convert';
import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/HomeData.dart';
import 'package:http/http.dart' as http;
import 'package:mussic_app/model/mv.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/search.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/model/zingweek.dart';
import 'dart:async';


class NetwordRequest{

  static final String pathURL = 'https://api-zingmp3-vercel.vercel.app/api';

  static Future<List<Song>> fetchCharts(http.Client client) async {
    String url = "https://mp3.zing.vn/xhr/chart-realtime?songId=0&videoId=0&albumId=0&chart=song&time=-1";
    final response = await client.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        final listSongs = mapResponse["data"]["song"].cast<Map<String, dynamic>>();
        return listSongs.map<Song>((json) => Song.fromJson(json)).toList();
       }else{
        throw Exception('failed');
       }
    }else{
      throw Exception('failed');
    }
  }

  static Future<List<homeItem>> fetchHomeItem(http.Client client) async {
    String url = "https://api-zingmp3-vercel.vercel.app/api/home";
    final response = await client.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        final listhomeItem = mapResponse["data"]["items"].cast<Map<String, dynamic>>();
        return listhomeItem.map<homeItem>((json) => homeItem.fromJson(json)).toList();
      }else{
        throw Exception('failed');
      }
    }else{
      throw Exception('failed');
    }
  }

  static Future<zingWeek> fetchZingWeek(http.Client client)async{
    String url = pathURL + '/charthome';
    final response = await client.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        return zingWeek.fromJson(mapResponse["data"]['weekChart']);
      }else{
        throw Exception('failed');
      }
    }else{
      throw Exception('failed');
    }
  }

  static Future<PlayList> fetchSongPlayList(http.Client client, String playListID) async {
    String url = pathURL + '/detailplaylist?id=' + playListID;
    final response = await client.get(Uri.parse(url));
    print(response.statusCode.toString());
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        return PlayList.fromJson(mapResponse["data"]);
      }else{
        throw Exception('không lây được data');
      }
    }else{
         throw Exception('không lây được data');
      }
  }

  static Future<Song> fetchSongInfo(http.Client client, String songID)async{
    String url = pathURL + '/infosong?id=' + songID;
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
  }

  static Future<String> fetchLinkSong(http.Client client, String songId) async {
    String url = pathURL + '/song?id=' + songId;
    final response = await client.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        return mapResponse['data']['128'];
      }else{
        throw Exception('không lây được data');
      }
    }else{
         throw Exception('không lây được data');
      }
  }

  static Future<Artist> fetchArtist(http.Client client, String nameArtist)async{
    String url = pathURL + '/artist?name=' + nameArtist;
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

  static Future<Search> fetchSearch(http.Client client, String contentSearch)async{
    String url = pathURL + '/search?keyword=' + contentSearch;
    final response = await client.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        return Search.fromJson(mapResponse['data']);
      }else{
        throw Exception('không lây được data');
      }
    }else{
         throw Exception('không lây được data');
      }
  }

  static Future<MV> fetchMV(http.Client client, String mvID) async {
    String url = pathURL + '/video?id=' + mvID;
    final response = await client.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        return MV.fromJson(mapResponse['data']);
      }else{
        throw Exception('không lây được data');
      }
    }else{
         throw Exception('không lây được data');
      }
  }
}