import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AudioPlayer player;
  Duration? totalDuration = Duration.zero;
  Duration? currDuration = Duration.zero;
  Duration? bufferDuration = Duration.zero;
  bool isLoading = false;
  var audioUrl =
      "https://raag.fm/files/mp3/128/Hindi-Singles/23303/Kesariya%20(Brahmastra)%20-%20(Raag.Fm).mp3";

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    setUpMyAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio'),
      ),
      body: Center(
        child: isLoading? Center(child: CircularProgressIndicator(),) : Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressBar(
                  progressBarColor: Colors.red,
                  baseBarColor: Colors.grey,
                  progress: currDuration!,
                  thumbColor: Colors.red,
                  thumbGlowColor: Colors.red.withOpacity(0.4),
                  bufferedBarColor: Colors.red.shade200,
                  buffered: bufferDuration,
                  total: totalDuration!,
                onSeek: (value){
                    player.seek(value);
                    setState(() {

                    });
                },
              ),
              InkWell(
                onTap: () {

                  if(player.playing){
                    player.pause();
                  } else {
                    player.play();
                  }
                  setState(() {

                  });

                },
                child: player.playing? Icon(Icons.pause) : Icon(Icons.play_arrow),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setUpMyAudio() async {
    try {
      totalDuration = await player.setUrl(audioUrl);

      player.playerStateStream.listen((event) {
        print(event.processingState);
        if(event.processingState==ProcessingState.loading){
          isLoading = true;
          setState(() {

          });
        } else if(event.processingState==ProcessingState.ready){
          isLoading = false;
          setState(() {

          });
        }
      });

      player.positionStream.listen((event) {
        print(event!.inSeconds);
        currDuration = event;
        setState(() {

        });

      });

      player.bufferedPositionStream.listen((event) {
        bufferDuration = event;
        setState(() {

        });
      });

      player.play();
      setState(() {

      });
    } catch (e) {
      print("error loading: $e");
    }
  }
}
