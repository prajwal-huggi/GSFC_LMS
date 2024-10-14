import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

Logger logger= Logger();
Future<bool> uploadvideos(File file, String? title, String? subject) async{
  try{
    final url= Uri.parse("http://127.0.0.1:5000/upload");
    
    //Get the MIME type of the file
    final mimeType= lookupMimeType(file.path);

    //Create a multipartRequest
    var request= http.MultipartRequest('POST', url);

    //Add video file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'video',
      file.path,
      contentType: MediaType.parse(mimeType!),
      filename: basename(file.path),
    ),);

    //Add additional fields
    request.fields['title']= title?? '';
    request.fields['category']= subject?? '';

    //Send the request
    var response= await request.send();

    //Get the response status
    if(response.statusCode== 200){
      logger.i("Upload Successful");
      return true;
    }else{
      logger.e("Upload failed with status: ${response.statusCode}");
      return false;
    }
  }catch(error){
    logger.i("Catch Error: ${error}");
    return false;
  }
}