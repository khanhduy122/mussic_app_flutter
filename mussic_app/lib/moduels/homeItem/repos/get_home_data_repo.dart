import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mussic_app/model/HomeData.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mussic_app/model/exceptions.dart';

class getHomeDataRepo{
  Future<HomeData> fetchHomeItem(http.Client client) async {
    String url = "https://api-zingmp3-vercel.vercel.app/api/home";
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      final response = await client.get(Uri.parse(url));
      try {
        if(response.statusCode == 200){
          Map<String, dynamic> mapResponse = json.decode(response.body);
          if(mapResponse["msg"] == "Success"){
            print(mapResponse.toString());
            return HomeData.fromJson(mapResponse['data']);
          }else{
            throw Exception('failed');
          }
        }else{
          throw Exception('failed');
        }
      } catch (e) {
        throw Exception('failed');
      }
    }else{
      throw NoIntenetException();
    }
    
  }
}