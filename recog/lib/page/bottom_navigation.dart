import 'package:flutter/material.dart';
import 'package:recog/page/upload_video.dart';
import 'package:recog/page/video_list.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  static final List<Widget> _widgetOptions = <Widget>[
    const VideoList(),
    const UploadPage(),
  ];
  int _currentPageIndex= 0;

  void _onItemPressed(int index){
    setState((){
      _currentPageIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list, size:40),
            label: '',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.upload, size: 40),
            label: '',
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 88, 86, 214),
        currentIndex: _currentPageIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 204, 0),
        onTap: _onItemPressed,
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: _widgetOptions,
      ),
    );
  }
}