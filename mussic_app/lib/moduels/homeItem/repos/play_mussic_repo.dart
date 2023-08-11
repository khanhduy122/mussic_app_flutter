import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/exceptions.dart';
import 'package:mussic_app/model/mv.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/search.dart';
import 'package:mussic_app/model/song.dart';

class PlayMussicRepo {

  static Future<Song> fetchSongInfo(http.Client client, String songID)async{
    String url = 'https://api-zingmp3-vercel.vercel.app/api/infosong?id=' + songID;
    var connectivity = await (Connectivity().checkConnectivity());
    if(connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi){
      final response = await client.get(Uri.parse(url)).timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw NoIntenetException();
      },
    );
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
    }else{
      throw NoIntenetException();
    }
    
  }

  static Future<PlayList> fetchInfoPlayList(http.Client client, String playListID) async {
    String url = 'https://api-zingmp3-vercel.vercel.app/api/detailplaylist?id=' + playListID;
    var connectivity = await (Connectivity().checkConnectivity());
    if(connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi){
      final respone = await client.get(Uri.parse(url)).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw NoIntenetException();
        },
      );
      if(respone.statusCode == 200){
        Map<String, dynamic> mapResponse = json.decode(respone.body);
        if(mapResponse["msg"] == "Success"){
          return PlayList.fromJson(mapResponse["data"]);
        }else{
          throw Exception('không lây được data');
        }
      }else{
        throw NoIntenetException();
      }
    }else{
      throw NoIntenetException();
    }
  }

  static Future<MV> fetchInfoVideo(http.Client client, String encodeId) async {
    String url = 'https://api-zingmp3-vercel.vercel.app/api/video?id=' + encodeId;
    var connectivity = await (Connectivity().checkConnectivity());
    if(connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi){
      final respone = await client.get(Uri.parse(url)).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw NoIntenetException();
        },
      );
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
    }else{
      throw NoIntenetException();
    }
  }

  static Future<Artist> fetchArtist(http.Client client, String nameArtist)async{
    String url =  'https://api-zingmp3-vercel.vercel.app/api/artist?name=' + nameArtist;
    var connectivity = await (Connectivity().checkConnectivity());
    if(connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi){
      final response = await client.get(Uri.parse(url)).timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw NoIntenetException();
      },
    );
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
    }else{
      throw NoIntenetException();
    }
    
  }

  static Future<Search> fetchSearch(http.Client client, String keySearch)async{
    String url = 'https://api-zingmp3-vercel.vercel.app/api/search?keyword=' + keySearch;
    var connectivity = await (Connectivity().checkConnectivity());
    if(connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi){
      final response = await client.get(Uri.parse(url)).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw NoIntenetException();
        },
      );
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
    }else{
      throw NoIntenetException();
    }
  }

}