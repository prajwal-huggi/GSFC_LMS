import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:recog/components/taskmanager.dart';
import 'package:recog/page/process.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Logger logger = Logger();

  getVideoFile() async {
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      final videoFile =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (videoFile != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Process(
              videoFile: File(videoFile.path),
              videoPath: videoFile.path, 
            ),
          ),
        );
      } else {
        logger.e("File not selected");
      }
    } else {
      logger.e("Platform not supported for file operations");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskManager().taskBar("Submission Portal"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('Upload file'),
            InkWell(
              child: Image.asset('assets/upload.png', height: 150,),
              onTap: (){
                getVideoFile();
              }
            ),
            
          ],
        ),
      ),
    );
  }
}
