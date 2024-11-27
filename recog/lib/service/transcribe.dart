import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';

Logger logger= Logger();

// Future<String> transcribe(File file) async{
Future<String> transcribe(String pathOfFile) async{
  try{
    logger.i("Entered in the transcribe.dart file");
    final url= Uri.parse("http://127.0.0.1:6000/transcribeApi");

    var dict={
      'filePath': pathOfFile
    };
    final response= await http.post(url, body: json.encode(dict), headers:{'Content-Type':'application/json',});

    // var request= http.MultipartRequest('POST', url);

    // final mimeType= lookupMimeType(file.path);

    // request.files.add(
    //   await http.MultipartFile.fromPath(
    //     'file',
    //     file.path,
    //     filename: basename(file.path),
    //     contentType: mimeType!= null ? MediaType.parse(mimeType): null,
    //   ),
    // );

    // final response= await request.send();

    if(response.statusCode== 200){
      logger.i("File sent successfully");

      // final responseData= await http.Response.fromStream(response);
      // var data= json.decode(responseData.body);

      // logger.i("transcribed data: ${data['transcribed_text]']}");
      // return data['transcribed_text'];

      var data= json.decode(response.body);
      logger.i("transcribed data: $data");
      return data['transcribed_text'];
    }else{
      logger.e("Failed to send file. Status code: ${response.statusCode}");
      return "";
    }
    // request.files.add(
      
    // );
    // // final response= http.MultipartFile('POST',url);
    // if(response.statusCode== 200){
    //   logger.i("Data sent successfully");
    //   var data= json.decode(response.body);
    //   logger.i("transcribed data: ${data['transcribed_text']}");
    //   return data['transcribed_text'];
    // }else{
    //   logger.e("Not able to send data");
    //   return "";
    // }
  } catch(error){
    logger.e("Catch: $error");
    return "";
  }
}