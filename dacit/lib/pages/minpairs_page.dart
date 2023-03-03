import 'package:dacit/services/minpairs_api.dart';
import 'package:flutter/material.dart';
import 'package:dacit/services/audio_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MinimalPairs extends StatefulWidget {
  const MinimalPairs({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MinimalPairsState();
}

class MinimalPairsState extends State<MinimalPairs> {
  late Future<Minpair> _minpair;
  //late AudioPlayer player;
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    super.initState();
    _minpair = getMinPair();
    //  player = AudioPlayer(source: source, onDelete: null);
  }

  @override
  void dispose() {
    //  player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimalpaare'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context).minimalPairsDesc),
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
//                            audioPath = snapshot.data.firstAudio.toString();
                            //player.play();
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
                AudioPlayer(
                  source: audioPath!,
                  onDelete: () {
                    setState(() => showPlayer = false);
                  },
                )
                // FutureBuilder<Minpair>(
                //   future: _minpair,
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       // return ElevatedButton(
                //       //     onPressed: () async {
                //       //       await player
                //       //           .setUrl(snapshot.data!.secondAudio.toString());
                //       //       player.play();
                //       //     },
                //           child: const Text('B'));
                //     } else if (snapshot.hasError) {
                //       return Text('${snapshot.error}');
                //     }
                //     return const CircularProgressIndicator();
                //   },
                // ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
