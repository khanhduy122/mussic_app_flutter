import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mussic_app/model/exceptions.dart';

class audioPlayerRepo {
  static Future<String> fetchLinkSong(http.Client client, String songID) async {
    String url = 'https://api-zingmp3-vercel.vercel.app/api/song?id=' + songID;
    final response = await client.get(Uri.parse(url)).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw TimeoutException("get link song timeout");
      },
    );
    try {
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
    } catch (e) {
      rethrow;
    }
  }
}