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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:recog/components/box_decorator.dart';
import 'package:recog/page/process.dart';
import 'package:recog/page/video_player_screen.dart';
import 'package:recog/service/get_all_videos.dart';
import 'package:recog/service/get_particular_lectures.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  late Future<List<dynamic>> _allData;
  
  final List<String> _dropDownItems= [
    "OS", "COA", "DSA", "DBMS", "CN"
  ];
  String? _selectedSubject; 

  @override
  void initState() {
    // TODO: implement initState
    _allData= getAllVideoLectures();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of videos"),
        actions:[
          IconButton(
            icon:const Icon(Icons.refresh_outlined),
          onPressed:(){
            setState(() {});
          }, ),]),
        
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //Dropdown menu
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: DropdownButton<String>(
                      value: _selectedSubject,
                      hint: const Text("Select Subject"),
                      onChanged: (String? value){
                        setState((){
                _selectedSubject= value;
                _allData= getParticularLectures(_selectedSubject);
                        });
                      },
                      items: _dropDownItems.map<DropdownMenuItem<String>>((String value){
                        return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
                        );
                      }).toList(),
                    ),
              ),
            ),
            //Horizontal line for differentiating
            const Divider(
              thickness: 1,
            ),
            //Listview for videos
            FutureBuilder(
              future: _allData, 
              builder: (context, snapshot){
                if(snapshot.connectionState== ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }else if(snapshot.hasError){
                  return const Text("Unexpected Error occurred");
                }else if(snapshot.hasData){
                  final items= snapshot.data!;
                  if(items.isEmpty){
                    return const Expanded(child: Center(child: Text("No lectures uploaded")));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecorator.boxdecorator,
                            child: ListTile(
                              title: Text(items[index]['title']),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder:(context)=> Process(videoFile:items[index]['video_url']),
                                ));
                              },
                            ),
                          ),
                        );
                      }),
                  );
                }
                else{
                  return const Center(child: Text("No lectures uploaded"));
                }
              })
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: videos.length,
            //     itemBuilder:(context, index){
            //       return ListTile(
            //         title: Text(videos[index]['title']!),
            //         onTap: (){
            //           Navigator.push(context, MaterialPageRoute(
            //             builder: (context)=> VideoPlayerScreen(
            //               videoUrl: videos[index]['url']!,
            //             ),
            //           ),);
            //         },
            //       );
            //     }
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}