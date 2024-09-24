import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:recog/components/box_decorator.dart';
import 'package:recog/service/summary.dart';
import 'package:recog/service/transcribe.dart';
import 'package:recog/service/translate.dart';
import 'package:video_player/video_player.dart';
import 'package:recog/components/taskmanager.dart';

class Process extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const Process({super.key, required this.videoPath, required this.videoFile});

  @override
  State<Process> createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
  // Future<String>? transcribeText= Future.value("My name is Ram Prasad Bismil");
  Future<String>? transcribeText= Future.value("My name is Prajwal. Prajwal is very intelligent. Prajwal is foodie. Prajwal is hero. Prajwal is great. Prajwal is doing great work. Prajwal is an awesome man");
  Future<String>? translateText;
  Future<String>? summarizeText;

  Logger logger= Logger();
  late CustomVideoPlayerController _customVideoPlayerController;
  String? _selectedLanguage= "Select Language";
  final List<String> _dropDownItems=[
    //All languages should be inserted here
    "English", "Hindi", "Gujarati", "Sanskrit", "Kannada"
  ];

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
    // transcribeText= transcribe(widget.videoFile);
    translateText= transcribeText;
    //Serive Method will be called in this page
  }

//Starting the video player
  void initializeVideoPlayer() {
    // VideoPlayerController _videoPlayerController;
    // _videoPlayerController = VideoPlayerController.file(widget.videoFile)
    //   ..initialize().then((value) {
    //     setState((){

    //     });
    //   });
    
    CachedVideoPlayerController _cachedVideoPlayerController;
    _cachedVideoPlayerController= CachedVideoPlayerController.file(widget.videoFile)
    ..initialize().then((value){
      setState((){});
    });

    _customVideoPlayerController= CustomVideoPlayerController(context: context, videoPlayerController: _cachedVideoPlayerController);
    // _customVideoPlayerController= CustomVideoPlayerController(context: context, videoPlayerController: _videoPlayerController);
  }

  Text getTranscription(){
    return Text("Transcription will be showed with the help of backend");
  }

  Text getQna(){
    return Text("QnA will be returned to user");
  }

//Dropdown Button for all the possible languages
  DropdownButton dialogBox(){
    return DropdownButton<String>(
      value: _selectedLanguage== "Select Language"? null: _selectedLanguage,
      hint: const Text("Select Language"),
      onChanged: (String? value){
        setState((){
          _selectedLanguage= value;
          translateText= translate(transcribeText, _selectedLanguage);
          summarizeText= summary(transcribeText, _selectedLanguage);
        });
      },
      items: _dropDownItems.map<DropdownMenuItem<String>>((String value){
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskManager().taskBar("Lecture Insights"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            //video player
            CustomVideoPlayer(customVideoPlayerController: _customVideoPlayerController),
            const SizedBox(height: 15),
        
            // Text('transcribing'),
            const Text("Transcription"),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecorator.boxdecorator,
              child: getTranscription(),
            ),
            const SizedBox(height: 15),
        
            //Translation
            const Text("Translation"),
            const SizedBox(height: 15),
            //Dropdown for language selection
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration:BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(3),
                ),
                child:dialogBox(),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecorator.boxdecorator,
              // child: Text(translateText.toString()),
              child: FutureBuilder(future: translateText, 
              builder: (context, snapshot){
                if(snapshot.connectionState== ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else if(snapshot.hasError){
                  return Text("Error: ${snapshot.error}");
                }else if(snapshot.hasData){
                  var items= snapshot.data;
                  logger.i("ITEMS are $items");
                return Text(snapshot.data.toString());
                }else{
                  return const Text("No data found");}
              },
              )
            ),
            const SizedBox(height: 15),
        
            // Text('qna'),
            const Text("Probable QnA"),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecorator.boxdecorator,
              child: getQna(),
            ),
            const SizedBox(height: 15),
        
            // Text('Summary')
            const Text("Summary"),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecorator.boxdecorator,
              child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecorator.boxdecorator,
              // child: Text(translateText.toString()),
              child: FutureBuilder(future: summarizeText, 
              builder: (context, snapshot){
                if(snapshot.connectionState== ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else if(snapshot.hasError){
                  return Text("Error: ${snapshot.error}");
                }else if(snapshot.hasData){
                  var items= snapshot.data;
                  logger.i("ITEMS are $items");
                return Text(snapshot.data.toString());
                }else{
                  return const Text("No data found");}
              },
              )
            ),
            ),
            //Just for testing
            // ElevatedButton(onPressed: (){logger.i(_selectedLanguage);}, child: const Text("JKHLKJHL:K"),),
          ],
        ),
      ),
    );
  }
}