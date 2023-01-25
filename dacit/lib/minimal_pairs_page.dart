import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dacit/audio_player.dart';

class MinimalPairs extends StatefulWidget {
  const MinimalPairs({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MinimalPairsState();
}

class MinimalPairsState extends State<MinimalPairs> {
  late Future<Minpair> _minpair;
  late AudioPlayer player;
  @override
  void initState() {
    super.initState();
    _minpair = getMinPair();
    player = AudioPlayer(source: source, onDelete: null);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Sind diese beiden Worte gleich?"),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FutureBuilder<Minpair>(
                  future: _minpair,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ElevatedButton(
                          onPressed: () async {
                            await player
                                .setUrl(snapshot.data!.firstAudio.toString());
                            player.play();
                          },
                          child: const Text('A'));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.done),
                      tooltip: 'Test connection',
                      onPressed: () {
                        getMinPair();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Test connection',
                      onPressed: () {
                        getMinPair();
                      },
                    ),
                  ],
                ),
                FutureBuilder<Minpair>(
                  future: _minpair,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ElevatedButton(
                          onPressed: () async {
                            await player
                                .setUrl(snapshot.data!.secondAudio.toString());
                            player.play();
                          },
                          child: const Text('B'));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}

Future<Minpair> getMinPair() async {
  var response =
      await http.get(Uri.parse("http://localhost:8000/minpair?category=K_T"));
  if (response.statusCode == 200) {
    return Minpair.fromJson(json.decode(response.body));
//    audioSource = ap.AudioSource.uri(minPair.firstAudio);
  } else {
    throw Exception("Failed to load Minpair!");
  }
}

class Minpair {
  final int id;
  final String firstStimulus;
  final Uri firstAudio;
  final String secondStimulus;
  final Uri secondAudio;

  const Minpair(
      {required this.id,
      required this.firstStimulus,
      required this.firstAudio,
      required this.secondStimulus,
      required this.secondAudio});

  factory Minpair.fromJson(Map<String, dynamic> json) {
    return Minpair(
      id: json['minpair'],
      firstStimulus: json["first_stimulus"],
      firstAudio: Uri.parse(json["first_audio"]),
      secondStimulus: json["second_stimulus"],
      secondAudio: Uri.parse(json["second_audio"]),
    );
  }
}
