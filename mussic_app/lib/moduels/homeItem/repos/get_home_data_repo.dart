import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mussic_app/model/HomeData.dart';

class getHomeDataRepo{
  Future<HomeData> fetchHomeItem(http.Client client) async {
    String url = "https://api-zingmp3-vercel.vercel.app/api/home";
    final response = await client.get(Uri.parse(url));
    try {
      if(response.statusCode == 200){
        Map<String, dynamic> mapResponse = json.decode(response.body);
        if(mapResponse["msg"] == "Success"){
          return HomeData.fromJson(mapResponse['data']);
        }else{
          throw Exception('failed');
        }
      }else{
        throw Exception('failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}