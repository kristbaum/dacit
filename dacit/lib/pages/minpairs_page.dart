import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:dacit/main.dart';
import 'package:dacit/services/globals.dart';
import 'package:dacit/services/min_pair.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class MinimalPairsPage extends StatefulWidget {
  const MinimalPairsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MinimalPairsPageState();
}

class _MinimalPairsPageState extends State<MinimalPairsPage> {
  bool _showPlayer = false;
  late MinPair minPair;
  bool _loadNewMP = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  //String? _audioPath;
  //String? _audioPath_2;

  @override
  void initState() {
    _showPlayer = false;
    super.initState();
    //futureTextStimulus = fetchTextStimulus();
  }

  Future<void> _refreshMinPair() async {
    setState(() {
      _showPlayer = false;
      _loadNewMP = true;
      //minPair = null;
    });
  }

  Future<MinPair> _fetchMinPair() async {
    final response = await http.get(
      Uri.parse('${baseDomain}api/minpair'),
      headers: {
        "Authorization": "Token ${user.token}",
      },
    );

    if (response.statusCode == 200) {
      log.info("Downloading new Minpair");
      return MinPair.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load new text');
    }
  }

  Future<MinPair> _postMinPairAnswer(answerEqual) async {
    final response =
        await http.post(Uri.parse('${baseDomain}api/minpair'), headers: {
      "Authorization": "Token ${user.token}",
    }, body: {
      "minpair": minPair.id,
      "answer_equal": answerEqual
    });

    if (response.statusCode == 200) {
      log.info("Downloading new Minpair");
      return MinPair.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load new text');
    }
  }

  @override
  Widget build(BuildContext context) {
    Icon icon;
    Color color;

    if (_audioPlayer.state == PlayerState.playing) {
      icon = const Icon(Icons.pause, color: Colors.red);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow);
      color = theme.primaryColor;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).minimalPairs),
        ),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(25.0),
                  child: const Text(
                      "Gibt es einen Unterschied in den folgenden Aufnahmen:")),
              Container(
                  padding: const EdgeInsets.all(25.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0))),
                  child: FutureBuilder<MinPair>(
                    future: _fetchMinPair(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        minPair = snapshot.data!;
                        _showPlayer = true;
                        log.info(minPair.firstAudio);
                        String firstAudioUrl =
                            "${baseDomain}api/download/${minPair.firstAudio}";
                        log.info(firstAudioUrl);
                        _audioPlayer.setSource(UrlSource(firstAudioUrl));
                        return Text(minPair.category);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    color: color,
                    icon: icon,
                    onPressed: () {
                      String firstAudioUrl =
                          "${baseDomain}api/download/${minPair.firstAudio}";
                      log.info(firstAudioUrl);
                      //_audioPlayer.setSource(UrlSource(firstAudioUrl));
                      _audioPlayer.play(UrlSource(firstAudioUrl));
                    },
                  ),
                  IconButton(
                    color: color,
                    icon: icon,
                    onPressed: () {
                      String firstAudioUrl =
                          "${baseDomain}api/download/${minPair.secondAudio}";
                      log.info(firstAudioUrl);
                      //_audioPlayer.setSource(UrlSource(firstAudioUrl));
                      _audioPlayer.play(UrlSource(firstAudioUrl));
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _postMinPairAnswer(false);
                      _refreshMinPair();
                    },
                    icon: const Icon(
                      Icons.stop,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _postMinPairAnswer(true);
                      _refreshMinPair();
                    },
                    icon: const Icon(
                      Icons.check,
                    ),
                  ),
                ],
              ),
            ])));
  }
}
