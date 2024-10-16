import 'package:flutter/material.dart';
import 'package:recog/components/taskmanager.dart';
import 'package:recog/page/bottom_navigation.dart';
import 'package:recog/page/video_list.dart';
import 'package:recog/service/verify.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  Future<bool>? _future;

  Future<bool> _callApi(String email, String password) async{
    Future<bool> verify= verifyStudent(BuildContext, email, password);
    await Future.delayed(const Duration(seconds: 3));

    return verify;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // image
            Image.asset('assets/logo.jpeg'),
            const SizedBox(height:30),
            // login field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Student Email",
                ),
              ),
            ),
            // password field
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Password",
                ),
              ),
            ),
            // submit button
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _future = _callApi(_emailController.text, _passwordController.text);
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 88, 86, 214),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: const Text("Sign In"),
              ),
            ),
            const SizedBox(height: 50),
            // FutureBuilder to show loading spinner and handle API response
            if (_future != null)
              FutureBuilder<bool>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData && snapshot.data == true) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const VideoList()),
                      );
                    });
                    return Container(); // Empty container as placeholder
                  } else {
                    return const Text("Email or password incorrect");
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}