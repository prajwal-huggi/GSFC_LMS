import 'package:flutter/material.dart';
import 'package:recog/page/authority/facult_login.dart';
import 'package:recog/page/authority/studentFaculty.dart';
import 'package:recog/page/authority/student_login.dart';
import 'package:recog/page/upload_video.dart';

void main() async{
  runApp(
    MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: const MainPage(),
      home: const StudentFalcultLogin()
    ),
  );
}