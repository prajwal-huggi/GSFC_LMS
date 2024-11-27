import 'package:flutter/material.dart';
import 'package:recog/page/authority/studentFaculty.dart';
import 'package:recog/page/bottom_navigation.dart';

void main() async{
  runApp(
    MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: const BottomNavigator()
      // home:  Process(),
      home: const StudentFalcultLogin()
    ),
  );
}