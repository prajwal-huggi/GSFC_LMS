import 'package:flutter/material.dart';

class TaskManager {
  taskBar(String name) {
    return AppBar(
      title: Center(child: Text(name, textAlign: TextAlign.center)),
      actions: [
        Image.asset(
          'assets/logo.jpeg',
          height: 30,
          alignment: Alignment.topRight,
        ),
        const Padding(padding: EdgeInsets.all(5))
      ],
    );
  }
}
