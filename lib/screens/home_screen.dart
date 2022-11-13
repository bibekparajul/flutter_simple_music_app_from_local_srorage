import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicme/screens/play_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';

//ignore_for_file:prefer_const_constructors

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _audioQuery = new OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

// songs starts playing here

  playSongs(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log("Error parsing song");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
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

        //drawer part

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,

// ignore: prefer_const_literals_to_create_immutables
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    // ignore: prefer_const_literals_to_create_immutables
                    gradient: LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight)),
                child: Text("Music Me"),
              ),
              ListTile(
                title: const Text("Favourites"),
                hoverColor: Colors.lightBlueAccent,
                trailing: Icon(
                  Icons.favorite,
                  color: Colors.pink,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text("Playlists"),
                onTap: () {},
              )
            ],
          ),
        ),

        //appbar section

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Center(
              child: Text(
            "Music Me",
            textScaleFactor: 1.0,
          )),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
          ],
        ),

        body: Container(
            child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage('assets/back.jpg'),
                    fit: BoxFit.scaleDown),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                "Play Your Favourite Songs Here",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 40,
            ),

            //main logic starts  here

            Expanded(
                child: FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true),
              builder: (context, item) {
                if (item.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (item.data!.isEmpty) {
                  return Center(child: Text("No songs found"));
                }
                return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Card(
                          color: Colors.transparent,
                          elevation: 3.0,
                          child: ListTile(
                            title: Text(
                              item.data![index].displayNameWOExt,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "${item.data![index].artist}",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 184, 183, 183)),
                            ),
                            leading: Icon(Icons.music_note),
                            trailing: Icon(Icons.more_horiz),
                            onTap: () {
                              // playSongs(item.data![index].uri);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayScreen(
                                            songModel: item.data![index],
                                            audioPlayer: _audioPlayer,
                                          )));
                            },
                          ),
                        ),
                      );
                    });
              },
            ))
          ],
        )),
      ),
    );
  }
}
