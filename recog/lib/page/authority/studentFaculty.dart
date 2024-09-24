import 'package:flutter/material.dart';
import 'package:recog/page/authority/facult_login.dart';
import 'package:recog/page/authority/student_login.dart';

class StudentFalcultLogin extends StatefulWidget {
  const StudentFalcultLogin({super.key});

  @override
  State<StudentFalcultLogin> createState() => _StudentFalcultLoginState();
}

class _StudentFalcultLoginState extends State<StudentFalcultLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Yourself")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            InkWell(
              child: Image.asset('assets/teacher.png', height: 140,),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const FacultyLogin())
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("Faculty", style: TextStyle(fontSize: 20),),
            const SizedBox(height: 160),
            InkWell(
              child: Image.asset('assets/student.png', height: 140,),
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const StudentLogin())
                );
              }
            ),
            const SizedBox(height: 20),
            const Text("Student", style: TextStyle(fontSize: 20)),
          ]
        ),
      ),
    );
  }
}