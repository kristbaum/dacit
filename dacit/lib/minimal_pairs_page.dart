import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:dacit/micro_player.dart';

class MinimalPairs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Main();
  }
}

/// This is the stateless widget that the main application instantiates.
class Main extends StatelessWidget {
  ap.AudioSource? audioSource = ap.AudioSource.uri(Uri.parse(
      "blob:http://localhost:36257/54e66aef-6486-4f8c-9488-4dfba21cbe4d"));
  //ap.AudioSource? audioSource = ap.AudioSource.uri(Uri.parse(
  //"https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MinimalPairs'),
        ),
        body: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: MicroPlayer(
              source: audioSource!,
              onDelete: () {},
            ),
          ),
          Center(child: Text('See your messages here!')),
        ]));
  }
}
