import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:recog/components/taskmanager.dart';
import 'package:recog/page/process.dart';
import 'package:recog/service/upload_video_service.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController _titleController = TextEditingController();
  final List<String> _subjects = ["OS", "COA", "DBMS", "DSA"];
  String? _selectedSubject;
  Logger logger = Logger();
  XFile? videoFile;

  getVideoFile() async {
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      videoFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (videoFile != null) {
        logger.i("File is selected and sent to backend");
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Process(
        //       videoFile: File(videoFile!.path),
        //       videoPath: videoFile!.path,
        //     ),
        //   ),
        // );
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
                child: Image.asset(
                  'assets/upload.png',
                  height: 150,
                ),
                onTap: () {
                  getVideoFile();
                }),
            const SizedBox(height: 15),

            //Set title of the video
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Title of the Video",
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Select the category of the subject
            DropdownButton(
              value: _selectedSubject,
              hint: const Text("Select the subject"),
              onChanged: (String? value) {
                setState(() {
                  _selectedSubject = value;
                });
              },
              items: _subjects.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),

            //Submit button
            ElevatedButton(
                onPressed: () {
                  //Testing
                  // uploadvideos(File('/Users/prajwal/Personal/College/Sem7/MinorProject/srk.mp4'), 'test tile', 'COA');
                  if (videoFile != null || _selectedSubject!= null || _titleController.text!= '') {
                    logger.i("title: ${_titleController.text}");
                    logger.i("subject: ${_selectedSubject}");
                    uploadvideos(File(videoFile!.path), _titleController.text,
                        _selectedSubject);
                  } else {
                    Fluttertoast.showToast(
                      msg: "All fields are required",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP_LEFT,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 18.0);
                    logger.e("No video file selected");
                  }
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}
