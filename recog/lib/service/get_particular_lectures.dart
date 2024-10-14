import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

Logger logger= Logger();

Future<List<dynamic>> getParticularLectures(String? selectedSubject) async{
  try{
    logger.i("Selected subject is $selectedSubject");
    final url= Uri.parse("http://127.0.0.1:5000/getLectures?category=$selectedSubject");
    
    // final response= await http.get(url, 
    // headers:{'Content-Type':'application/json'});
    final response= await http.get(url);
    if(response.statusCode== 200){
      List<dynamic> lectures= jsonDecode(response.body);
      logger.i("Lectures are \n $lectures");
      return lectures;
    }else{
      throw Exception('Failed to load lectures');
    }
  }catch(error){
    logger.e("Catch:$error");
    return [];
  }
}