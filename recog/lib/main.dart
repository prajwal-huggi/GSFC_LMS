import 'package:flutter/material.dart';
import 'package:recog/page/authority/studentFaculty.dart';

void main() async{
  runApp(
    MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      // home:  Process(),
      home: const StudentFalcultLogin()
    ),
  );
}