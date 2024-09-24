// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoList extends StatefulWidget {
//   const VideoList({super.key});

//   @override
//   State<VideoList> createState() => _VideoListState();
// }

// class _VideoListState extends State<VideoList> {
//   final List<String> videoUrls=[
//     'https://youtu.be/yvwoDRNuA7Q?feature=shared'
//   ];

//   List<VideoPlayerController> _controllers= [];

//   @override
//   void initState(){
//     super.initState();

//     _controllers= videoUrls.map((url)=> VideoPlayerController.network(url)..initialize()).toList();
//   }

//   @override
//   void dispose(){
//     for( var controller in _controllers){
//       controller.dispose();
//     }
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard"),
//       ),
//       // body: Center(child: Text('List of videos will be visible'),),
//       body: ListView.builder(
//         itemCount: videoUrls.length,
//         itemBuilder: (context, index){
//           final controller= _controllers[index];
//           return Padding(
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               children:[
//                 if(controller.value.isInitialized)
//                   AspectRatio(aspectRatio: controller.value.aspectRatio,
//                   child: VideoPlayer(controller),)
//                 else
//                   Container(height: 200,
//                   color: Colors.black,
//                   child: Center(child: CircularProgressIndicator()),),
//               ]
//             )
//           );
//         }
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:recog/page/video_player_screen.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  final List<Map<String, String>> videos=[
    {
      'title': 'Video 1',
      'url': 'https://youtu.be/yvwoDRNuA7Q?feature=shared'
    },
    {
      'title': 'Video 2',
      'url': 'https://youtu.be/aLx2q-UnH6M?si=8-97tUnBN0yaWPYP'
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder:(context, index){
          return ListTile(
            title: Text(videos[index]['title']!),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=> VideoPlayerScreen(
                  videoUrl: videos[index]['url']!,
                ),
              ),);
            },
          );
        }
      ),
    );
  }
}