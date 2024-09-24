import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';

Logger logger= Logger();

Future<String> summary(Future<String>? str, String? lang) async{
  try{
    final url= Uri.parse("http://127.0.0.1:6000/summarizeApi");
    var dict={
      'name': await str,
      'language': lang?? 'en'
    };
    final response= await http.post(url, body: json.encode(dict), headers:{'Content-type': 'application/json',});
    
    logger.i("ENTERED");
    if(response.statusCode== 200){
      logger.i("Data sent Successfully");
      var data= jsonDecode(response.body);
      logger.i(data['summarized_text']);
      return data['summarized_text'];
    }else{
      logger.e("Data not able to send");
      return "";
    }

  } catch(error){
    logger.e("Catch Summary: $error");
    return "";
  }
}