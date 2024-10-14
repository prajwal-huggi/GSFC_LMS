import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

Logger logger= Logger();

Future<bool> verifyFaculty(BuildContext context, String email, String password) async{
  try{
    logger.i("Faculty Email: $email \n Faculty Password: $password");
    final url= Uri.parse("http://127.0.0.1:5000/verifyFaculty");

    var dict= {
      'facultyEmail': email,
      'facultyPassword': password
    };

    var response= await http.post(url, body: json.encode(dict), headers:{'Content-Type': 'application/json'});

    if(response.statusCode== 200){
      bool data= jsonDecode(response.body);
      if(data) logger.i("Faculty is verified");
      else logger.i("Faculty not exist");

      return data;
    }else{
      logger.e("Else Error");
      return false;
    }

  }catch(error){
    logger.e("Catch error: $error");
    return false;
  }
}