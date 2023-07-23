import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mussic_app/model/search.dart';

class GetSearchRepo {
  static final String pathURL = 'https://api-zingmp3-vercel.vercel.app/api';

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
}