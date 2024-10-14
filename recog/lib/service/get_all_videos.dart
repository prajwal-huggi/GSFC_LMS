
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

Logger logger= Logger();

Future<List<dynamic>> getAllVideoLectures() async{
  try{
    final url= Uri.parse('http://127.0.0.1:5000/getAllVideos');
    final response= await http.get(url);

    if(response.statusCode== 200){
      var data= jsonDecode(response.body);
      logger.i(data);

      return data;
    }else{
      logger.e("Request not sent");
      return [];
    }

  }catch(error){
    logger.e("Catch exception: ${error}");
    return [];
  }
}