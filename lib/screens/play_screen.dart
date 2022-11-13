// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

//ignore_for_file:prefer_const_constructors

class PlayScreen extends StatefulWidget {
  const PlayScreen({
    Key? key,
    required this.songModel,
    required this.audioPlayer,
  }) : super(key: key);
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
//for playing the music in the secong screen

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSong();
  }

  void playSong() {
    try {
      widget.audioPlayer
          .setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      widget.audioPlayer.play();
      _isPlaying = true;
    } on Exception {
      log("No songs available");
    }

// gives the duration and position of the music

    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });

    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  void changeSlider(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }


  void moveNext(){
    

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.blue])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Image(
                          image: AssetImage(
                        "assets/back.jpg",
                      )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        widget.songModel.displayNameWOExt.toString(),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: Row(
                  children: [
                    Text(
                      _position.toString().split(".")[0],
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                        child: Slider(
                            min: Duration(microseconds: 0).inSeconds.toDouble(),
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                changeSlider(value.toInt());
                                value = value;
                              });
                            })),
                    Text(_duration.toString().split(".")[0],
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_previous,
                        size: 50,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (_isPlaying) {
                            widget.audioPlayer.pause();
                          } else {
                            widget.audioPlayer.play();
                          }
                          _isPlaying = !_isPlaying;
                        });
                      },
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 50,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.skip_next,
                        size: 50,
                      )),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
