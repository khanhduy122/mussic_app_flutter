import 'dart:convert';
import 'package:mussic_app/model/charts.dart';
import 'package:http/http.dart' as http;
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/model/top100.dart';

class getChartRepo{
  static Future<Chart> getChart(http.Client clien) async{
    String url = "https://api-zingmp3-vercel.vercel.app/api/charthome";
    final response = await clien.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        return Chart.fromJson(mapResponse['data']);
      }else{
        throw Exception('failed');
      }
    }else{
      throw Exception('failed');
    }
  }

  static Future<List<Top100>> getTop100(http.Client client) async {
    String url = "https://api-zingmp3-vercel.vercel.app/api/top100";
    final response = await client.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      print(mapResponse["data"].toString());
      if(mapResponse["msg"] == "Success"){
        final listTop100 = mapResponse['data'].cast<Map<String, dynamic>>();
        return listTop100.map<Top100>((json) => Top100.fromJson(json)).toList();
      }else{
        throw Exception('failed');
      }
    }else{
      throw Exception('failed');
    }
  }

  static Future<List<Song>> getNewReleaseChart(http.Client client) async {
    String url = "https://api-zingmp3-vercel.vercel.app/api/newreleasechart";
    final response = await client.get(Uri.parse(url));
    if(response.statusCode == 200){
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if(mapResponse["msg"] == "Success"){
        final listSong = mapResponse["data"]['items'].cast<Map<String, dynamic>>();
        return listSong.map<Song>((json) => Song.fromJson(json)).toList();
      }else{
        throw Exception('failed');
      }
    }else{
      throw Exception('failed');
    }
  }
}
